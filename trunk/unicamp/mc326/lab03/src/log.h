/*******************************************************************************

 Interface com os principais metodos do mecanismo de log

 by Cristiano J. Miranda         01/09/2008

 TODO: Incluir funcionalidade de identan��o dos metodos logados
 Incluir outros niveis de log
 Incluir funcionalidade de externaliza��o dos metodos a serem logados,
 por arquivo de configura��o
 Incluir manuten��o dos arquivos logados, especificando um
 tamanho maximo e processar a gera��o de outros arquivos
 Incluir funcionalidade de obten��o de estatisticas de metodos,
 tempo de execu��o, quantidade de vezes executados, numero de
 itera��es....


 *******************************************************************************/

#include <stdio.h>

/** Constante com o nome do arquivo de log */
#define LOG_FILE "out.log"

/** Propriedade para o nome do arquivo de debug */
#define PROPERTY_LOG_FILE "log.file"
#define PROPERTY_LOG_ENABLED  "log.enabled"
#define PROPERTY_LOG_OUTPUT "log.output"

#define debug(a) _debug(a, __func__)
#define debugi(a, b) _debugi(a, __func__, b)
#define debugf(a, b) _debugf(a, __func__, b)
#define debugs(a, b) _debugs(a, __func__, b)
#define debugl(a, b) _debugl(a, __func__, b)
#define debugc(a, b) _debugc(a, __func__, b)

/**
 * Inicializa o mecanismo de log
 */
void initializeLog();

/** Enumerator para tipos predefinido de log */
enum SAIDA {
	PROMPT = 0, ARQUIVO = 1
};

/**
 setConfig - Metodo que seta a configura��o padrao do log
 param saida - enum SAIDA - referente ao tipo de log a ser executado
 */
void setConfig(int value);

/**
 finalizeLog - Metodo que finaliza o mecanismo de log, fecha o arquivo de
 registros caso tenha sido escolhido tal modalidade.
 */
void finalizeLog();

/**
 debug* - metodos utilitarios de debug,
 loga as informa��a passadas como parametro
 */
void _debug(char* message, char *func);
void _debugi(char* message, char *func, int value);
void _debugf(char* message, char *func, float value);
void _debugs(char* message, char *func, char* value);
void _debugc(char* message, char *func, char value);
void _debugl(char* message, char *func, long value);

/**
 stop - Causa uma interrup��o no andamento do programa,
 permitindo o usuario proseguir, facilitando a analise do log.
 */
void stop();

/**
 Trata exce��o do sistema
 */
void error(char* s);
