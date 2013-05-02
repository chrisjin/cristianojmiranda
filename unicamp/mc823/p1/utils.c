/*******************************************************************************

 Funcoes Utilitarias para manipular String.

 <utils.c>


 Grupo 4: Cristiano J. Miranda  RA: 083382

 15/03/2010


 *******************************************************************************/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>
#include <fcntl.h>
#include <time.h>

#include "mem.h"
#include "utils.h"


//...

int csvParse(char *line, char* list[], int list_size) {
	int i = 0;
	char *tok = strtok(line, ";");
	while (tok != NULL) {
		list[i] = MEM_ALLOC_N(char, strlen(tok));
		clearString(list[i]);
		//printf("csvParse index %d valor '%s', strlen(%d)\n", i, tok, strlen(tok));
		list[i++] = tok;
		tok = strtok(NULL, ";");
		
		if (i >= list_size){
			break;
		}
	}
}

// Loga o tempo de execucao
void logarTempo(char* tipo, char* metodo, struct timeval startTime, struct timeval endTime) {

	
	// Abre arquivo para computar o tempo
	FILE *arq = Fopen("timer.csv", "a");

        //Converte os tempos para milisegundos
        long intervaloS = (endTime.tv_sec - startTime.tv_sec);
        long intervaloU = (endTime.tv_usec - startTime.tv_usec);

	if (intervaloU < 0) {
		intervaloU = 1 + intervaloU;
	}

	//printf("logarTempo: inicio=%ld.%06ld, fim=%ld.%06ld, intervalo=%ld.%06ld\n", startTime.tv_sec, startTime.tv_usec, endTime.tv_sec, endTime.tv_usec, intervaloS, intervaloU );
	
	fputs("\"", arq);
	fputs(tipo, arq);
	fputs("\";\"", arq);
	fputs(metodo, arq);
	fputs("\";\"", arq);

	char* buffer = MEM_ALLOC_N(char, 256);
	bzero(buffer, 255);
	snprintf(buffer, 255, "%ld.%06ld", startTime.tv_sec, startTime.tv_usec);

	fputs(buffer, arq);
	fputs("\";\"", arq);

	bzero(buffer, 255);
	snprintf(buffer, 255, "%ld.%06ld", endTime.tv_sec, endTime.tv_usec);

	fputs(buffer, arq);
	fputs("\";\"", arq);

	bzero(buffer, 255);
	snprintf(buffer, 255, "%ld.%06ld", intervaloS, intervaloU);

	fputs(buffer, arq);
	fputs("\";\n", arq);
	
	// Fecha o arquivo
	fclose(arq);
}

// Loga o tempo de execucao de um metodo
void logarTempo2(char* tipo, char* metodo, struct timeval startTime) {
	struct timeval end;
	gettimeofday(&end, NULL);
	logarTempo(tipo, metodo, startTime, end);
}
