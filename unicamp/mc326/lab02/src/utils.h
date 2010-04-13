/*******************************************************************************

 Header File com as interfaces utilitarias para manipular Strings.

 <utils.h>

 
 Grupo 4: Cristiano J. Miranda  RA: 083382
 Gustavo F. Tiengo     RA: 071091
 Magda A. Silva        RA: 082070
 15/03/2010


 *******************************************************************************/
#define boolean int
#define true 1
#define false 0

#define ESPACE " "
#define END_STR_TOKEN '\0'
#define STR_END_TOKEN "\0"
#define END_OF_LINE "\n"
#define ERROR_EXECUTION -1

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
 * Quebra um String utilizando um caracter como curinga.
 *
 * param value - String a ser quebrada.
 * param token - Token curinga para quebrar a String.
 * param size  - Tamanho do array de String a ser retornado.
 * return array de String.
 */
char **strSplit(char *value, char *token, int *size);

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
 * Desaloca um array de String da memoria.
 *
 * param value - Array de String a ser desalocado.
 * param size - Tamanho do Array.
 */
void strArrayFree(char **value, int size);

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

