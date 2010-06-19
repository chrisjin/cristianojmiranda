/*******************************************************************************

 Implementação do lab04 MC326.

 <lab04.c>


 Grupo 4:
 Cristiano J. Miranda  RA: 083382
 Gustavo F. Tiengo     RA: 071091
 Magda A. Silva        RA: 082070

 15/05/2010


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
#include "lab04.h"

int main(int argc, char * argv[]) {

	// Configuração do mecanismo de debug
	initializeLog();

	debug("Verifica se os parametros de entrada do sistema sao validos");
	if (validaEntrada(argc, argv)) {

		initialize(argv);

	}

	debug("Libera a memoria alocada e finaliza o programa");
	finalizeLog();
	freeBundle();
	return 0;

}

/**
 * Verifica se os parametros de entrada sao validos.
 */
boolean validaEntrada(int argc, char *argv[]) {

	if (argc < 6) {
		printf(getMessage("lab02.label.arquivo_obrigatorio"), END_OF_LINE);
		return false;
	}

	debug("Verifica se a ordem eh numerica");
	if (!isNumeric(argv[1])) {
		printf(getMessage("lab02.label.ordem_nao_numerica"), END_OF_LINE);
		return false;
	}

	debug("Verifica se a ordem da b-tree esta entre 3 e 10 (inclusive).");
	if (atoi(argv[1]) < 3 || atoi(argv[1]) > 10) {
		printf(getMessage("lab02.label.ordem_invalida"), END_OF_LINE);
		return false;
	}

	debug("Verifica se o arquivo de dados existe");
	if (!fileExists(argv[2])) {
		printf(getMessage("lab02.label.arquivo_invalido"), argv[2], END_OF_LINE);
		return false;
	}

	return true;
}

/**
 * Exibe o menu.
 */
void showMenu() {

	debug("Imprime o menu");
	printf(getMessage("lab02.menu1"), END_OF_LINE);
	printf(getMessage("lab02.menu2"), END_OF_LINE);
	printf(getMessage("lab02.menu3"), END_OF_LINE);
	printf(getMessage("lab02.menu4"), END_OF_LINE);

}

/**
 * Start application.
 */
void initialize(char *argv[]) {

	debug("Iniciando a aplicacao");

	int opcao;

	do {

		debug("Exibe o menu do sistema");
		showMenu();

		debug("Obtendo a opção do sistema");
		char *str_opcao = getLine();

		opcao = -1;
		if (isNumeric(str_opcao)) {
			opcao = atoi(str_opcao);
		}

		switch (opcao) {

		case 1:
			debug("Cria a b-tree");
			loadBTreeIndex(argv[2], argv[3], argv[4], atoi(argv[1]), true);
			break;
		case 2:

			break;
		case 3:

			break;
		case 4:

		default:
			if (opcao != 4) {
				printf(getMessage("lab02.label.opcao_invalida"), "\n");
			}
			break;
		}

	} while (opcao != 4);

}
