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

void executarCliente(char* porta, char* host) {

	printf("Inicilizando cliente....\n");
	
	// Descritor de socket
	int sock_fd;
    struct hostent *he;
	
	// Endereco de conexao
    struct sockaddr_in their_addr;   

	// Cronometros
    clock_t startTime, endTime;
    float elapsedTime;
	
    char *rbuffer = (char*)malloc(255 * sizeof(char));
    char *wbuffer = (char*)malloc(255 * sizeof(char));
    FILE *rsock, *wsock;
    int sentAll = 0, sent = 1;
    struct timeval tv;
    fd_set readfds, writefds;
    
    FD_ZERO(&readfds);
    FD_ZERO(&writefds);

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

	// Conectando ao host
    if (connect(sock_fd, (struct sockaddr *)&their_addr, sizeof(struct sockaddr)) == -1) {
        perror("erro ao conectar ao server");
        exit(1);
    }

	// Abrindo conexao de leitura
    if ((rsock = fdopen(sock_fd, "r")) == NULL) {
        perror("erro ao abrir conexao - rsocket");
        exit(1);
    }

	// Abrindo conexao de escrita
    if ((wsock = fdopen(sock_fd, "w")) == NULL) {
        perror("erro ao abrir conexao - wsocket");
        exit(1);
    }
    
	// Inicia a conta
    startTime = times(NULL);

    setvbuf(wsock, NULL, _IOLBF, 0);
    setvbuf(rsock, NULL, _IOLBF, 0);
    
    while (1) {
        
        tv.tv_sec = TIMEOUT;
        tv.tv_usec = 0;
        FD_SET(sock_fd, &readfds);
		
		// Obtem um comando do usuario
		printf("Please enter the message: ");
		bzero(buffer,256);
		fgets(buffer,255,stdin);
		
		// Envia a mensagem para o usuario
		if (write(sock_fd, buffer, strlen(buffer)) < 0) {
			 perror("erro ao escrever no socket");
			 exit(1);
		}
		
		// Le a resposta do servidor
		bzero(buffer,256);
		if (read(sock_fd, buffer, 255) < 0) {
			 perror("erro ao ler o socket");
			 exit(1);
		}
		
		printf("\n%s\n",buffer);
    }
    
    endTime = times(NULL);   /* stop time counting */
    elapsedTime = (float)((endTime - startTime) / (float)sysconf(_SC_CLK_TCK));

    close(sock_fd);
    free(rbuffer);
    free(wbuffer);
	
	// ------------------------
    return 0;
	
}