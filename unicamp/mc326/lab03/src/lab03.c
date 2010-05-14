/*******************************************************************************

 Implementação do lab02 MC326.

 <lab02.c>


 Grupo 4:
 Cristiano J. Miranda  RA: 083382
 Gustavo F. Tiengo     RA: 071091
 Magda A. Silva        RA: 082070

 12/04/2010


 *******************************************************************************/
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<ctype.h>
#include "log.h"
#include "utils.h"
#include "bundle.h"
#include "aluno.h"
#include "io.h"
#include "lab03.h"

int main(int argc, char * argv[]) {

	// Configuração do mecanismo de debug
	initializeLog();

	debug("Verifica se os parametros de entrada do sistema sao validos");
	validaEntrada(argc, argv);

	debug("Libera a memoria alocada e finaliza o programa");
	finalizeLog();
	freeBundle();
	return 0;

}

/**
 * Verifica se os parametros de entrada sao validos.
 */
boolean validaEntrada(int argc, char *argv[]) {

	if (argc < 5) {
		printf(getMessage("lab02.label.arquivo_obrigatorio"), END_OF_LINE);
		exit(EXIT_FAILURE);
	}

	debug("Verifica se o arquivo de entrada existe");
	if (!fileExists(argv[1])) {
		printf(getMessage("lab02.label.arquivo_invalido"), (char*) argv[1],
				END_OF_LINE);
		exit(EXIT_FAILURE);
	}

	debug("Verifica se as chaves sao validas");
	if (strcmp(strUpperCase(argv[3]), strUpperCase(getMessage("aluno.ra")))
			!= 0 && strcmp(strUpperCase(argv[3]), strUpperCase(getMessage(
			"aluno.nome"))) != 0) {

		printf(getMessage("aluno.mensagem.chaveInvalida"), END_OF_LINE);
		exit(EXIT_FAILURE);

	}

	debug("Verificando se as memoria informada eh valida");
	if (!isNumeric(argv[4])) {
		printf(getMessage("aluno.memoriaInvalida"), END_OF_LINE);
		exit(EXIT_FAILURE);
	}

	return true;
}
