/*******************************************************************************

 Interface com os principais metodos do mecanismo de log

 by Cristiano J. Miranda         01/09/2008

 TODO: Incluir funcionalidade de identanção dos metodos logados
 Incluir outros niveis de log
 Incluir funcionalidade de externalização dos metodos a serem logados,
 por arquivo de configuração
 Incluir arquivo padrao de configuração de log
 Incluir manutenção dos arquivos logados, especificando um
 tamanho maximo e processar a geração de outros arquivos
 Incluir funcionalidade de obtenção de estatisticas de metodos,
 tempo de execução, quantidade de vezes executados, numero de
 iterações....


 *******************************************************************************/

#include <stdio.h>

/** Constante com o nome do arquivo de log */
#define LOG_FILE "out.log"

/** Propriedade para o nome do arquivo de debug */
#define PROPERTY_LOG_FILE "log.file"
#define PROPERTY_LOG_ENABLED  "log.enabled"
#define PROPERTY_LOG_OUTPUT "log.output"

/**
 * Inicializa o mecanismo de log
 */
void initializeLog();

/** Enumerator para tipos predefinido de log */
enum SAIDA {PROMPT, ARQUIVO};

/**
 setConfig - Metodo que seta a configuração padrao do log
 param saida - enum SAIDA - referente ao tipo de log a ser executado
 */
void setConfig(int value);

/**
 finalizeLog - Metodo que finaliza o mecanismo de log, fecha o arquivo de
 registros caso tenha sido escolhido tal modalidade.
 */
void finalizeLog();

/**
 setMethodName - Seta o nome do metodo a ser logado
 name - nome do metodo

 TODO: tornar esse metodo deprecated, visto que existe uma maneira de obter
 o nome do metodo corrente via parametro do compilador.
 */
void setMethodName(char* name);

/**
 lasMethodName - Seta o nome do ultimo metodo como o metodo atual
 Torna possivel logar metodos encadeados sem perder a referncia
 */
void lastMethodName();

/**
 debug* - metodos utilitarios de debug,
 loga as informaçõa passadas como parametro
 */
void debug(char* message);
void debugi(char* message, int value);
void debugf(char* message, float value);
void debugs(char* message, char* value);
void debugc(char* message, char value);
void debugl(char* message, long value);

/**
 debugHeader - Sinaliza o inicio de um metodo
 */
void debugHeader();

/**
 stop - Causa uma interrupção no andamento do programa,
 permitindo o usuario proseguir, facilitando a analise do log.
 */
void stop();

/**
 Trata exceção do sistema
 */
void error(char* s);
