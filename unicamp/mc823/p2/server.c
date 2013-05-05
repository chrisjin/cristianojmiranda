/**
 * 
 */
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <sys/socket.h>
#include <sys/wait.h>
#include <sys/time.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <netdb.h>

#include "mem.h"
#include "server.h"
#include "utils.h"
#include "controleacesso.h"
#include "amazonservice.h"

#define BUFFER_SIZE 255

int sin_size;

// Trata a obtencao dos isbns
void obterTodosIsbns(int sock_fd, struct sockaddr_in* their_addr) {

	// Obtem o tempo inicial
	struct timeval inicio;
	gettimeofday(&inicio, NULL);


	// Pesquisa todos os isbns
	char* isbns = obterTodosISBNS();
	if (strlen(isbns) <= BUFFER_SIZE) {	
		enviar_mensagem(sock_fd, isbns, their_addr);
	} else {
	
		int ponteiroInicial = 0;
		int ponteiroFinal = BUFFER_SIZE;
		while(ponteiroInicial < strlen(isbns)) {
		
			char* envio = strSubString(isbns, ponteiroInicial, ponteiroFinal);
			enviar_mensagem(sock_fd, envio, their_addr);
			
			ponteiroInicial += BUFFER_SIZE;
			ponteiroFinal += BUFFER_SIZE;
			
			if (ponteiroFinal > strlen(isbns)) {
				ponteiroFinal = strlen(isbns);
			}
		}
	
	}
	
	// Escreve final da response
	printf("enviando response_end\n");
	
	// TODO: Atencao pode ter problema aqui com o tamanha da response usar  strlen(RESPONSE_END)
	enviar_mensagem(sock_fd, RESPONSE_END, their_addr);
	
	// Loga o tempo de execucao
	logarTempo2(SERVER, OBTER_TODOS_ISBNS, inicio);
}

// Trata a consulta de descricao por isbn
void tratarObterDescricaoPorIsbn(int sock_fd, struct sockaddr_in* their_addr, char* isbn) {

	// Obtem o tempo inicial
	struct timeval inicio;
	gettimeofday(&inicio, NULL);

	// Obtem descricao por isbn
	char* descricao = obterDescricaoPorISBN(isbn);
	
	if (descricao == NULL) {
		enviar_mensagem(sock_fd, ISBN_INVALIDO, their_addr);
	} else {
		enviar_mensagem(sock_fd, descricao, their_addr);
	}
	
	// Loga o tempo de execucao
	logarTempo2(SERVER, OBTER_DESCRICAO_POR_ISBN, inicio);
}

// Trata a pesquisa de todos os dados de um livro
void tratarObterLivro(int sock_fd, struct sockaddr_in* their_addr, char* isbn) {

	// Obtem o tempo inicial
	struct timeval inicio;
	gettimeofday(&inicio, NULL);

	// Pesquisa o livro na base
	livro lv = obterLivroPorISBN(isbn);
	
	if (lv == NULL) {
		enviar_mensagem(sock_fd, ISBN_INVALIDO, their_addr);
	} else {
		char* line = buildCsvLine(lv, BUFFER_SIZE - 10);
		enviar_mensagem(sock_fd, line, their_addr);
	}
	
	// Loga o tempo de execucao
	logarTempo2(SERVER, OBTER_LIVRO_POR_ISBN, inicio);

}

// Obtem o numero de exemplares em estoque da livraria
void obterExemplaresEmEstoque(int sock_fd, struct sockaddr_in* their_addr, char* isbn) {

	// Obtem o tempo inicial
	struct timeval inicio;
	gettimeofday(&inicio, NULL);
	
	printf("obterExemplaresEmEstoque() - isbn: %s.\n", isbn);

	// Obtem a quantidade de exemplares em estoque
	int qtd = obterNrExemplaresEstoque(isbn);
	printf("Quntidade obtida: %d.\n", qtd);
	
	if (qtd < 0) {
		enviar_mensagem(sock_fd, ISBN_INVALIDO, their_addr);
	} else {
	
		char* buffer = MEM_ALLOC_N(char, BUFFER_SIZE + 1);
		bzero(buffer, BUFFER_SIZE);
		snprintf(buffer, BUFFER_SIZE, "%d", qtd);
		
		enviar_mensagem(sock_fd, buffer, their_addr);
	}
	
	// Loga o tempo de execucao
	logarTempo2(SERVER, OBTER_NR_EXEMPLARES_ESTOQUE, inicio);
}

