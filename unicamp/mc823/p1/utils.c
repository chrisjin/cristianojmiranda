/*******************************************************************************

 Funcoes Utilitarias para manipular String.

 <utils.c>


 Grupo 4: Cristiano J. Miranda  RA: 083382
 Gustavo F. Tiengo     RA: 071091
 Magda A. Silva        RA: 082070
 15/03/2010


 *******************************************************************************/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>
#include <fcntl.h>

#include "mem.h"
#include "utils.h"

/**
 * Converte todos os carateres de uma String
 * em uppercase.
 *
 * param value -  String a ser convertida
 * return apontador para a String upper
 *
 */
char *strUpperCase(char *value) {

	if (value == NULL) {
		return NULL;
	}

	char *output = malloc(sizeof(char) * (1 + strlen(value)));

	int i = 0;
	for (i = 0; i < strlen(value); i++) {
		output[i] = toupper(value[i]);
	}

	output[i] = END_STR_TOKEN;

	return output;

}

/**
 * Faz o merge de uma String quebrando por um token especifico e
 * remontando as partes a partir de outro token.
 *
 * param value - String a ser remontada
 * param token - Token curinga para quebrar a String.
 * param mergeToken - Token que intercala a String.
 * return String remontada apartir dos novos parametros.
 */
char *strMerge(char *value, char *token, char *mergeToken) {

	char *aux = NULL;
	int size = 0;
	char *splt = strtok(value, token);

	if (splt) {

		while (splt) {

			size = strlen(splt) + strlen(mergeToken);
			if (aux == NULL) {
				aux = MEM_ALLOC_N(char, size);
				//aux = (char*)malloc(size);
			} else {
				aux = realloc(aux, size);
			}
			strcat(aux, str_join(splt, mergeToken));
			splt = strtok(END_STR_TOKEN, token);

		}

		return aux;
	}

	return value;
}

/**
 * Conta a quantidade de um determinado caracter em um String.
 *
 * param value - String de entrada.
 * param key - caracter a ser contado.
 * param caseSensitive - Se a contagem sera feita em case sensitive.
 * return numero de ocorrencias de key em value.
 */
int strCharCount(char *value, char key, boolean caseSensitive) {

	int count = 0;

	char ch = key;
	char *copy;
	if (caseSensitive == true) {
		copy = malloc((sizeof(char) * strlen(value)) + 1);
		strcpy(copy, value);
	} else {
		copy = strUpperCase(value);
		ch = toupper(key);
	}

	do {
		copy = memchr(copy, ch, strlen(copy));

		if (copy != NULL) {
			count++;
			copy = &copy[1];
		}
	} while (copy != NULL);

	free(copy);

	return count;
}

/**
 * Obtem uma substring apartir de uma posição inicial e final.
 *
 */
char *strSubString(char *value, int start, int end) {

	return substring(value, start, (end - start));

}

/**
 * Obtem uma substring apartir de uma posição inicial e quantidade de caracteres.
 */
char *substring(char *origem, int inicio, int quant) {

	char *res = MEM_ALLOC_N(char, strlen(origem));
	strcpy(res, origem);
	int i = 0;

	// posição inicial menor que 0 ou
	// posição inicial muito exagerada?
	if ((inicio < 0) || (inicio > strlen(origem)))
		inicio = 0;

	// quantidade de caracteres muito exagerada?
	if (quant > inicio + strlen(origem))
		quant = strlen(origem) - inicio;

	// obtem os caracteres desejados
	for (i = 0; i <= quant - 1; i++) {
		res[i] = origem[inicio + i];
	}

	// marca o fim da string
	res[i] = END_STR_TOKEN;

	return res;
}

/**
 * Verifica se a string tem apenas caracteres numericos.
 */
boolean isNumeric(char *value) {

	if (value == NULL)
		return false;

	int i;
	for (i = 0; i < strlen(value); i++) {
		if (value[i] != '0' && value[i] != '1' && value[i] != '2' && value[i]
				!= '3' && value[i] != '4' && value[i] != '5' && value[i] != '6'
				&& value[i] != '7' && value[i] != '8' && value[i] != '9') {
			return false;
		}
	}

	return true;
}

/**
 * Abre um arquivo.
 * param fileName - Nome do arquivo a ser aberto.
 * param flag - Flag de leitura.
 * return referencia para o arquivo.
 */
int Open(char *fileName, int flag) {

	int fd;
	if ((fd = open(fileName, flag)) < 0) {

		perror("Erro ao abrir arquivo");
		exit(1);

	}

	return fd;
}

/**
 * Abre um arquivo.
 * param fileName - Nome do arquivo a ser aberto.
 * param flag - Flag de leitura.
 * return referencia para o arquivo.
 */
FILE* Fopen(char *fileName, char* flag) {

	FILE *file;
	if ((file = fopen(fileName, flag)) == NULL) {
		perror("Erro ao abrir o arquivo");
	}

	return file;
}

char* copyStr(char* str) {

	char *p = (char*) malloc(strlen(str) + 1);
	strcpy(p, str);
	return p;

}

/**
 * Le da entrada de dados.
 */
char *getLine() {

	char line[256];

	if (gets(line) != NULL) {
		return copyStr(line);
	}

	else {
		return NULL;
	}
}

/**
 * Calcula o tamanho do arquivo.
 */
long fileSize(char *fileName) {

	FILE *arquivo = Fopen(fileName, "r");

	// guarda tamanho do arquivo
	long tamanho = 0;

	// calcula o tamanho
	fseek(arquivo, 0, SEEK_END);
	tamanho = ftell(arquivo);

	fclose(arquivo);

	return tamanho;
}

/*
 Implementação de uma função fileExists() em C. Se
 o arquivo existir o valor true será retornado. Caso
 contrário a função retornará false.
 */
boolean fileExists(const char *filename) {
	FILE *arquivo;

	if (arquivo = fopen(filename, "r")) {
		fclose(arquivo);
		return true;
	}
	return false;
}

/**
 * Exibe os dados de um arquivo na tela.
 */
void showFile(char *fileName) {

	FILE *arq = Fopen(fileName, "r");
	char line[READ_BUFFER_SIZE];
	int ra = -1;
	int index = 0;
	while (fgets(line, READ_BUFFER_SIZE, arq) != NULL) {
		printf("%s", line);
	}

	fclose(arq);

}

int csvParse(char *line, char* list[], int list_size) {
	int i = 0;
	char *tok = strtok(line, ";");
	while (tok != NULL) {
		list[i] = MEM_ALLOC_N(char, sizeof(tok));
		//clearString(list[i]);
		//printf("csvParse index %d valor %s\n", i, tok);
		list[i++] = tok;
		tok = strtok(NULL, ";");
		
		if (i >= list_size){
			break;
		}
	}
}
