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

#include "server.h"
#include "utils.h"
#include "controleacesso.h"
#include "amazonservice.h"

// Nr de conexoes pendentes na fila
#define SERVER_BACKLOG 15

// Le o comando enviado pelo cliente e autentica usuario pelo nr do documento
void ler_comando(int new_fd) {

	char buffer[256];
	bzero(buffer,256);
	if (read(new_fd,buffer, 255) < 0) {
        	perror("erro ao ler do socket");
	        exit(1);
	}

	printf("Tratando comando '%s'\n", buffer);
	
	// Quebra o comando no vetor 
	char* comando[3];
	csvParse(buffer, comando, 3);
	
	printf("user id: %s\n", comando[0]);
	
	// Obtem o usuario
	Usuario usuario = obterUsuarioPorDocumento(atoi(comando[0]));
	if (usuario == NULL){
		
		// retornar usuario invalido 
		strcpy(buffer, RESPONSE_USUARIO_INVALIDO);
		if (write(new_fd, buffer, 255) < 0) {
			perror("erro ao escrever no socket");
			exit(1);
		}
	} else {
		printf("Tratando conexao do usuario %s\n", usuario->nome);
	}
	
	if (strcmp(comando[1], OBTER_TODOS_ISBNS) == 0) {
	
		char* isbns = obterTodosISBNS();
		if (write(new_fd, isbns, strlen(isbns)) < 0) {
			perror("erro ao escrever no socket");
			exit(1);
		}		
		
	} else if (strcmp(comando[1], OBTER_DESCRICAO_POR_ISBN) == 0) {
	
		char* descricao = obterDescricaoPorISBN(comando[2]);
		if (write(new_fd, descricao, strlen(descricao)) < 0) {
			perror("erro ao escrever no socket");
			exit(1);
		}	
		
	} else if (strcmp(comando[1], OBTER_LIVRO_POR_ISBN) == 0) {
	
		printf("OBTER_LIVRO_POR_ISBN\n");
		
	} else if (strcmp(comando[1], OBTER_TODOS_LIVROS) == 0) {
		
		printf("OBTER_TODOS_LIVROS\n");
		
	} else if (strcmp(comando[1], ALTERAR_NR_EXEMPLARES_ESTOQUE) == 0) {
//		*param = atoi(comando[2]);
		printf("ALTERAR_NR_EXEMPLARES_ESTOQUE\n");
		
	} else if (strcmp(comando[1], OBTER_NR_EXEMPLARES_ESTOQUE) == 0) {
		printf("OBTER_NR_EXEMPLARES_ESTOQUE\n");
	}

}


// Trata as novas conexoes
void tratar_conexao(int new_fd) {
	
	// Le o comando enviado pelo cliente
	ler_comando(new_fd);
	
	    // Fecha a conexao do filho
	close(new_fd);
	
	// Finaliza o processo filho
	exit(0);
}

void executarServidor(char* porta) {

	printf("inicializando servidor no porta '%s'....\n", porta);

	// server ouvindo em sock_fd
	int sock_fd;
	
	// novas conexoes em new_fd
	int	new_fd;  
	
	// informacoes da endereco da conexao
	struct sockaddr_in my_addr;
	
	// informacoes das conexoes
    	struct sockaddr_in their_addr;
    	int sin_size;
	void *yes;

	if ((sock_fd = socket(AF_INET, SOCK_STREAM, 0)) == -1) {
	        perror("erro ao abrir o socket");
        	exit(1);
    	}

	if (setsockopt(sock_fd, SOL_SOCKET, SO_REUSEADDR, &yes, sizeof(int)) == -1) {
	        perror("erro ao configurar socket setsockopt");
        	exit(1);
   	}

	// Configura o endereco da conexao
	my_addr.sin_family = AF_INET;
//	my_addr.sin_port = htons(porta);
	my_addr.sin_port = htons(25933);
	my_addr.sin_addr.s_addr = INADDR_ANY;
	bzero(&(my_addr.sin_zero), 8);

	printf("my address: %d.%d.%d.%d\n", (int)my_addr.sin_addr.s_addr&0xFF, (int)((my_addr.sin_addr.s_addr&0xFF00)>>8), (int)((my_addr.sin_addr.s_addr&0xFF0000)>>16), (int)((my_addr.sin_addr.s_addr&0xFF000000)>>24));
	printf("my port is %d\n", ntohs(my_addr.sin_port));
	
	// Bind socket address
	if (bind(sock_fd, (struct sockaddr *)&my_addr, sizeof(struct sockaddr)) == -1) {
	        perror("erro ao fazer socket bind");
        	exit(1);
    	}
	
	// List socket
	if (listen(sock_fd, SERVER_BACKLOG) == -1) {
		perror("erro ao ouvir o socket");
        	exit(1);
	}

	// Fica em loop aceitando as conexoes
	    while(1) {
	        sin_size = sizeof(struct sockaddr_in);
	        if ((new_fd = accept(sock_fd, (struct sockaddr *)&their_addr, &sin_size)) == -1) {
	            perror("erro ao aceitar a conexao");
	            continue;
        	}
		
//        	printf("server: tratando conexao de %s\n", inet_ntoa(their_addr.sin_addr));
		printf("tratando conexao...\n");
		
		// Cria um novo processo para tratar a nova conexao
	        if (!fork()) {
			tratar_conexao(new_fd);
	        }
		
		// Processo principal n? referencia a nova conexao
        	close(new_fd);

		// Aguarda para remove todos os processos filhos
       		while(waitpid(-1,NULL,WNOHANG) > 0);
    	}
	
	return EXIT_SUCCESS;
}