// Altera o nr de exmplares em estoque da livraria
void alterarNrExemplaresEstoque(int sock_fd, struct sockaddr_in* their_addr, char* isbn, int qtd, Usuario usuario) {

	// Obtem o tempo inicial
	struct timeval inicio;
	gettimeofday(&inicio, NULL);

	printf("alterando o nr exemp em estoque do isbn %s para %d\n", isbn, qtd);

	//  Verifica se o usuario pode realizar essa operacao
	if (strcmp(usuario->tipoUsuario, USUARIO_CLIENTE) == 0) {
		// Notifica usuario sem acesso
		enviar_mensagem(sock_fd, RESPONSE_USUARIO_SEM_PERMISSAO, their_addr);
	} else {
	
		// Altera o numero de exemplares em estoque
		int rt = alterarNrExemplaresEstoquePorISBN(isbn, qtd);
		
		if (rt < 0) {
			// Notifica isbn invalido
			enviar_mensagem(sock_fd, ISBN_INVALIDO, their_addr);
		} else {
			// Notifica operacao realizada com sucesso
			enviar_mensagem(sock_fd, RESPONSE_OK, their_addr);
		}
	}
	
	// Loga o tempo de execucao
	logarTempo2(SERVER, ALTERAR_NR_EXEMPLARES_ESTOQUE, inicio);
}

// Trata a consulta a todos os dados de livros
void obterTodosLivros(int sock_fd, struct sockaddr_in* their_addr) {

	// Obtem o tempo inicial
	struct timeval inicio;
	gettimeofday(&inicio, NULL);

	// Localiza todos os livros da base
	int list_size;
	livro_list livros = obtemTodosLivros(&list_size);
	livro_list it = livros;

	printf("foram encontrados %d livros\n", list_size);
	
	// Caso nao exista livros na base
	if (list_size > 0) {
	
		int contador = 0;
		while (it != NULL) {
			livro lv = it->titulo;
			if (lv != NULL) {
		
				// Converte o livro em csv line
				char* line = buildCsvLine(lv, BUFFER_SIZE - 10);

				// Completa o tamanho da request com ';' para alinhar os buffers
				char* ln = completeString(line, ";", BUFFER_SIZE);

				// Envia a mensagem para o servidor
				enviar_mensagem(sock_fd, ln, their_addr);
			}

			if (++contador == list_size) {
				break;
			}
			it = it->proximo;
		}
	}
	
	// Escreve final da response
	printf("enviando response_end\n");
	char* lnEnd = completeString(RESPONSE_END, ";", BUFFER_SIZE);
	enviar_mensagem(sock_fd, lnEnd, their_addr);
	
	// Loga o tempo de execucao
	logarTempo2(SERVER, OBTER_TODOS_LIVROS, inicio);

}

/**
 * Envia mensagem para o cliente
 */
void enviar_mensagem(int sock_fd, char* buffer, struct sockaddr_in* their_addr) {

	printf("Enviando mensagen para o cliente: '%s'\n", buffer);
	printf("Endereco Cliente %s:%d\n", inet_ntoa(their_addr->sin_addr), ntohs(their_addr->sin_port));

	int strLen = strlen(buffer);
	size_t sizeAddr = sizeof(their_addr);
	//if (sendto(sock_fd, buffer, strLen, 0, (struct sockaddr *)&their_addr, sizeAddr) < 0) {
	/*if (sendto(sock_fd, buffer, strLen, 0, (struct sockaddr *)&their_addr, sizeof(their_addr)) < 0) {
		perror("erro ao escrever no socket");
		exit(1);
	}*/
	
	// TODO: fake remove me
	if (sendto(sock_fd, "budega!", strlen("budega!"), 0, (struct sockaddr *)&their_addr, sizeof(their_addr)) == -1) {
		perror("erro ao escrever no socket");
		exit(1);
	}
}

