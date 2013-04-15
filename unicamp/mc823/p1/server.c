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
#include<sys/time.h>

#include "mem.h"
#include "server.h"
#include "utils.h"
#include "controleacesso.h"
#include "amazonservice.h"

// Nr de conexoes pendentes na fila
#define SERVER_BACKLOG 15

// Trata a obtencao dos isbns
void obterTodosIsbns(int new_fd) {

	// Obtem o tempo inicial
	struct timeval inicio;
	gettimeofday(&inicio, NULL);


	// Pesquisa todos os isbns
	char* isbns = obterTodosISBNS();
	if (strlen(isbns) <= 255) {
	
		if (write(new_fd, isbns, strlen(isbns)) < 0) {
			perror("erro ao escrever no socket");
			exit(1);
		}
		
	} else {
	
		int ponteiroInicial = 0;
		int ponteiroFinal = 255;
		while(ponteiroInicial < strlen(isbns)) {
		
			char* envio = strSubString(isbns, ponteiroInicial, ponteiroFinal);
			if (write(new_fd, envio, 255) < 0) {
				perror("erro ao escrever no socket");
				exit(1);
			}
			
			ponteiroInicial += 255;
			ponteiroFinal += 255;
			
			if (ponteiroFinal > strlen(isbns)) {
				ponteiroFinal = strlen(isbns);
			}
		}
	
	}
	
	// Escreve final da response
	printf("enviando response_end\n");
	if (write(new_fd, RESPONSE_END, strlen(RESPONSE_END)) < 0) {
		perror("erro ao escrever no socket");
		exit(1);
	}
	
	// Loga o tempo de execucao
	logarTempo2(SERVER, OBTER_TODOS_ISBNS, inicio);
}

// Trata a consulta de descricao por isbn
void tratarObterDescricaoPorIsbn(int new_fd, char* isbn) {

	// Obtem o tempo inicial
	struct timeval inicio;
	gettimeofday(&inicio, NULL);

	// Obtem descricao por isbn
	char* descricao = obterDescricaoPorISBN(isbn);
	
	if (descricao == NULL) {
		
		if (write(new_fd, ISBN_INVALIDO, strlen(ISBN_INVALIDO)) < 0) {
			perror("erro ao escrever no socket");
			exit(1);
		}
		
	} else {	
		if (write(new_fd, descricao, strlen(descricao)) < 0) {
			perror("erro ao escrever no socket");
			exit(1);
		}
	}
	
	// Loga o tempo de execucao
	logarTempo2(SERVER, OBTER_DESCRICAO_POR_ISBN, inicio);
}

// Trata a pesquisa de todos os dados de um livro
void tratarObterLivro(int new_fd, char* isbn) {

	// Obtem o tempo inicial
	struct timeval inicio;
	gettimeofday(&inicio, NULL);

	// Pesquisa o livro na base
	livro lv = obterLivroPorISBN(isbn);
	
	if (lv == NULL) {
	
		if (write(new_fd, ISBN_INVALIDO, strlen(ISBN_INVALIDO)) < 0) {
			perror("erro ao escrever no socket");
			exit(1);
		}
		
	} else {
	
		char* line = buildCsvLine(lv, 245);
		if (write(new_fd, line, strlen(line)) < 0) {
			perror("erro ao escrever no socket");
			exit(1);
		}
	
	}
	
	// Loga o tempo de execucao
	logarTempo2(SERVER, OBTER_LIVRO_POR_ISBN, inicio);

}

