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
#include "mem.h"
#include "aluno.h"

/** Guarda dados do aluno em struct */
Aluno newAluno(char *value) {

	/*	debug("Valida se o RA do aluno é numerico");
	 if (!isNumeric(dados[1])) {
	 error(getMessage("lab01b.label.ra_numerico"), "\n\n");
	 }*/

	// Monta o aluno
	Aluno aln = MEM_ALLOC(Aluno);

	int inicio = atoi(getProperty("aluno.field.start.ra"));
	int fim = atoi(getProperty("aluno.field.end.ra"));

	// Obtem o ra do aluno
	char *ra = strSubString(value, inicio, fim);
	aln->ra = atoi(ra);

	inicio = atoi(getProperty("aluno.field.start.nome"));
	fim = atoi(getProperty("aluno.field.end.nome"));
	char *data = strSubString(value, inicio, fim);
	aln->nome = MEM_ALLOC_N(char, strlen(data));
	strcat(aln->nome, data);

	inicio = atoi(getProperty("aluno.field.start.cidade"));
	fim = atoi(getProperty("aluno.field.end.cidade"));
	data = strSubString(value, inicio, fim);
	aln->cidade = MEM_ALLOC_N(char, strlen(data));
	strcat(aln->cidade, data);

	inicio = atoi(getProperty("aluno.field.start.telContato"));
	fim = atoi(getProperty("aluno.field.end.telContato"));
	data = strSubString(value, inicio, fim);
	aln->telContato = MEM_ALLOC_N(char, strlen(data));
	strcat(aln->telContato, data);

	inicio = atoi(getProperty("aluno.field.start.telAlternativo"));
	fim = atoi(getProperty("aluno.field.end.telAlternativo"));
	data = strSubString(value, inicio, fim);
	aln->telAlternativo = MEM_ALLOC_N(char, strlen(data));
	strcat(aln->telAlternativo, data);

	inicio = atoi(getProperty("aluno.field.start.sexo"));
	fim = atoi(getProperty("aluno.field.end.sexo"));
	data = strSubString(value, inicio, fim);
	aln->sexo = data[0];

	inicio = atoi(getProperty("aluno.field.start.curso"));
	fim = atoi(getProperty("aluno.field.end.curso"));
	data = strSubString(value, inicio, fim);
	aln->curso = atoi(data);

	return aln;
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

	printf(getMessage("aluno.label.dados.ra"), "\n\n\t", aluno->ra, "\n");
	printf(getMessage("aluno.label.dados.nome"), "\t\t", aluno->nome, "\n");
	printf(getMessage("aluno.label.dados.cidade"), "\t\t", aluno->cidade, "\n");
	printf(getMessage("aluno.label.dados.tel_contato"), "\t\t",
			aluno->telContato, "\n");
	printf(getMessage("aluno.label.dados.tel_alternativo"), "\t\t",
			aluno->telAlternativo, "\n");
	printf(getMessage("aluno.label.dados.sexo"), "\t\t", SEXO(aluno->sexo),
			"\n");
	printf(getMessage("aluno.label.dados.curso"), "\t\t", aluno->curso, "\n\n");

}

/**
 * Cria o arquivo de formato variavel.
 *
 * param inputFile - Nome do arquivo de entrada.
 * param outputFile - Nome do arquivo de saida.
 */
Aluno processarArquivoFormatoVariavel(char *inputFile, char outputFile) {

	FILE *inFile = Fopen(inputFile, "r");

	char line[READ_BUFFER_SIZE];

	Aluno list;
	while (fgets(line, READ_BUFFER_SIZE, inFile) != NULL) {

		Aluno a = newAluno(line);
		showAluno(a);

	}

	fclose(inFile);

	return list;

}

