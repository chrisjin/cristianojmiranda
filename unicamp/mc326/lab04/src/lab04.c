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
	validaEntrada(argc, argv);

	int promoted; /* boolean: tells if a promotion from below */
	short root, /* rrn of root page                         */
	promo_rrn; /* rrn promoted from below                  */
	char promo_key, /* key promoted from below             */
	key; /* next key to insert in tree               */

	if (btopen()) /* try to open btree.dat and get root       */
		root = getroot();
	else
		/* if btree.dat not there, create it        */
		root = create_tree();

	while ((key = getchar()) != 'q') {
		promoted = insert(root, key, &promo_rrn, &promo_key);
		if (promoted)
			root = create_root(promo_key, root, promo_rrn);
	}
	btclose();

	debug("Libera a memoria alocada e finaliza o programa");
	finalizeLog();
	freeBundle();
	return 0;

}

/**
 * Verifica se os parametros de entrada sao validos.
 */
boolean validaEntrada(int argc, char *argv[]) {

	if (argc < 2) {
		printf(getMessage("lab02.label.arquivo_obrigatorio"), END_OF_LINE);
		exit(EXIT_FAILURE);
	}

	debug("Verifica se a ordem eh numerica");
	if (!isNumeric(argv[1])) {
		printf(getMessage("lab02.label.ordem_nao_numerica"), END_OF_LINE);
		exit(EXIT_FAILURE);
	}

	debug("Verifica se a ordem da b-tree esta entre 3 e 10 (inclusive).");
	if (atoi(argv[1]) < 3 || atoi(argv[1]) > 10) {
		printf(getMessage("lab02.label.ordem_invalida"), END_OF_LINE);
		exit(EXIT_FAILURE);
	}

	return true;
}
