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
#include "log.h"
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
void strUpperCase(char *value, char *output) {

	setMethodName("strUpperCase");

	if (value == NULL) {
		return NULL;
	}
	debugs("Param value: ", value);

	output = malloc(sizeof(char) * (1 + strlen(value)));

	int i = 0;
	for (i = 0; i < strlen(value); i++) {
		output[i] = toupper(value[i]);
	}

	output[i] = END_STR_TOKEN;
	debugs("Output value: ", output);

	lastMethodName();

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

	setMethodName("strMerge");
	debugs("Param value: ", value);
	debugs("Param token: ", token);
	debugs("Param mergeToken: ", mergeToken);

	char *aux = NULL;
	int i = 0, size = 0;
	char *split = strtok(value, token);

	if (split) {

		while (split) {

			size = strlen(split) + strlen(mergeToken);
			if (aux == NULL) {
				aux = MEM_ALLOC_N(char, size);
			} else {
				aux = realloc(aux, size);
			}
			strcpy(aux, str_join(split, mergeToken));
			split = strtok(END_STR_TOKEN, token);

		}

		debugs("Return: ", aux);
		lastMethodName();

		return aux;
	}
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

	setMethodName("strCharCount");
	debugs("Param value: ", value);
	debugc("Param key: ", key);
	debugi("Param caseSensitive: ", caseSensitive);

	int count = 0;

	char ch = key;
	char *copy;
	if (caseSensitive == true) {
		copy = malloc((sizeof(char) * strlen(value)) + 1);
		strcpy(copy, value);
	} else {
		strUpperCase(value, &copy);
		ch = toupper(key);
	}

	debugs("Copy ", copy);

	do {
		copy = memchr(copy, ch, strlen(copy));

		if (copy != NULL) {
			count++;
			copy = &copy[1];
		}
	} while (copy != NULL);

	debug("Liberando memoria");
	free(copy);
	lastMethodName();

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

	setMethodName("isNumeric");
	debugs("Param value: ", value);
	debugi("Int value: ", atoi(value));

	int i;
	for (i = 0; i < strlen(value); i++) {
		debugc("Char: ", value[i]);
		if (value[i] != '0' && value[i] != '1' && value[i] != '2' && value[i]
				!= '3' && value[i] != '4' && value[i] != '5' && value[i] != '6'
				&& value[i] != '7' && value[i] != '8' && value[i] != '9') {
			return false;
		}
	}

	lastMethodName();

	return true;
}

/**
 * Abre um arquivo.
 * param fileName - Nome do arquivo a ser aberto.
 * param flag - Flag de leitura.
 * return referencia para o arquivo.
 */
int Open(char *fileName, int flag) {

	setMethodName("Open");
	debugs("Param fileName: ", fileName);
	debugi("Param flag: ", flag);

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

	setMethodName("Fopen");
	debugs("Param fileName: ", fileName);
	debugs("Param flag: ", flag);

	FILE *file;
	if ((file = fopen(fileName, flag)) == NULL) {
		error("Erro ao abrir o arquivo");
	}

	lastMethodName();

	return file;
}

char* copyStr(char* str) {

	char *p = (char*) malloc(strlen(str) + 1);
	strcpy(p, str);
	return p;

}

char* getLine() {

	char line[256];

	if (gets(line) != NULL)
		return copyStr(line);

	else
		return NULL;
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

/**
 * Exibe os dados de um arquivo na tela.
 */
void showFile(char *fileName) {

	FILE *arq = Fopen(fileName, "r");
	char line[READ_BUFFER_SIZE];
	int ra = -1;
	int index = 0, lineSize = 0;
	while (fgets(line, READ_BUFFER_SIZE, arq) != NULL) {
		printf("%s", line);
	}

	fclose(arq);

}
