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

	// Obtem a posição do ultimo caracter de arquivo fixo
	int sizeLine = atoi(getProperty("aluno.field.end.fimregistro"));
	if (value == NULL || strlen(value) < sizeLine)
		return NULL;

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

	if (aluno != NULL && aluno->nome != NULL) {
		printf(getMessage("aluno.label.dados.ra"), "\n\n\t", aluno->ra, "\n");
		printf(getMessage("aluno.label.dados.nome"), "\t\t", aluno->nome, "\n");
		printf(getMessage("aluno.label.dados.cidade"), "\t\t", aluno->cidade,
				"\n");
		printf(getMessage("aluno.label.dados.tel_contato"), "\t\t",
				aluno->telContato, "\n");
		printf(getMessage("aluno.label.dados.tel_alternativo"), "\t\t",
				aluno->telAlternativo, "\n");
		printf(getMessage("aluno.label.dados.sexo"), "\t\t", SEXO(aluno->sexo),
				"\n");
		printf(getMessage("aluno.label.dados.curso"), "\t\t", aluno->curso,
				"\n\n");
	}

}

/**
 * Cria o arquivo de formato variavel.
 *
 * param inputFile - Nome do arquivo de entrada.
 * param outputFile - Nome do arquivo de saida.
 */
Aluno processarArquivoFormatoVariavel(char *inputFile, char *outputFile) {

	// Variaveis de estatistica
	long countRecords = 0;

	FILE *inFile = Fopen(inputFile, "r");
	FILE *outFile = Fopen(outputFile, "w");

	char line[READ_BUFFER_SIZE];

	Aluno list;
	while (fgets(line, READ_BUFFER_SIZE, inFile) != NULL) {

		Aluno a = newAluno(line);
		if (a != NULL && a->nome != NULL)
			countRecords++;

		writeFileFormatoVariavel(outFile, a);
		showAluno(a);

	}

	fclose(outFile);
	fclose(inFile);

	printf(getMessage("aluno.label.processarArquivo.registrosLidos"), "\n\n\t",
			countRecords, "\n");
	printf(getMessage("aluno.label.processarArquivo.tamanhoArqOriginal"), "\t",
			inputFile, fileSize(inputFile), "\n");
	printf(getMessage("aluno.label.processarArquivo.tamanhoArqConvertido"),
			"\t", outputFile, fileSize(outputFile), "\n\n");

	return list;

}

/**
 *
 */
void writeFileFormatoVariavel(FILE *file, Aluno aln) {

	if (file != NULL && aln != NULL && aln->nome != NULL) {
		char *separete = getProperty("aluno.arquivo.variavel.token");
		char *endLine = getProperty("aluno.arquivo.variavel.fimregistro");

		fprintf(file, "%i%s%s%s%s%s%s%s%s%s%c%s%i%s\n", aln->ra, separete,
				strip(aln->nome), separete, strip(aln->cidade), separete,
				strip(aln->telContato), separete, strip(aln->telAlternativo),
				separete, aln->sexo, separete, aln->curso, endLine);
	}

}

void opcao3(FILE *arqVariavel) {
	char aux;
	int inicio = 0;
	int fim = 0;

	if (arqVariavel != NULL) {

		while (!feof(arqVariavel)) {

			aux = fgetc(arqVariavel);

			while (aux != EOF && aux != getProperty(
					"aluno.arquivo.variavel.fimregistro")[0]) {
				fim++;
				if (aux == getProperty("aluno.arquivo.variavel.token")[0]) {
					printf(" ");
				} else {
					printf("%c", aux);
				}

				aux = fgetc(arqVariavel);
			}

			if (fim - inicio != 0) {
				printf("\n");
				printf("Inicio registro: byte %d\n", inicio);
				printf("Tamanho registro: %d bytes", fim - inicio);

				inicio = fim;
			}

			printf("\n");

		}

		fclose(arqVariavel);

	}

}

AlunoFixo newAlunoFixo(Aluno aluno) {

	int i;
	AlunoFixo fixo = MEM_ALLOC(AlunoFixo);

	fixo->ra = aluno->ra;

	clearString(fixo->nome);
	strcpy(fixo->nome, aluno->nome);

	clearString(fixo->cidade);
	strcpy(fixo->cidade, aluno->cidade);

	clearString(fixo->telContato);
	strcpy(fixo->telContato, aluno->telContato);

	clearString(fixo->telAlternativo);
	strcpy(fixo->telAlternativo, aluno->telAlternativo);

	if (aluno->sexo == NULL)
		fixo->sexo = ' ';
	else
		fixo->sexo = aluno->sexo;

	fixo->curso = aluno->curso;

	return fixo;
}

char *processarArquivoFormatoFixo(char *inputFile) {

	// Variaveis de estatistica
	long countRecords = 0;

	FILE *inFile = Fopen(inputFile, "r");
	FILE *outFile = Fopen(ARQUIVO_CONSULTA_FIXO_HTML, "w");

	char line[READ_BUFFER_SIZE];

	writeFileFormatoHTML_inicio(outFile);

	while (fgets(line, READ_BUFFER_SIZE, inFile) != NULL) {

		Aluno a = newAluno(line);
		AlunoFixo f;
		f = newAlunoFixo(a);
		if (f != NULL)
			countRecords++;

		writeFileFormatoHTML(outFile, f);
		showAlunoFixo(f);
		free(f);

	}

	writeFileFormatoHTML_fim(outFile);

	fclose(outFile);
	fclose(inFile);

	return ARQUIVO_CONSULTA_FIXO_HTML;
}

void writeFileFormatoHTML_inicio(FILE *file) {
	fprintf(file, cabecalho);
}

void writeFileFormatoHTML(FILE *file, AlunoFixo aln) {

	if (file != NULL && aln != NULL && aln->nome != NULL) {
		fprintf(
				file,
				"<tr><td><pre>%i</pre></td><td><pre>%s</pre></td><td><pre>%s</pre></td><td><pre>%s</pre></td><td><pre>%s</pre></td><td><pre>%c</pre></td><td><pre>%i</pre></td></tr>",
				aln->ra, aln->nome, aln->cidade, aln->telContato,
				aln->telAlternativo, aln->sexo, aln->curso);
	}

}

void writeFileFormatoHTML_fim(FILE *file) {
	fprintf(file, FIM_HTML);
}

void showAlunoFixo(AlunoFixo aluno) {

	if (aluno != NULL && aluno->nome != NULL) {
		printf(getMessage("aluno.label.dados.ra"), "\n\n\t", aluno->ra, "\n");
		printf(getMessage("aluno.label.dados.nome"), "\t\t", aluno->nome, "\n");
		printf(getMessage("aluno.label.dados.cidade"), "\t\t", aluno->cidade,
				"\n");
		printf(getMessage("aluno.label.dados.tel_contato"), "\t\t",
				aluno->telContato, "\n");
		printf(getMessage("aluno.label.dados.tel_alternativo"), "\t\t",
				aluno->telAlternativo, "\n");
		printf(getMessage("aluno.label.dados.sexo"), "\t\t", SEXO(aluno->sexo),
				"\n");
		printf(getMessage("aluno.label.dados.curso"), "\t\t", aluno->curso,
				"\n\n");
	}

}
