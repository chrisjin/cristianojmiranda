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
	
	char buffer[256];

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
    	while (1) {
        
			// Inicializa o timer
        	tv.tv_sec = 5;
        	tv.tv_usec = 0;
		
		// Obtem um comando do usuario
		printf("Entre com um comando: [DOC USUARIO];[COMANDO];[PARAMETROS]");
		bzero(buffer, BUFFER_SIZE + 1);
		fgets(buffer, BUFFER_SIZE,stdin);
		
		//printf("enviando mensagem...\n");
		// Envia a mensagem para o usuario
		if (write(sock_fd, buffer, strlen(buffer)) < 0) {
			 perror("erro ao escrever no socket");
			 exit(1);
		}
		
		//printf("obtando resposta...\n");
		// Le a resposta do servidor
		bzero(buffer,256);
		if (read(sock_fd, buffer, BUFFER_SIZE) < 0) {
			 perror("erro ao ler o socket");
			 exit(1);
		}
		
		printf("\tResposta: '%s'\n",buffer);

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