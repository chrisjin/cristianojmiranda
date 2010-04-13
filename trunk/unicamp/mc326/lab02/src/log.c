/*******************************************************************************

 Implementação para mecanismo de log.

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
char* fileLogName= NULL;
int debugEnabled = 0;
char * enabledLog= NULL;
char *output= NULL;

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

		// Ativa o log
		debugEnabled = 1;

		fileLogName = getProperty(PROPERTY_LOG_FILE);
		if (fileLogName== NULL) {
			fileLogName = LOG_FILE;
		}

		output = getProperty(PROPERTY_LOG_OUTPUT);
		if (output != NULL) {

			setConfig(atoi(output));

		}
	}

}

void setConfig(int value) {

	generateFile = 0;
	if (debugEnabled && value == ARQUIVO) {
		generateFile = 1;
		logFile = Fopen(logFile, "a");

		if (!logFile) {
			generateFile = 0;
			debug("Erro na geracao do arquivo de log");
		}
	}

}

void finalizeLog() {
	if (debugEnabled && generateFile)
		fclose(logFile);

}

void setMethodName(char* name) {
	methodNameTemp = methodName;
	methodName = name;
	debugHeader();
}

void lastMethodName() {
	if (methodNameTemp != NULL)
		methodName = methodNameTemp;
}

void debug(char* message) {

	if (debugEnabled) {

		if (generateFile) {
			fprintf(logFile, "[DEBUG][%s %s][%s] - %s\n",__DATE__ , __TIME__, methodName, message);
		}

		else {
			fprintf(stdout, "[DEBUG][%s] - %s\n", methodName, message);
		}
	}
}

void debugi(char* message, int value) {
	if (debugEnabled) {
		if (generateFile)
			fprintf(logFile, "[DEBUG][%s %s][%s] - %s %d\n",__DATE__ , __TIME__, methodName, message, value);

			else
			fprintf(stdout,"[DEBUG][%s] - %s %d\n", methodName, message, value);
		}
	}

void debugl(char* message, long value) {
	if (debugEnabled) {
		if (generateFile)
			fprintf(logFile, "[DEBUG][%s %s][%s] - %s %d\n",__DATE__ , __TIME__, methodName, message, value);

			else
			fprintf(stdout,"[DEBUG][%s] - %s %i\n", methodName, message, value);
		}
	}

void debugf(char* message, float value) {
	if (debugEnabled) {
		if (generateFile)
			fprintf(logFile, "[DEBUG][%s %s][%s] - %s %f\n",__DATE__ , __TIME__, methodName, message, value);

			else
			fprintf(stdout, "[DEBUG][%s] - %s %f\n", methodName, message, value);
		}
	}

void debugs(char* message, char* value) {
	if (debugEnabled) {
		if (generateFile)
			fprintf(logFile, "[DEBUG][%s %s][%s] - %s '%s'\n",__DATE__ , __TIME__, methodName, message, value);

			else
			fprintf(stdout, "[DEBUG][%s] - %s '%s'\n", methodName, message, value);
		}
	}

void debugc(char* message, char value) {
	if (debugEnabled) {
		if (generateFile)
			fprintf(logFile, "[DEBUG][%s %s][%s] - %s %c\n",__DATE__ , __TIME__, methodName, message, value);

			else
			fprintf(stdout, "[DEBUG][%s] - %s %c\n", methodName, message, value);
		}
	}

void debugHeader() {
	if (debugEnabled) {
		if (generateFile) {
			fprintf(logFile,
					"\n\n\n======================================================\n\n");
			fprintf(logFile, "\t\t\t %s \n\n", methodName);
			fprintf(logFile,
					"======================================================\n");
		}

		else {
			printf("\n\n\n======================================================\n\n");
			printf("\t\t\t %s \n\n", methodName);
			printf("======================================================\n");
		}

	}
}

void stop() {
	if (debugEnabled) {
		printf("Presione ENTER para continuar\n");
		getchar();
	}
}

void error(char* s) {
	//printf("erro: %s\n",s);
	perror(s);
	exit(EXIT_FAILURE);
}
