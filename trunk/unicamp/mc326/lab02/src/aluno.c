/*******************************************************************************

    Implementação do componente aluno para gerenciar dados de alunos da Unicamp.

    <lab02.c>

				
    Grupo 4: Cristiano J. Miranda  RA: 083382
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


/** Guarda dados do aluno numa Struct */
Aluno newAluno(char **dados) {

	debug("Valida se o RA do aluno é numerico");
	if (!isNumeric(dados[1])) {
		printf(getMessage("lab01b.label.ra_numerico"), "\n\n");
		exit(-1);
	}      

	Aluno arq1;
	arq1.nome = dados[0];
      	arq1.ra = atoi(dados[1]);
      	//arq1.c = dados[2][0];
      
      	return arq1;
}

/**
 * Obtem os dados de um aluno pelo RA.
 *
 */
Aluno findAlunoByRa(int ra, FILE *file) {

	Aluno a;

	if (indexByRa(ra) == INDEX_NOT_FOUND_FOR_ALUNO) {
	}

	return a;
}

int indexByRa(int ra) {
	return INDEX_NOT_FOUND_FOR_ALUNO;
}

/**
 * Exibe os dados de um aluno.
 *
 */
void showAluno(Aluno aluno) {

	printf(getMessage("aluno.label.dados.ra"), "\n\n\t", aluno.ra, "\n");
	printf(getMessage("aluno.label.dados.nome"), "\t\t", aluno.nome, "\n");
	printf(getMessage("aluno.label.dados.cidade"), "\t\t", aluno.cidade, "\n");
	printf(getMessage("aluno.label.dados.tel_contato"), "\t\t", aluno.telContato, "\n");
	printf(getMessage("aluno.label.dados.tel_alternativo"), "\t\t", aluno.telAlternativo, "\n");
	printf(getMessage("aluno.label.dados.sexo"), "\t\t", SEXO(aluno.sexo), "\n");
	printf(getMessage("aluno.label.dados.curso"), "\t\t", aluno.curso, "\n\n");

}

