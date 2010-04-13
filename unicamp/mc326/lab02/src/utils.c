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

	setMethodName("strUpperCase");

	if (value == NULL) {
		return NULL;
	}
	debugs("Param value: ", value);

	char *output = NULL;
	output = malloc(sizeof(char) * (1 + strlen(value)));

	int i = 0;
	for (i = 0; i < strlen(value); i++) {
		output[i] = toupper(value[i]);
	}

	output[i] = END_STR_TOKEN;
	debugs("Output value: ", output);

	lastMethodName();

	return output;

}

/**
 * Quebra um String utilizando um caracter como curinga.
 *
 * param value - String a ser quebrada.
 * param size  - Tamanho do array de String a ser retornado.
 * param token - Token curinga para quebrar a String.
 * return array de String.
 */
char **strSplit(char *value, char *token, int *size) {

	setMethodName("strSplit");
	debugs("Param value: ", value);
	debugs("Param token: ", token);

	if (value == NULL)
		return NULL;

	if (token == NULL)
		return NULL;

	int j = 0, i;
	char *parte = NULL;
	char *copia = malloc(strlen(value));
	char **split = NULL;
	strcpy(copia, value);

	debug("Verificando o tamanho do array de retorno");
	parte = strtok(copia, token);
	if (parte) {
		j++;
	}

	do {
		parte = strtok(NULL, token);
		debugs("nodes: ", parte);
		if (parte) {
			j++;
		}
	} while (parte);

	debugi("Alocando tamanho do array de retorno: ", j);
	split = (char**) malloc(j * sizeof(char*));
	if (split == NULL) {
		debug("Erro ao alocar memoria");
		exit(-1);
	}

	debug("Montando array de retorno");
	strcpy(copia, value);
	parte = strtok(copia, token);
	for (i = 0; i < j; i++) {
		debugs("Alocando array para o valor: ", parte);
		split[i] = malloc(sizeof(parte) + 1);
		strcpy(split[i], parte);
		parte = strtok(NULL, token);
	}

	lastMethodName();
	*size = j;
	free(parte);
	free(copia);

	return split;
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

	int i, size, tamanhoPalavra = 0;
	char **palavras = strSplit(value, token, &size);

	debug("Calcula o tamanho da memoria a ser alocada");
	for (i = 0; i < size; i++) {
		tamanhoPalavra += strlen(palavras[i]);
	}

	char *aux = malloc(tamanhoPalavra + 1 + (size * strlen(mergeToken)));
	for (i = 0; i < size; i++) {
		if (palavras[i] != NULL) {
			strcpy(aux, palavras[i]);

			if (i != (size - 1)) {
				strcpy(aux, mergeToken);
			}
		}
	}

	strArrayFree(palavras, size);
	debugs("Return: ", aux);
	lastMethodName();

	return aux;
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
		copy = strUpperCase(value);
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
 * Desaloca um array de String da memoria.
 *
 * param value - Array de String a ser desalocado.
 * param size - Tamanho do Array.
 */
void strArrayFree(char **value, int size) {

	setMethodName("strArrayFree");
	debugi("Param size: ", size);

	int i;
	for (i = 0; i < size; i++) {
		if (value[i] != NULL) {
			debugs("Position: ", value[i]);
			free(value[i]);
		}
	}

	if (value != NULL) {
		free(value);
	}

	lastMethodName();
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

