#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
#include <netdb.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <sys/socket.h>
#include <unistd.h>
#include <time.h>
#include <sys/wait.h>
#include <sys/time.h>
#include <arpa/inet.h>

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
	scanf("%s", isbn);
}

// Obtem o parametro a ser enviado para o servidor
void lerParametro(char *parametro, char *mensagem) {
	printf("%s", mensagem);
	bzero(parametro, 7);
	scanf("%s", parametro);
}

// Monta a request
void montarMensagem(char* buffer, char* operacao, char* documento, char* isbn, char* parametro) {
	bzero(buffer, BUFFER_SIZE + 1);
	snprintf(buffer, BUFFER_SIZE, "%s;%s;%s;%s;", documento, operacao, isbn, parametro);
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

int fimDaResponse(char* request) {
	char* index = strstr(request, RESPONSE_END);
	return (index != NULL);
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
    //if ((sock_fd = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP)) < 0) {
	if ((sock_fd = socket(AF_INET, SOCK_DGRAM, 0)) < 0) {
       	perror("erro ao criar descritor de socket");
       	exit(1);
    }

	memset((char *) &their_addr, 0, sizeof(their_addr));
	
	// Configura a ordem dos bytes
    their_addr.sin_family = AF_INET;         
	
	// Seta a porta de conexao
	their_addr.sin_port = htons(porta);
	
	// Seta o endereco do host
	//their_addr.sin_addr = *((struct in_addr *)he->h_addr);
	if (inet_aton(host, &their_addr.sin_addr)==0) {
		fprintf(stderr, "inet_aton() failed\n");
        exit(1);
    }
	
    bzero(&(their_addr.sin_zero), 8);

    printf("Inicializando conexao com o servidor: %d.%d.%d.%d:%d\n", (int)their_addr.sin_addr.s_addr&0xFF, 
		(int)((their_addr.sin_addr.s_addr&0xFF00)>>8), 
		(int)((their_addr.sin_addr.s_addr&0xFF0000)>>16), 
		(int)((their_addr.sin_addr.s_addr&0xFF000000)>>24),
		ntohs(their_addr.sin_port));
	
    
	printf("Cliente inicializado com sucesso\n");
		
	// Obtem o documento do usuario
	printf("Entre com o documento do usuario: ");
	bzero(documentoUsuario, 5);
	scanf("%s", &documentoUsuario);

	// Timer para medir o tempo de execucao de cada operacao
	struct timeval startTimer;

	int sin_size = sizeof(their_addr);
	
	// Loop infinito tratando as demandas do usuario
    while (1) {
			
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
		
		// Obtem o tempo inicial
		gettimeofday(&startTimer, NULL);
		
		// Envia a mensagem para o servidor
		if (sendto(sock_fd, buffer, BUFFER_SIZE, 0, (struct sockaddr*)&their_addr, sizeof(their_addr)) < 0) {
			perror("erro ao escrever no socket");
			exit(1);
		}

		// ------ Lendo a resposta do servidor -------------------------------------
		
		// Trata response para obter todos os isbns
		if (operacao == 1) {
			printf("ISBN       - TITULO\n");
			while (1) {
				bzero(buffer, BUFFER_SIZE + 1);
				
				if (recvfrom(sock_fd, buffer, BUFFER_SIZE,0, &their_addr, &sin_size) < 0) {
					perror("erro ao ler o socket");
					exit(1);
				}
				
				// Verifica se o usuario e valido
				notificarUsuarioInvalido(buffer);

				// Termina de ler ao receber RESPONSE_END
				if (strcmp(buffer, RESPONSE_END) == 0 || strcmp(buffer, RESPONSE_USUARIO_INVALIDO) == 0) {
					break;
				} else {
					printf("%s", buffer);
				}
			}			
		} 
		
		// Trata response para obter livro por isbn
		else if (operacao == 3) {
		
			bzero(buffer, BUFFER_SIZE + 1);
			
			if (recvfrom(sock_fd, buffer, BUFFER_SIZE,0, &their_addr, &sin_size) < 0) {
				 perror("erro ao ler o socket");
				 exit(1);
			}
			
			if (strcmp(buffer, ISBN_INVALIDO) == 0) {
				printf("%s", buffer);
			} else {
			
				// Parse da response
				livro lv = parseDbLineToLivro(buffer);
				
				// Imprime os dados do livro
				printLivro(lv);
			}
		
		}
		
		// Trata response para obter todos os livros
		else if (operacao == 4) {
		
			char bf[BUFFER_SIZE + 1];
			while (1) {
				bzero(bf, BUFFER_SIZE + 1);
				if (recvfrom(sock_fd, bf, BUFFER_SIZE,0, &their_addr, &sin_size) < 0) {
					perror("erro ao ler o socket");
					exit(1);
				}
				
				// Verifica se o usuario e valido
				notificarUsuarioInvalido(bf);

				// Termina de ler ao receber RESPONSE_END
				if (fimDaResponse(bf) || strcmp(bf, RESPONSE_END) == 0 || strcmp(bf, RESPONSE_USUARIO_INVALIDO) == 0) {
					break;
				} else {
					livro lv = parseDbLineToLivro(bf);
					printLivro(lv);
				}
			}
		}
		
		else {

			if (operacao == 2) {
				printf("\n\n\tDESCRICAO: ");
			}

			if (operacao == 5) {
				printf("\n\n\tRESPOSTA DO SERVIDOR: ");
			}

			if (operacao == 6) {
				printf("\n\n\tNR DE EXEMPLARES: ");
			}
		
			bzero(buffer, BUFFER_SIZE + 1);
			if (recvfrom(sock_fd, buffer, BUFFER_SIZE,0, &their_addr, &sin_size) < 0) {
				 perror("erro ao ler o socket");
				 exit(1);
			}
			
			printf("%s\n",buffer);
			
			// Finaliza client, pois server finalizou a conexao
			if (strcmp(buffer, RESPONSE_END) == 0 || strcmp(buffer, RESPONSE_USUARIO_INVALIDO) == 0) {
				break;
			}
		}
		
		// Loga o tempo de execucao
		logarTempo2(CLIENT, traduzirOperacao(operacao), startTimer);
		
		// Finaliza client para usuario invalido
		if (strcmp(buffer, RESPONSE_USUARIO_INVALIDO) == 0) {
			break;
		}
		
    	}

	printf("Fechando conexao\n");
    	close(sock_fd);
}
