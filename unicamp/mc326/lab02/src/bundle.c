/*******************************************************************************

 Header File com as interfaces utilitarias para manipular arquivo de recursos.

 <bundle.c>


 Grupo 4: Cristiano J. Miranda  RA: 083382
 Gustavo F. Tiengo     RA: 071091
 Magda A. Silva        RA: 082070
 31/03/2010


 *******************************************************************************/
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <string.h>
#include <assert.h>

#include "log.h"
#include "utils.h"
#include "hashmap.h"
#include "mem.h"
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

	setMethodName("getProperty");
	debugs("Param key: ", key);

	if (configMap == NULL) {
		debug("Carregando a map");
		configMap = hashmap_new();
		loadMap(BUNDLE_FILE, configMap);
	}

	data_bundle_t* value;
	value = MEM_ALLOC(data_bundle_t);

	debug("Obtendo property na hash");
	int error = hashmap_get(configMap, key, (void**) (&value));

	if (error == MAP_OK) {
		debugs("Propriedade encontrada: ", value->property);

		char *result = MEM_ALLOC_N(char, strlen(value->property));
		strcpy(result, value->property);
		free(value);

		lastMethodName();

		return result;

	} else {
		debug("Propriedade não encontrada");
	}

	free(value);
	lastMethodName();

	return NULL;
}

/**
 * Obtem uma mensaegm pela chave no arquivo de recursos.
 *
 * param key - Chave do arquivo de recursos.
 * return Valor do recurso.
 */
char* getMessage(char* key) {

	setMethodName("getMessage");
	debugs("Param key: ", key);

	if (messageMap == NULL) {

		debug("Carregando a map");
		messageMap = hashmap_new();
		char* resourceFile = getProperty(SYSTEM_MESSAGE_FILE);
		loadMap(resourceFile, messageMap);
	}

	data_bundle_t* value;
	value = malloc(sizeof(data_bundle_t));

	debug("Obtendo property na hash");
	int error = hashmap_get(messageMap, key, (void**) (&value));

	if (error == MAP_OK) {

		debugs("Propriedade encontrada: ", value->property);
		lastMethodName();

		return value->property;

	} else {
		debug("Propriedade não encontrada");
	}

	lastMethodName();

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

	setMethodName("loadMap");
	debugs("Param file: ", file);

	data_bundle_t* value;

	debug("Abrindo o arquivo de recursos.");
	FILE* bundleFile = Fopen(file, "r");

	char* token;
	char line[READ_BUFFER_SIZE];
	stripWhiteSpace(line);

	while (fgets(line, READ_BUFFER_SIZE, bundleFile) != NULL) {

		// Obtem a chave
		token = strtok(line, BUNDLE_TOKEN);
		if (token) {

			value = MEM_ALLOC(data_bundle_t);

			debug("Armazena a chave");
			value->key = MEM_ALLOC_N(char, strlen(token) * 2);
			stripWhiteSpace(value->key);
			debugs("Key: ", token);
			//strcpy(value->key, token);
			strcat(value->key, token);

			// Obtem a propriedade
			token = strtok(END_STR_TOKEN, BUNDLE_TOKEN);
			if (token) {

				value->property = MEM_ALLOC_N(char, strlen(token));
				debugs("Value: ", token);

				char *mrg = strMerge(token, END_OF_LINE, STR_END_TOKEN);
				strcpy(value->property, mrg);

				if (hashmap_put(map, value->key, value) != MAP_OK) {
					error("Problema ao salvar o atributo na hash.");
				}
			}

		}

	}

	fclose(bundleFile);

	int hashLength = hashmap_length(configMap);
	debugi("Tamanho da Hash: ", hashLength);

	debug("Bundle carregado!");

	lastMethodName();

}

/**
 * Libera as hashmaps da memoria.
 */
void freeBundle() {

	if (configMap != NULL) {
		hashmap_free(configMap);
	}

	if (messageMap != NULL) {
		hashmap_free(messageMap);
	}

}

