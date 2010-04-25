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

	debug("Armazena o tamanho do output para consulta de arquivo fixo");
	char *fileOutputArqFixo;

	debug("Lista de alunos processados");
	LIST alunos = NULL;

	debug("Declarando variaveis da aplicação");
	int opcao;

	do {

		debug("Exibe o menu do sistema");
		showMenu();

		debug("Obtendo a opção do sistema");
		//read_int("\nEntre com uma opcao:", opcao, 2);
		scanf("%i", &opcao);
		//getchar();

		switch (opcao) {

		case 1:
			debug("Processa o arquivo de tamanho variavel");
			loadAlunos(alunos, (char*) argv[1], (char*) argv[2]);
			break;
		case 2:
			loadAlunos(alunos, (char*) argv[1], (char*) argv[2]);
			fileOutputArqFixo = showArquivoFormatoFixo(alunos);
			if (fileOutputArqFixo != NULL) {
				system(str_join("firefox ", str_join(fileOutputArqFixo, " &")));
			}
			break;
		case 3:
			debug("Verifica se a lista de alunos foi criada");
			if (alunos == NULL) {
				debug(
						"Caso a lista de alunos não tenha sido processada, cria o arquivo de tamanho variavel");
				processarArquivoFormatoVariavel((char*) argv[1],
						(char*) argv[2]);
			}

			showInformacoesArquivoVariavel((char *) argv[2], alunos);
			break;
		case 4:
			break;
		case 5:
			break;
		case 6:
			loadAlunos(alunos, (char*) argv[1], (char*) argv[2]);
			extractFileKey(alunos);
			break;
		default:
			if (opcao != 13) {
				printf(getMessage("lab02.label.opcao_invalida"), "\n");
			}
			break;
		}

	} while (opcao != 13);

	debug("Libera a memoria alocada e finaliza o programa");
	freeAluno(alunos);
	finalizeLog();
	freeBundle();
	return 0;

}

/** Exibe o menu da aplicação */
void showMenu() {
	printf(getMessage("lab02.label.menu"), "\n");
	printf(getMessage("lab02.label.menu.processar_arquivo_variavel"), "\n");
	printf(getMessage("lab02.label.menu.listar_arquivo_fixo"), "\n");
	printf(getMessage("lab02.label.menu.listar_arquivo_variavel"), "\n");
	//printf(getMessage("lab02.label.menu.insert"), "\n");
	//printf(getMessage("lab02.label.menu.remove"), "\n");
	//printf(getMessage("lab02.label.menu.find"), "\n");
	printf(getMessage("lab02.label.menu.encerrar"), "\n");
}

/**
 * Cria a estrutura de alunos.
 */
void loadAlunos(LIST alunos, char *input, char *output) {

	debug("Verifica se a lista de alunos foi criada");
	if (alunos == NULL) {
		debug(
				"Caso a lista de alunos não tenha sido processada, cria o arquivo de tamanho variavel");
		alunos = processarArquivoFormatoVariavel(input, output);
	}

	nodeptr n = alunos->content;
	//n = n->next;
	int count = 0;
	printf("============================\n");
	while (n != NULL) {

		Aluno a = n->value;
		printf("%i - %s\n", a->ra, a->nome);
		n = n->next;
		count++;

		if (count >= listSize(alunos) /* || n == n->next */)
			break;

	}
	printf("============================\n");

}
