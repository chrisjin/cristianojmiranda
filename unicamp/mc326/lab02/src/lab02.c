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
	FILE* inFile = Fopen(argv[1], "rw");

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
	printf(getMessage("lab02.label.menu.insert"), "\n");
	printf(getMessage("lab02.label.menu.remove"), "\n");
	printf(getMessage("lab02.label.menu.find"), "\n");
	printf(getMessage("lab02.label.menu.encerrar"), "\n");
}

/** Executa os testes unitarios da aplicação */
void unitTests() {

	// ########################################
	printf("* metodo strUpperCase.\n");
	printf("\t.cenario 1");
	char *in = "abacaxi";
	char *out = "ABACAXI";
	char *result = strUpperCase(in);
	if (strcmp(result, out) == 0) {
		printf(" - OK\n");
	} else {
		printf(" - Failed\n");
	}
	free(result);

	printf("\t.cenario 2");
	char *in2 = " ";
	char *out2 = " ";
	char *result2 = strUpperCase(in2);
	if (strcmp(result2, out2) == 0) {
		printf(" - OK\n");
	} else {
		printf(" - Failed\n");
	}
	free(result2);

	printf("\t.cenario 3");
	char *in3 = "0123456789  AA BB CC !@#$";
	char *out3 = "0123456789  AA BB CC !@#$";
	char *result3 = strUpperCase(in3);
	if (strcmp(result3, out3) == 0) {
		printf(" - OK\n");
	} else {
		printf(" - Failed\n");
	}
	free(result3);

	printf("\t.cenario 4");
	char *in4 = "baTAtinha";
	char *out4 = "BATATINHA";
	char *result4 = strUpperCase(in4);
	if (strcmp(result4, out4) == 0) {
		printf(" - OK\n");
	} else {
		printf(" - Failed\n");
	}
	free(result4);

	// ########################################
	printf("* metodo strSplit.\n");
	printf("\t.cenario 1");
	char *in5 = "a:bb:ccc:dddd";
	int size5;
	char **result5 = strSplit(in5, ":", &size5);
	if (size5 == 4) {
		printf(" - OK\n");
	} else {
		printf(" - Failed\n");
	}
	//	strArrayFree(result5, size5);

	printf("\t.cenario 2");
	int i, sucesso = true;
	for (i = 0; i < size5; i++) {
		if (i == 0 && strcmp(result5[i], "a") == 0) {
			continue;
		}

		if (i == 1 && strcmp(result5[i], "bb") == 0) {
			continue;
		}

		if (i == 2 && strcmp(result5[i], "ccc") == 0) {
			continue;
		}

		if (i == 3 && strcmp(result5[i], "dddd") == 0) {
			continue;
		}
		sucesso = false;
		break;
	}

	if (sucesso) {
		printf(" - OK\n");
	} else {
		printf(" - Failed\n");
	}

	// ########################################
	printf("* metodo strMerge.\n");
	printf("\t.cenario 1");
	char *in6 = "W W     W . GOO GLE. C OM.  B              R";
	char *out6 = "W__W__W__.__GOO__GLE.__C__OM.__B__R";
	char *result6 = strMerge(in6, ESPACE, "__");
	if (strcmp(result6, out6) == 0) {
		printf(" - OK\n");
	} else {
		printf(" - Failed\n");
	}
	//	free(result6);

	printf("\t.cenario 2");
	char *in7 = "um     dois                tres quatro             cinco";
	char *out7 = "um dois tres quatro cinco";
	char *result7 = strMerge(in7, ESPACE, ESPACE);
	if (strcmp(result7, out7) == 0) {
		printf(" - OK\n");
	} else {
		printf(" - Failed\n");
	}
	//	free(result7);

	// ########################################
	printf("* metodo strCharCount.\n");
	printf("\t.cenario 1");
	int count1 = strCharCount("abacAda", 'a', false);
	if (count1 == 4) {
		printf(" - OK\n");
	} else {
		printf(" - Failed\n");
	}

	printf("\t.cenario 2");
	count1 = strCharCount("abacAda", 'a', true);
	if (count1 == 3) {
		printf(" - OK\n");
	} else {
		printf(" - Failed\n");
	}

	printf("\t.cenario 3");
	count1 = strCharCount("abacAda", 'A', true);
	if (count1 == 1) {
		printf(" - OK\n");
	} else {
		printf(" - Failed\n");
	}

	printf("\t.cenario 4");
	count1 = strCharCount("abacAda", 'A', false);
	if (count1 == 4) {
		printf(" - OK\n");
	} else {
		printf(" - Failed\n");
	}

}
