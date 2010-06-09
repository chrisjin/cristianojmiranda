/*******************************************************************************

 Implementa��o para mecanismo de log.

 <log.h>

 by Cristiano J. Miranda         01/09/2008


 *******************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include<string.h>
#include "bundle.h"
#include "log.h"

/** Variaveis internas do mecanismo de log */
char* methodName;
char* methodNameTemp;
FILE* logFile;
int generateFile;
char* fileLogName = NULL;
int debugEnabled = 0;
char * enabledLog = NULL;
char *output = NULL;

/**
 * Inicializa o mecanismo de log
 */
void initializeLog() {

	// Desabilita o log
	debugEnabled = 0;

	// Obtem recurso para ativar log
	enabledLog = getProperty(PROPERTY_LOG_ENABLED);

	// Verifica se deve ativar o log
	if (enabledLog != NULL && strcmp(enabledLog, "true") == 0) {

		fileLogName = getProperty(PROPERTY_LOG_FILE);
		if (fileLogName == NULL) {
			fileLogName = LOG_FILE;
		}

		// Obtem output
		output = getProperty(PROPERTY_LOG_OUTPUT);

		// Ativa o log
		debugEnabled = 1;

		if (output != NULL) {

			setConfig(atoi(output));

		}

	}

}
/**
 * Seta a configuração do log
 */
void setConfig(int value) {

	generateFile = 0;
	if (debugEnabled && value == ARQUIVO) {
		generateFile = 1;
		logFile = fopen(fileLogName, "a");

		if (!logFile) {
			generateFile = 0;
			debug("Erro na geracao do arquivo de log");
		}
	}

}

/**
 * Finaliza a geração do log
 */
void finalizeLog() {
	if (debugEnabled && generateFile)
		fclose(logFile);

}

void _debug(char* message, char *func) {

	if (debugEnabled) {

		if (generateFile) {
			verifySizeofLofFile(logFile);
			fprintf(logFile, "[DEBUG][%s %s][%s] - %s\n", __DATE__, __TIME__,
					func, message);
		}

		else {
			fprintf(stdout, "[DEBUG][%s] - %s\n", func, message);
		}
	}
}

void _debugi(char* message, char *func, int value) {
	if (debugEnabled) {
		if (generateFile)
			fprintf(logFile, "[DEBUG][%s %s][%s] - %s %d\n", __DATE__,
					__TIME__, func, message, value);

		else
			fprintf(stdout, "[DEBUG][%s] - %s %d\n", func, message, value);
	}
}

void _debugl(char* message, char *func, long value) {
	if (debugEnabled) {
		if (generateFile)
			fprintf(logFile, "[DEBUG][%s %s][%s] - %s %d\n", __DATE__,
					__TIME__, func, message, value);

		else
			fprintf(stdout, "[DEBUG][%s] - %s %i\n", func, message, value);
	}
}

void _debugf(char* message, char *func, float value) {
	if (debugEnabled) {
		if (generateFile)
			fprintf(logFile, "[DEBUG][%s %s][%s] - %s %f\n", __DATE__,
					__TIME__, func, message, value);

		else
			fprintf(stdout, "[DEBUG][%s] - %s %f\n", func, message, value);
	}
}

void _debugs(char* message, char *func, char* value) {
	if (debugEnabled) {
		if (generateFile)
			fprintf(logFile, "[DEBUG][%s %s][%s] - %s '%s'\n", __DATE__,
					__TIME__, func, message, value);

		else
			fprintf(stdout, "[DEBUG][%s] - %s '%s'\n", func, message, value);
	}
}

void _debugc(char* message, char * func, char value) {
	if (debugEnabled) {
		if (generateFile)
			fprintf(logFile, "[DEBUG][%s %s][%s] - %s %c\n", __DATE__,
					__TIME__, func, message, value);

		else
			fprintf(stdout, "[DEBUG][%s] - %s %c\n", func, message, value);
	}
}

void stop() {
	if (debugEnabled) {
		printf("Presione ENTER para continuar\n");
		getchar();
	}
}

void error(char* s) {
	perror(s);
	exit(EXIT_FAILURE);
}

void verifySizeofLofFile(FILE *file) {

	if (fileSizeByRef(file) > 5000000) {

		fclose(file);
		remove(fileLogName);

		file = fopen(fileLogName, "a");
	}

}