// Trata as novas conexoes
void tratar_mensagem(int sock_fd, char buffer[BUFFER_SIZE+1], struct sockaddr_in* their_addr, socklen_t sin_size){

	printf("Tratando comando '%s'\n", buffer);
	
	// Quebra o comando no vetor 
	char* comando[4];
	csvParse(buffer, comando, 4);
	
	// Obtem o usuario
	Usuario usuario = obterUsuarioPorDocumento(atoi(comando[0]));
	if (usuario == NULL){
	
		// retornar usuario invalido 
		strcpy(buffer, RESPONSE_USUARIO_INVALIDO);
		enviar_mensagem(sock_fd, buffer, their_addr);

	} else {
		printf("Tratando conexao do usuario '%s'\n", usuario->nome);
	}

	if (strcmp(comando[1], OBTER_TODOS_ISBNS) == 0) {
	
		obterTodosIsbns(sock_fd, their_addr);
		
	} else if (strcmp(comando[1], OBTER_DESCRICAO_POR_ISBN) == 0) {

		tratarObterDescricaoPorIsbn(sock_fd, their_addr, comando[2]);
	
	} else if (strcmp(comando[1], OBTER_LIVRO_POR_ISBN) == 0) {

		tratarObterLivro(sock_fd, their_addr, comando[2]);
	
	} else if (strcmp(comando[1], OBTER_TODOS_LIVROS) == 0) {
		
		obterTodosLivros(sock_fd, their_addr);
		
	} else if (strcmp(comando[1], ALTERAR_NR_EXEMPLARES_ESTOQUE) == 0) {
		
		alterarNrExemplaresEstoque(sock_fd, their_addr, comando[2], atoi(comando[3]), usuario);
		
	} else if (strcmp(comando[1], OBTER_NR_EXEMPLARES_ESTOQUE) == 0) {
	
		obterExemplaresEmEstoque(sock_fd, their_addr, comando[2]);
		
	} else if (strcmp(comando[1], REQUEST_END) == 0) {

		printf("Finalizando conexao com o cliente...\n");

		// Envia mensagem para o cliente finalizar a conexao
		strcpy(buffer, RESPONSE_END);
		enviar_mensagem(sock_fd, buffer, their_addr);

	} else {
		// Notifica o cliente sobre comando invalido
		strcpy(buffer, RESPONSE_COMANDO_INVALIDO);
		enviar_mensagem(sock_fd, buffer, their_addr);
		printf("comando invalido\n");
	}
}

// Executa o servidor na porta parametrizada
void executarServidor(int porta) {

	printf("inicializando servidor na porta '%d'....\n", porta);

	// server ouvindo em sock_fd
	int sock_fd;
	
	// informacoes da endereco da conexao
	struct sockaddr_in my_addr;
	
	// informacoes das conexoes
    struct sockaddr_in their_addr;

	void *yes;
	//if ((sock_fd = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP)) == -1) {
	if ((sock_fd = socket(AF_INET, SOCK_DGRAM, 0)) == -1) {
	    perror("erro ao abrir o socket");
       	exit(1);
    }

	// TODO: Verificar se necessario comitar isso!
	if (setsockopt(sock_fd, SOL_SOCKET, SO_REUSEADDR, &yes, sizeof(int)) == -1) {
	    perror("erro ao configurar socket setsockopt");
        exit(1);
   	}

	// Configura o endereco da conexao
	memset((char *) &my_addr, 0, sizeof(my_addr));
	bzero(&my_addr, sizeof(my_addr));
	my_addr.sin_family = AF_INET;
	my_addr.sin_port = htons(porta);
	my_addr.sin_addr.s_addr = htonl(INADDR_ANY);
	//bzero(&(my_addr.sin_zero), 8);
	
	// Bind socket address
	if (bind(sock_fd, (struct sockaddr*)&my_addr, sizeof(my_addr)) == -1) {
		perror("erro ao fazer socket bind");
        exit(1);
    }
	
	printf("Servidor operando em: %d.%d.%d.%d:%d\n", (int)my_addr.sin_addr.s_addr&0xFF, 
		(int)((my_addr.sin_addr.s_addr&0xFF00)>>8), 
		(int)((my_addr.sin_addr.s_addr&0xFF0000)>>16), 
		(int)((my_addr.sin_addr.s_addr&0xFF000000)>>24), 
		ntohs(my_addr.sin_port));

	char buffer[BUFFER_SIZE + 1];

	// Fica em loop aceitando as conexoes
	while(1) {

		// Limpa o buffer de mensagem
		bzero(buffer, BUFFER_SIZE + 1);

		// Recebe mensagem do cliente via datagrama
	    sin_size = sizeof(their_addr);
		if (recvfrom(sock_fd, buffer, BUFFER_SIZE,0, &their_addr, &sin_size) < 0) {
			perror("erro ao aceitar a conexao");
	        continue;
        }
		
		printf("message: '%s'\n", buffer);

		// Trata a mensagem do cliente
		tratar_mensagem(sock_fd, buffer, &their_addr, sin_size);
		
		// TODO: apenas um test
		/*if (sendto(sock_fd, "budega!", strlen("budega!"), 0, (struct sockaddr *)&their_addr, sizeof(their_addr)) == -1) {
			perror("erro sendto");
			exit(1);
		}*/
		
		printf("resposta enviada!\n");
    }
}
