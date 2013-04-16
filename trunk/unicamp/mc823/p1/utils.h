/*******************************************************************************

 Header File com as interfaces utilitarias para manipular Strings.

 <utils.h>


 Grupo 4: Cristiano J. Miranda  RA: 083382
 
 15/03/2010


 *******************************************************************************/
#include <time.h>
 
#define boolean int
#define true 1
#define false 0

#define ESPACE " "
#define END_STR_TOKEN '\0'
#define STR_END_TOKEN "\0"
#define END_OF_LINE "\n"
#define ERROR_EXECUTION -1
#define READ_BUFFER_SIZE (2048)

/**
 * Converte todos os carateres de uma String
 * em uppercase.
 *
 * param value -  String a ser convertida
 * return apontador para a String upper
 *
 */
char *strUpperCase(char *value);

/**
 * Faz o merge de uma String quebrando por um token especifico e
 * remontando as partes a partir de outro token.
 *
 * param value - String a ser remontada
 * param token - Token curinga para quebrar a String.
 * param mergeToken - Token que intercala a String.
 * return String remontada apartir dos novos parametros.
 */
char *strMerge(char *value, char *token, char *mergeToken);

/**
 * Conta a quantidade de um determinado caracter em um String.
 *
 * param value - String de entrada.
 * param key - caracter a ser contado.
 * param caseSensitive - Se a contagem sera feita em case sensitive.
 * return numero de ocorrencias de key em value.
 */
int strCharCount(char *value, char key, boolean caseSensitive);

/**
 * Obtem uma substring apartir de uma posição inicial e final.
 *
 */
char *strSubString(char *value, int start, int end);

/**
 * Obtem uma substring apartir de uma posição inicial e quantidade de caracteres.
 */
char *substring(char *origem, int inicio, int quant);

/**
 * Verifica se a string tem apenas caracteres numericos.
 */
boolean isNumeric(char *ra);

/**
 * Abre um arquivo.
 * param fileName - Nome do arquivo a ser aberto.
 * param flag - Flag de leitura.
 * return referencia para o arquivo.
 */
FILE* Fopen(char *fileName, char* flag);

/**
 * Calcula o tamanho do arquivo.
 */
long fileSize(char *fileName);

/*
 Implementação de uma função fileExists() em C. Se
 o arquivo existir o valor true será retornado. Caso
 contrário a função retornará false.
 */
boolean fileExists(const char *filename);

/**
 * Exibe os dados de um arquivo na tela.
 */
void showFile(char *fileName);

/**
 * Le da entrada de dados.
 */
char* getLine();

int csvParse(char *line, char* list[], int list_size);

// Loga o tempo de execucao de um metodo
void logarTempo(char* tipo, char* metodo, struct timeval startTime, struct timeval endTime);

// Loga o tempo de execucao de um metodo
void logarTempo2(char* tipo, char* metodo, struct timeval startTime);
