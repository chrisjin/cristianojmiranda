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
#include "lab02.h"

int main(int argc, char * argv[]) {

	// Configuração do mecanismo de debug
	initializeLog();

	debug("Verifica se o usuario informou o nome do arquivo.");
	if (argc <= 2) {
		printf(getMessage("lab02.label.arquivo_obrigatorio"), "\n");
		exit(ERROR_EXECUTION);
	}

	debug("Abrindo o arquivo de dados");
	FILE* inFile = Fopen(argv[1], "r");

	debug("Declarando variaveis da aplicação");
	char opcao;

	do {

		debug("Exibe o menu do sistema");
		showMenu();

		debug("Obtendo a opção do sistema");
		scanf("%c", &opcao);
		getchar();

		switch (opcao) {

		case '1':
			processarArquivoFormatoVariavel((char*) argv[1], (char*)argv[2]);
			break;
		case '2':
			break;
		case '3':
			break;
		case '4':
			break;
		case '5':
			break;
		default:
			if (opcao != '6') {
				printf(getMessage("lab02.label.opcao_invalida"), "\n");
			}
			break;
		}

	} while (opcao != '6');

	debug("Fechando arquivo de dados");
	fclose(inFile);

	finalizeLog();
	return 0;

}

/** Exibe o menu da aplicação */
void showMenu() {
	printf(getMessage("lab02.label.menu"), "\n");
	printf(getMessage("lab02.label.menu.processar_arquivo_variavel"), "\n");
	printf(getMessage("lab02.label.menu.insert"), "\n");
	printf(getMessage("lab02.label.menu.remove"), "\n");
	printf(getMessage("lab02.label.menu.find"), "\n");
	printf(getMessage("lab02.label.menu.encerrar"), "\n");
}