// Obtem o numero de exemplares em estoque da livraria
void obterExemplaresEmEstoque(int new_fd, char* isbn) {

	// Obtem o tempo inicial
	struct timeval inicio;
	gettimeofday(&inicio, NULL);
	
	printf("obterExemplaresEmEstoque() - isbn: %s.\n", isbn);

	// Obtem a quantidade de exemplares em estoque
	int qtd = obterNrExemplaresEstoque(isbn);
	printf("Quntidade obtida: %d.\n", qtd);
	
	if (qtd < 0) {
	
		if (write(new_fd, ISBN_INVALIDO, strlen(ISBN_INVALIDO)) < 0) {
			perror("erro ao escrever no socket");
			exit(1);
		}
	
	} else {
	
		char* buffer = MEM_ALLOC_N(char, 256);
		bzero(buffer, 255);
		snprintf(buffer, 255, "%d", qtd);
		
		if (write(new_fd, buffer, strlen(buffer)) < 0) {
			perror("erro ao escrever no socket");
			exit(1);
		}
	
	}
	
	// Loga o tempo de execucao
	logarTempo2(SERVER, OBTER_NR_EXEMPLARES_ESTOQUE, inicio);
}

// Altera o nr de exmplares em estoque da livraria
void alterarNrExemplaresEstoque(int new_fd, char* isbn, int qtd, Usuario usuario) {

	// Obtem o tempo inicial
	struct timeval inicio;
	gettimeofday(&inicio, NULL);

	printf("alterando o nr exemp em estoque do isbn %s para %d\n", isbn, qtd);

	//  Verifica se o usuario pode realizar essa operacao
	if (strcmp(usuario->tipoUsuario, USUARIO_CLIENTE) == 0) {
	
		// Notifica usuario sem acesso
		if (write(new_fd, RESPONSE_USUARIO_SEM_PERMISSAO, strlen(RESPONSE_USUARIO_SEM_PERMISSAO)) < 0) {
			perror("erro ao escrever no socket");
			exit(1);
		}
	
	} else {
	
		// Altera o numero de exemplares em estoque
		int rt = alterarNrExemplaresEstoquePorISBN(isbn, qtd);
		
		if (rt < 0) {
		
			// Notifica isbn invalido
			if (write(new_fd, ISBN_INVALIDO, strlen(ISBN_INVALIDO)) < 0) {
				perror("erro ao escrever no socket");
				exit(1);
			}
		
		} else {		
		
			// Notifica operacao realizada com sucesso
			if (write(new_fd, RESPONSE_OK, strlen(RESPONSE_OK)) < 0) {
				perror("erro ao escrever no socket");
				exit(1);
			}
		
		}
	
	}
	
	// Loga o tempo de execucao
	logarTempo2(SERVER, ALTERAR_NR_EXEMPLARES_ESTOQUE, inicio);
}

// Trata a consulta a todos os dados de livros
void obterTodosLivros(int new_fd) {

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
		
				char* line = buildCsvLine(lv, 245);
				int n = write(new_fd, line, 255);
				printf("n=%d\n", n);
				if (n < 0) {
        				perror("erro ao ler do socket");
				        exit(1);
				}
			}
		
			printf("contador %d\n", contador);
			if (++contador == list_size) {
				break;
			}
			it = it->proximo;
		}
	}
	
	// Escreve final da response
	printf("enviando response_end\n");
	if (write(new_fd, RESPONSE_END, strlen(RESPONSE_END)) < 0) {
		perror("erro ao escrever no socket");
		exit(1);
	}
	
	// Loga o tempo de execucao
	logarTempo2(SERVER, OBTER_TODOS_LIVROS, inicio);

}

