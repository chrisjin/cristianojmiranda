/*******************************************************************************

 Header File com as interfaces utilitarias para manipular arquivo de recursos.

 <bundle.c>


 Grupo 4:
 Cristiano J. Miranda  RA: 083382
 Gustavo F. Tiengo     RA: 071091
 Magda A. Silva        RA: 082070

 31/03/2010


 *******************************************************************************/
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <string.h>
#include <assert.h>

#include "utils.h"
#include "hashmap.h"
#include "bundle.h"

/** Map com os recursos do sistema */
map_t configMap = NULL;

/** Map com as mensagens do sistema */
map_t messageMap = NULL;

/**
 * Obtem uma propriedade pela chave no arquivo de recursos.
 *
 * param key - Chave do arquivo de recursos.
 * return Valor do recurso.
 */
char* getProperty(char* key) {

	if (configMap == NULL) {
		configMap = hashmap_new();
		loadMap(BUNDLE_FILE, configMap);
	}

	char k[KEY_MAX_LENGTH];
	strcpy(k, key);

	data_bundle_t* value;
	value = malloc(sizeof(data_bundle_t));

	int error = hashmap_get(configMap, key, (void**) (&value));

	if (error == MAP_OK) {

		return value->property;

	}

	return NULL;
}

/**
 * Obtem uma mensaegm pela chave no arquivo de recursos.
 *
 * param key - Chave do arquivo de recursos.
 * return Valor do recurso.
 */
char* getMessage(char* key) {

	if (messageMap == NULL) {

		messageMap = hashmap_new();
		char* resourceFile = getProperty(SYSTEM_MESSAGE_FILE);
		loadMap(resourceFile, messageMap);
	}

	char k[KEY_MAX_LENGTH];
	strcpy(k, key);

	data_bundle_t* value;
	value = malloc(sizeof(data_bundle_t));

	int error = hashmap_get(messageMap, k, (void**) (&value));

	if (error == MAP_OK) {

		return value->property;

	}
	return NULL;
}

/**
 * Carrega uma hashmap apartir de um arquivo especifico,
 * seguindo o formato, "chave=propriedade".
 *
 * param file - Nome do arquivo de recusos
 * param map  - Hashmap a ser populada
 *
 */
void loadMap(char* file, map_t map) {

	data_bundle_t* value;
	value = malloc(sizeof(data_bundle_t));

	FILE* bundleFile = Fopen(file, "r");

	int size = 0;
	char line[READ_BUFFER_SIZE];
	char *property;

	while (fgets(line, READ_BUFFER_SIZE, bundleFile) != NULL) {

		char** key_value = strSplit(line, BUNDLE_TOKEN, &size);
		if (size >= 2) {
			value = realloc(value, sizeof(data_bundle_t));
			if (value == NULL) {
				fprintf(stderr, "Out of memory");
				exit(EXIT_FAILURE);
			}

			// Obtem a propriedade
			property = strMerge(key_value[1], END_OF_LINE, STR_END_TOKEN);

			// Aloca dinamicamente chave e valor
			value->key = malloc(sizeof(key_value[0]));
			value->property = malloc(sizeof(property));

			strcpy(value->key, key_value[0]);
			strcpy(value->property, property);

			// TODO: tratar mais de um separador !
			if (hashmap_put(map, value->key, value) != MAP_OK) {
				fprintf(stderr, "Erro ao salvar registro na hashmap");
				exit(EXIT_FAILURE);
			}

			free(value);

		}
		strArrayFree(key_value, size);

	}

	fclose(bundleFile);

}

