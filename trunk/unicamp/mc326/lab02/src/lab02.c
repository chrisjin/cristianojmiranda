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
	int RA;
	char *str_ra = NULL;
	Aluno aluno;

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
			debug("Processa o arquivo de tamanho variavel");
			alunos = loadAlunos(alunos, (char*) argv[1], (char*) argv[2]);
			break;
		case 2:
			alunos = loadAlunos(alunos, (char*) argv[1], (char*) argv[2]);
			fileOutputArqFixo = showArquivoFormatoFixo(alunos);
			if (fileOutputArqFixo != NULL) {
				system(str_join("firefox ", str_join(fileOutputArqFixo, " &")));
			}
			break;
		case 3:
			alunos
					= carregarAlunoArquivoVariavel((char*) argv[2], alunos,
							true);
			break;
		case 4:
			printf(getMessage("aluno.label.digite_ra_aluno"), "\n\n", "\n");
			str_ra = getLine();
			RA = -1;
			if (isNumeric(str_ra)) {
				RA = atoi(str_ra);
				aluno = findAlunoByRaArquivoVariavel(RA, (char *) argv[2]);

				if (aluno == NULL) {

					printf(getMessage("aluno.label.registroInexistente"), "\n");

				} else {
					showAluno(aluno);
				}
			} else {
				printf(getMessage("lab02.label.opcao_invalida"), " RA.\n");
			}

			break;
		case 5:
			break;
		case 6:
			extractFileKey((char *) argv[2]);
			break;
		case 7:
			sortFileKey((char *) argv[2]);
			break;
		case 8:
			extractFileKey((char *) argv[2]);
			showFile(INDEX_ALUNO_FILE);
			break;
		case 9:
			sortFileKey((char *) argv[2]);
			showFile(INDEX_ALUNO_FILE_SORTED);
			break;
		case 11:
			sortFileKey((char *) argv[2]);

			printf(getMessage("aluno.label.digite_ra_aluno"), "\n\n", "\n");
			str_ra = getLine();
			RA = -1;
			if (isNumeric(str_ra)) {
				RA = atoi(str_ra);
				aluno = findAlunoIndexByRa(RA, INDEX_ALUNO_FILE_SORTED,
						(char *) argv[2]);

				if (aluno == NULL) {

					printf(getMessage("aluno.label.registroInexistente"), "\n");

				} else {
					showAluno(aluno);
				}
			} else {
				printf(getMessage("lab02.label.opcao_invalida"), " RA.\n");
			}

			break;
		case 12:
			sortFileKey((char *) argv[2]);

			printf(getMessage("aluno.label.digite_ra_aluno"), "\n\n", "\n");
			str_ra = getLine();
			RA = -1;
			if (isNumeric(str_ra)) {
				RA = atoi(str_ra);
				if (deleteAluno(RA, INDEX_ALUNO_FILE_SORTED, (char *) argv[2])
						< 0) {
					printf(getMessage("aluno.label.registroInexistente"), "\n");

				} else {
					printf(getMessage("aluno.label.registroDeletado"), "\n");
				}
			} else {
				printf(getMessage("lab02.label.opcao_invalida"), " RA.\n");
			}

			break;

		default:
			if (opcao != 13) {
				printf(getMessage("lab02.label.opcao_invalida"), "\n");
			}
			break;
		}

	} while (opcao != 13);

	debug("Libera a memoria alocada e finaliza o programa");
	freeAlunoList(alunos);
	//freeAluno(aluno);
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
	printf(getMessage("lab02.label.menu.find_aluno_ra"), "\n");
	printf(getMessage("lab02.label.menu.extracao_chaves"), "\n");
	printf(getMessage("lab02.label.menu.classificacao_chaves"), "\n");
	printf(getMessage("lab02.label.menu.listar_chaves"), "\n");
	printf(getMessage("lab02.label.menu.listar_chaves_classificadas"), "\n");
	printf(getMessage("lab02.label.menu.pesquisar_pelo_index"), "\n");
	printf(getMessage("lab02.label.menu.remocao_registro"), "\n");
	printf(getMessage("lab02.label.menu.encerrar"), "\n");
}

/**
 * Cria a estrutura de alunos.
 */
LIST loadAlunos(LIST alunos, char *input, char *output) {

	debug(
			"Caso a lista de alunos não tenha sido processada, cria o arquivo de tamanho variavel");
	alunos = processarArquivoFormatoVariavel(input, output);

	return alunos;

}
