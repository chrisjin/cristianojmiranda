#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
#include <netdb.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <sys/socket.h>
#include <unistd.h>
#include <sys/times.h>
#include <time.h>
#include <sys/wait.h>

#include "client.h"
#include "amazonservice.h"

#define BUFFER_SIZE 255

// Imprime o menu de operacoes
void printMenu() {
	printf("\n===== MENU =====\n");	
	printf(" 1 - OBTER TODOS ISBNS\n");
	printf(" 2 - OBTER DESCRICAO POR_ISBN\n");
	printf(" 3 - OBTER LIVRO POR ISBN\n");
	printf(" 4 - OBTER TODOS LIVROS\n");
	printf(" 5 - ALTERAR NR EXEMPLARES ESTOQUE\n");
	printf(" 6 - OBTER NR EXEMPLARES ESTOQUE\n\n");
	printf("Entre com uma operacao: ");
}

// Obter operacao desejada pelo cliente
int lerOperacao() {

	int op = -1;

	do {
		scanf("%d", &op);
		
	} while (op <= 0 || op > 6);
	
	return op;
}

// Obtem um ISBN para operar
void lerISBN(char* isbn) {
	printf("Informe o ISBN: ");
	bzero(isbn, 11);
	//fgets(isbn, 10, stdin);
	scanf("%s", &isbn);
}

// Obtem o parametro a ser enviado para o servidor
void lerParametro(char *parametro, char *mensagem) {
	printf("%s", mensagem);
	bzero(parametro, 7);
	//fgets(parametro, 6, stdin);
	scanf("%s", &parametro);
}

// Monta a request
void montarMensagem(char* buffer, char* operacao, char* documento, char* isbn, char* parametro) {
	bzero(buffer, BUFFER_SIZE + 1);
	snprintf(buffer, BUFFER_SIZE, "%s;%s;%s;%s;", documento, operacao, isbn, parametro);
	printf("request '%s'\n", buffer);
}

// Verifica se o usuario e valido
void notificarUsuarioInvalido(char *response) {

	if (strcmp(response, RESPONSE_USUARIO_INVALIDO) == 0) {
		printf("Usuario invalido. Fechando a conexao.\n");
	}

}

// Verifica se o usuario sem acesso a operacao
void notificarUsuarioSemAcesso(char *response) {

	if (strcmp(response, RESPONSE_USUARIO_SEM_PERMISSAO) == 0) {
		printf("Usuario nao tem acesso para executar essa operacao.\n");
	}

}

// Obtem a operacao a ser enviada na request
char* traduzirOperacao(int operacao) {

	if (operacao == 1) {
	
		return OBTER_TODOS_ISBNS;
		
	} else if (operacao == 2) {
	
		return OBTER_DESCRICAO_POR_ISBN;
		
	} else if (operacao == 3) {
	
		return OBTER_LIVRO_POR_ISBN;
		
	} else if (operacao == 4) {
	
		return OBTER_TODOS_LIVROS;
		
	} else if (operacao == 5) {
	
		return ALTERAR_NR_EXEMPLARES_ESTOQUE;
		
	} else if (operacao == 6) {
	
		return OBTER_NR_EXEMPLARES_ESTOQUE;
		
	} 
	
	return "XX";
}

