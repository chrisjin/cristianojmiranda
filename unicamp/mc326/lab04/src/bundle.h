/*******************************************************************************

 Header File com as interfaces utilitarias para manipular arquivo de recursos.

 <bundle.h>


 Grupo 4:
 Cristiano J. Miranda  RA: 083382
 Gustavo F. Tiengo     RA: 071091
 Magda A. Silva        RA: 082070

 31/03/2010


 *******************************************************************************/

#include "hashmap.h"

#define BUNDLE_TOKEN ("=")
#define READ_BUFFER_SIZE (1024)
//#define BUNDLE_FILE ("/media/CAE02706E026F879/debug/config.properties")
#define BUNDLE_FILE ("config.properties")

#define SYSTEM_MESSAGE_FILE ("system.message.file")

typedef struct data_bundle_s {
	char *key;
	char *property;
} data_bundle_t;

/**
 * Obtem uma propriedade pela chave no arquivo de recursos.
 *
 * param key - Chave do arquivo de recursos.
 * return Valor do recurso.
 */
char* getProperty(char* key);

/**
 * Obtem uma mensaegm pela chave no arquivo de recursos.
 *
 * param key - Chave do arquivo de recursos.
 * return Valor do recurso.
 */
char* getMessage(char* key);

/**
 * Carrega uma hashmap apartir de um arquivo especifico,
 * seguindo o formato, "chave=propriedade".
 *
 * param file - Nome do arquivo de recusos
 * param map  - Hashmap a ser populada
 *
 */
void loadMap(char* file, map_t map);

/**
 * Verifica se a linha deve ser ignorada.
 */
int ignoreLineBundle(char *line);

/**
 * Libera as hashmaps da memoria.
 */
void freeBundle();