// Le o comando enviado pelo cliente e autentica usuario pelo nr do documento
void ler_comando(int new_fd) {

	// Fica em looping atendendo as demanda do client
	while(1) {
	
		char buffer[256];
		bzero(buffer,256);
		if (read(new_fd,buffer, 255) < 0) {
        		perror("erro ao ler do socket");
		        exit(1);
		}

		printf("Tratando comando '%s'\n", buffer);
	
		// Quebra o comando no vetor 
		char* comando[4];
		csvParse(buffer, comando, 4);
	
		// Obtem o usuario
		Usuario usuario = obterUsuarioPorDocumento(atoi(comando[0]));
		if (usuario == NULL){
		
			// retornar usuario invalido 
			strcpy(buffer, RESPONSE_USUARIO_INVALIDO);
			if (write(new_fd, buffer, strlen(buffer)) < 0) {
				perror("erro ao escrever no socket");
				exit(1);
			}

			break;

		} else {
			printf("Tratando conexao do usuario '%s'\n", 
usuario->nome);
		}
	
		if (strcmp(comando[1], OBTER_TODOS_ISBNS) == 0) {
		
			obterTodosIsbns(new_fd);
			
		} else if (strcmp(comando[1], OBTER_DESCRICAO_POR_ISBN) == 0) {
	
			tratarObterDescricaoPorIsbn(new_fd, comando[2]);
		
		} else if (strcmp(comando[1], OBTER_LIVRO_POR_ISBN) == 0) {
	
			tratarObterLivro(new_fd, comando[2]);
		
		} else if (strcmp(comando[1], OBTER_TODOS_LIVROS) == 0) {
		
			obterTodosLivros(new_fd);
		
		} else if (strcmp(comando[1], ALTERAR_NR_EXEMPLARES_ESTOQUE) == 0) {
		
			alterarNrExemplaresEstoque(new_fd, comando[2], atoi(comando[3]), usuario);
		
		} else if (strcmp(comando[1], OBTER_NR_EXEMPLARES_ESTOQUE) == 0) {

			obterExemplaresEmEstoque(new_fd, comando[2]);

		} else if (strcmp(comando[1], REQUEST_END) == 0) {

			printf("Finalizando conexao com o cliente...\n");

			// Envia mensagem para o cliente finalizar a conexao
			strcpy(buffer, RESPONSE_END);
			if (write(new_fd, buffer, strlen(buffer)) < 0) {
				perror("erro ao escrever no socket");
				exit(1);
			}

			break;
		} else {
			// Notifica o cliente sobre comando invalido
			strcpy(buffer, RESPONSE_COMANDO_INVALIDO);
			if (write(new_fd, buffer, 255) < 0) {
				perror("erro ao escrever no socket");
				exit(1);
			}
			printf("comando invalido\n");
		}
	}

}


// Trata as novas conexoes
void tratar_conexao(int new_fd) {
	
	// Le o comando enviado pelo cliente
	ler_comando(new_fd);
	
	printf("Fechando conexao do processo filho\n");
	    // Fecha a conexao do filho
	close(new_fd);
	

	printf("Matando processo filho\n");
	// Finaliza o processo filho
	exit(0);
}

void executarServidor(int porta) {

	printf("inicializando servidor na porta '%d'....\n", porta);

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
	my_addr.sin_port = htons(porta);
	my_addr.sin_addr.s_addr = INADDR_ANY;
	bzero(&(my_addr.sin_zero), 8);
	
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
	
	printf("Servidor operando em: %d.%d.%d.%d:%d\n", (int)my_addr.sin_addr.s_addr&0xFF, (int)((my_addr.sin_addr.s_addr&0xFF00)>>8), (int)((my_addr.sin_addr.s_addr&0xFF0000)>>16), (int)((my_addr.sin_addr.s_addr&0xFF000000)>>24), ntohs(my_addr.sin_port));

	// Fica em loop aceitando as conexoes
	    while(1) {
	        sin_size = sizeof(struct sockaddr_in);
	        if ((new_fd = accept(sock_fd, (struct sockaddr *)&their_addr, &sin_size)) == -1) {
	            perror("erro ao aceitar a conexao");
	            continue;
        	}
		
		// Cria um novo processo para tratar a nova conexao
	        if (!fork()) {
			tratar_conexao(new_fd);
	        }
		
		//printf("Fechando new_fd no processo principal\n");
		// Processo principal n? referencia a nova conexao
        	close(new_fd);

			// Aguarda todos os processos filhos terminarem
			//printf("Aguardando todos os processos filhos terminarem...\n");
       		while(waitpid(-1, NULL, WNOHANG) > 0);
    	}
	
	return EXIT_SUCCESS;
}
