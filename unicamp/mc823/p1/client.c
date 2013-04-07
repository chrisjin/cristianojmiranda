#include <stdio.h>
#include <sys/types.h> 
#include <sys/socket.h>
#include <netinet/in.h>

#include "client.h"
#include "amazonservice.h"

void executarCliente(char* porta, char* host) {

	printf("Inicilizando cliente....\n");
	
	int sockfd, portno, n;
    struct sockaddr_in serv_addr;
    struct hostent *server;

    char buffer[256];
    portno = atoi(porta);
	
    // Cria o descritor do socket
    sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd < 0) {
        perror("ERROR opening socket");
        exit(1);
    }
	
	// obtem o host
    server = gethostbyname(host);
    if (server == NULL) {
        fprintf(stderr, "erro, host invalido\n");
        exit(0);
    }

    bzero((char*) &serv_addr, sizeof(serv_addr));
    serv_addr.sin_family = AF_INET;
    bcopy((char*)server->h_addr, (char*)&serv_addr.sin_addr.s_addr, server->h_length);
    serv_addr.sin_port = htons(portno);

    // Conectando ao server
    if (connect(sockfd,&serv_addr,sizeof(serv_addr)) < 0) {
         perror("erro ao conectar ao servidor");
         exit(1);
    }	
	
	// Obtem um comando do usuario
    printf("Please enter the message: ");
    bzero(buffer,256);
    fgets(buffer,255,stdin);
	
    // Envia a mensagem para o usuario
    if (write(sockfd,buffer,strlen(buffer)) < 0) {
         perror("erro ao escrever no socket");
         exit(1);
    }
    
	// Le a resposta do servidor
    bzero(buffer,256);
    if (read(sockfd,buffer,255) < 0) {
         perror("erro ao ler o socket");
         exit(1);
    }
	
    printf("%s\n",buffer);
    return 0;
	
}