// Executa o cliente
void executarCliente(int porta, char* host) {	

	printf("Inicializando cliente....\n");
	
	// Descritor de socket
	int sock_fd;
	struct hostent *he;
	
	// Endereco de conexao
    	struct sockaddr_in their_addr;   

	// Cronometros
    	clock_t startTime, endTime;
    	float elapsedTime;
    	struct timeval tv;
	
	// Buffer de troca de mensagem entre o servidor e o cliente
	char buffer[BUFFER_SIZE + 1];
	
	// Documento do usuario
	char documentoUsuario[5];
	
	// Armazena o isbn para operar
	char isbn[11];
	
	// Parametro de integração do servico
	char parametro[7];

	// Obtendo endereco do host
	if ((he=gethostbyname(host)) == NULL) {
        	perror("erro ao resolver host name");
        	exit(1);
    	}

	// Criando descritor de socket
    	if ((sock_fd = socket(AF_INET, SOCK_STREAM, 0)) < 0) {
        	perror("erro ao criar descritor de socket");
        	exit(1);
    	}

	// Configura a ordem dos bytes
    	their_addr.sin_family = AF_INET;         
	
	// Seta a porta de conexao
	their_addr.sin_port = htons(porta);
	
	// Seta o endereco do host
	their_addr.sin_addr = *((struct in_addr *)he->h_addr);
    	bzero(&(their_addr.sin_zero), 8);

    	printf("Inicializando conexao com o servidor: %d.%d.%d.%d:%d\n", (int)their_addr.sin_addr.s_addr&0xFF, 
		(int)((their_addr.sin_addr.s_addr&0xFF00)>>8), 
		(int)((their_addr.sin_addr.s_addr&0xFF0000)>>16), 
		(int)((their_addr.sin_addr.s_addr&0xFF000000)>>24),
		ntohs(their_addr.sin_port));
	
	// Conectando ao host
    	if (connect(sock_fd, (struct sockaddr *)&their_addr, sizeof(struct sockaddr)) < 0) {
        	perror("erro ao conectar ao server");
        	exit(1);
    	}
    
	// Inicia a conta
    	startTime = times(NULL);
    
		printf("Cliente inicializado com sucesso\n");
		
		// Obtem o documento do usuario
		printf("Entre com o documento do usuario: ");
		bzero(documentoUsuario, 5);
		//fgets(documentoUsuario, 4, stdin);
		scanf("%s", &documentoUsuario);
		
		
		
    	while (1) {
        
			// Inicializa o timer
        	tv.tv_sec = 5;
        	tv.tv_usec = 0;
			
			// Imprime o menu e obtem a operacao
			printMenu();
			int operacao = lerOperacao();
			
			// Caso seja necessario obter isbn
			bzero(isbn, 11);
			if (operacao == 2 || operacao == 3 || operacao == 5 || operacao == 6) {
				lerISBN(isbn);
			}
			
			// Caso necessario paramtro para alterar o nr de exemplares
			bzero(parametro, 7);
			if (operacao == 5) {
				lerParametro(parametro, "Entre com o novo numero de exemplares: ");
		}
			
		// Monta request
		montarMensagem(buffer, traduzirOperacao(operacao), documentoUsuario, isbn, parametro);
		
		// Envia a mensagem para o usuario
		//printf("enviando mensagem...\n");
		if (write(sock_fd, buffer, strlen(buffer)) < 0) {
			 perror("erro ao escrever no socket");
			 exit(1);
		}

		// Le a resposta do servidor
		
		if (operacao == 1) {
			
			while (1) {
				printf(".");
				bzero(buffer, BUFFER_SIZE + 1);
				if (read(sock_fd, buffer, BUFFER_SIZE) < 0) {
					perror("erro ao ler o socket");
					exit(1);
				}
				
				// Verifica se o usuario e valido
				notificarUsuarioInvalido(buffer);

				printf("debug '%s'\n", buffer);				

				// Termina de ler ao receber RESPONSE_END
				if (strcmp(buffer, RESPONSE_END) == 0 || strcmp(buffer, RESPONSE_USUARIO_INVALIDO) == 0) {
					printf("todos os bytes recebidos\n");
					break;
				} else {
					printf("%s", buffer);
				}
			}

			printf("passei aqui...\n");
			
		}
		
		else {
		
			bzero(buffer, BUFFER_SIZE + 1);
			if (read(sock_fd, buffer, BUFFER_SIZE) < 0) {
				 perror("erro ao ler o socket");
				 exit(1);
			}
			
			printf("\tResposta: '%s'\n",buffer);
		}

		// Finaliza client, pois server finalizou a conexao
		if (strcmp(buffer, RESPONSE_END) == 0 || strcmp(buffer, RESPONSE_USUARIO_INVALIDO) == 0) {
			break;
		}
    	}
    
		// Finaliza o timer
    	endTime = times(NULL);
    	elapsedTime = (float)((endTime - startTime) / (float)sysconf(_SC_CLK_TCK));

		printf("Fechando conexao\n");
    	close(sock_fd);
}
