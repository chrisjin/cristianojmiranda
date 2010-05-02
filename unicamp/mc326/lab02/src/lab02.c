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

	debug("Verifica se o arquivo de entrada existe");
	if (!fileExists(argv[2])) {
		printf(getMessage("lab02.label.arquivo_invalido"), argv[2], "\n");
		exit(ERROR_EXECUTION);
	}

	debug("Declarando variaveis da aplicação");
	int raInput;
	int opcao;
	Aluno aluno;
	char *strRaInput = NULL;
	boolean showBrowser = false;

	debug("Carrega sim-nao");
	char *sim = strUpperCase(getMessage("lab02.input.sim"));
	char *nao = strUpperCase(getMessage("lab02.input.nao"));

	debug("Armazena o tamanho do output para consulta de arquivo fixo");
	char *fileOutputArqFixo = NULL;

	do {

		debug("Exibe o menu do sistema");
		showMenu();

		debug("Obtendo a opção do sistema");
		char *str_opcao = getLine(false);

		opcao = -1;
		if (isNumeric(str_opcao)) {
			opcao = atoi(str_opcao);
		}

		switch (opcao) {

		case 1:
			debug("Processa o arquivo de tamanho variavel");
			fileOutputArqFixo = processarArquivoFormatoVariavel(
					(char *) argv[1], (char *) argv[2], false, false, true);
			break;
		case 2:

			strcpy(str_opcao, "**");
			showBrowser = false;
			while (strcmp(strUpperCase(str_opcao), sim) != 0 && strcmp(
					strUpperCase(str_opcao), nao) != 0) {
				printf(getMessage("aluno.label.showArquivo.abrirBrowser"),
						"\n\t", "\n");
				str_opcao = getLine();
			}

			if (strcmp(strUpperCase(str_opcao), sim) == 0) {
				showBrowser = true;
			}

			if (!showBrowser && fileOutputArqFixo != NULL) {
				fileOutputArqFixo = NULL;
			}

			fileOutputArqFixo = processarArquivoFormatoVariavel(
					(char *) argv[1], (char *) argv[2], !showBrowser,
					!showBrowser, showBrowser);

			if (showBrowser && fileOutputArqFixo != NULL) {
				system(str_join("firefox ", str_join(fileOutputArqFixo, " &")));
			}

			break;
		case 3:

			strcpy(str_opcao, "**");
			showBrowser = false;
			while (strcmp(strUpperCase(str_opcao), sim) != 0 && strcmp(
					strUpperCase(str_opcao), nao) != 0) {
				printf(getMessage("aluno.label.showArquivo.abrirBrowser"),
						"\n\t", "\n");
				str_opcao = getLine();
			}

			if (strcmp(strUpperCase(str_opcao), sim) == 0) {
				showBrowser = true;
			}

			debug("Carrega o arquivo variavel");
			fileOutputArqFixo = carregarAlunoArquivoVariavel((char*) argv[2],
					!showBrowser, showBrowser, (char *) argv[1]);

			if (showBrowser && fileOutputArqFixo != NULL) {
				system(str_join("firefox ", str_join(fileOutputArqFixo, " &")));
			}

			break;
		case 4:
			printf(getMessage("aluno.label.digite_ra_aluno"), "\n\n", "\n");
			strRaInput = getLine(false);
			raInput = -1;
			if (isNumeric(strRaInput)) {
				raInput = atoi(strRaInput);
				aluno = findAlunoByRaArquivoVariavel(raInput, (char *) argv[2],
						(char *) argv[1]);

				if (aluno == NULL) {

					printf(getMessage("aluno.label.registroInexistente"), "\n");

				} else {
					showAluno(aluno);
				}
			} else {
				printf(getMessage("lab02.label.opcao_invalida"), " Ra.\n");
			}

			break;
		case 5:
			break;
		case 6:

			if (!fileExists((char *) argv[2])) {
				debug("Processa o arquivo de tamanho variavel");
				fileOutputArqFixo = processarArquivoFormatoVariavel(
						(char *) argv[1], (char *) argv[2], false, false, true);
			}

			extractFileKey((char *) argv[2]);
			break;
		case 7:
			if (!fileExists((char *) argv[2])) {
				debug("Processa o arquivo de tamanho variavel");
				fileOutputArqFixo = processarArquivoFormatoVariavel(
						(char *) argv[1], (char *) argv[2], false, false, true);
			}

			sortFileKey((char *) argv[2]);
			break;
		case 8:
			if (!fileExists((char *) argv[2])) {
				debug("Processa o arquivo de tamanho variavel");
				fileOutputArqFixo = processarArquivoFormatoVariavel(
						(char *) argv[1], (char *) argv[2], false, false, true);
			}
			extractFileKey((char *) argv[2]);
			showFile(INDEX_ALUNO_FILE);
			break;
		case 9:

			if (!fileExists((char *) argv[2])) {
				debug("Processa o arquivo de tamanho variavel");
				fileOutputArqFixo = processarArquivoFormatoVariavel(
						(char *) argv[1], (char *) argv[2], false, false, true);
			}

			sortFileKey((char *) argv[2]);
			showFile(INDEX_ALUNO_FILE_SORTED);
			break;
		case 11:
			if (!fileExists((char *) argv[2])) {
				debug("Processa o arquivo de tamanho variavel");
				fileOutputArqFixo = processarArquivoFormatoVariavel(
						(char *) argv[1], (char *) argv[2], false, false, true);
			}

			sortFileKey((char *) argv[2]);

			printf(getMessage("aluno.label.digite_ra_aluno"), "\n\n", "\n");
			strRaInput = getLine(false);
			raInput = -1;
			if (isNumeric(strRaInput)) {
				raInput = atoi(strRaInput);
				aluno = findAlunoIndexByRa(raInput, INDEX_ALUNO_FILE_SORTED,
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
			strRaInput = getLine(false);
			raInput = -1;
			if (isNumeric(strRaInput)) {
				raInput = atoi(strRaInput);
				if (deleteAluno(raInput, INDEX_ALUNO_FILE_SORTED,
						(char *) argv[2]) < 0) {
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

