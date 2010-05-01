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

int alternate = true;

/** Guarda dados do aluno em struct */
Aluno newAluno(char *value) {

	debug("Cria um novo aluno apartir ");

	// Obtem a posição do ultimo caracter de arquivo fixo
	int sizeLine = atoi(getProperty("aluno.field.end.fimregistro"));
	if (value == NULL || strlen(value) < sizeLine)
		return NULL;

	// Monta o aluno
	Aluno aln = (Aluno) MEM_ALLOC(Aluno);

	int inicio = atoi(getProperty("aluno.field.start.ra"));
	int fim = atoi(getProperty("aluno.field.end.ra"));

	debug("Obtem o ra do aluno");
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
Aluno findAlunoIndexByRa(int ra, char *indexFile) {

	Aluno a = NULL;

	if (indexByRa(ra) == INDEX_NOT_FOUND_FOR_ALUNO) {
	}

	return a;
}

int indexByRa(int ra, char *indexFile) {

	debug("Abre o arquivo para leitura");
	FILE *arq = Fopen(indexFile, "r");

	int tmpRa = 0;
	char split = NULL;
	char line[READ_BUFFER_SIZE];

	debug("Localizando a chave no arquivo ");
	while (fgets(line, READ_BUFFER_SIZE, arq) != NULL) {

		split = strtok(strip(line), " ");
		if (split != NULL) {

			tmpRa = atoi(split);
			debugi("Lendo RA: ", tmpRa);
			if (tmpRa == ra) {

				debug("Ra localizado. Obtendo posicao");

				split = strtok(END_STR_TOKEN, " ");
				if (split == NULL) {
					error("Arquivo de indexes corrompido");
				} else {

					break;
				}

			}

		}

	}

	debug("Fechando o arquivo de indexes");

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
				"\n");
		printf(getMessage("aluno.label.posicao"), "\t\t", aluno->byteIndex,
				"\n\n");
	}

}

/**
 * Cria o arquivo de formato variavel.
 *
 * param inputFile - Nome do arquivo de entrada.
 * param outputFile - Nome do arquivo de saida.
 */
LIST processarArquivoFormatoVariavel(char *inputFile, char *outputFile) {

	debug(
			"Processando criacao do arquivo variavel e retornando estrutura de alunos");

	FILE *inFile = Fopen(inputFile, "r");
	FILE *outFile = Fopen(outputFile, "w");

	char line[READ_BUFFER_SIZE];

	debug("Aloca a lista de alunos");
	LIST list = newList();
	list->content = NULL;
	list->count = 0;

	debug("Processa o arquivo de tamanho fixo, criando a lista de alunos");
	Aluno aluno = NULL;
	while (fgets(line, READ_BUFFER_SIZE, inFile) != NULL) {

		debug("Criando um novo aluno apartir da linha de tamanho fixo");
		aluno = newAluno(line);

		writeFileFormatoVariavel(outFile, aluno);
		showAluno(aluno);

		debug("Adiciona o aluno a lista");
		rearInsert(list, aluno);
	}

	fclose(outFile);
	fclose(inFile);

	printf(getMessage("aluno.label.processarArquivo.registrosLidos"), "\n\n\t",
			list->count, "\n");
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

/**
 * Exibe as informacoes do arquivo de tamanho variavel.
 *
 * param arqVariavel nome do arquivo variavel
 * param alunos estrutura de alunos processados
 */
void showInformacoesArquivoVariavel(char *arqVariavel) {

	debug("Exibe as informacoes do arquivo variavel para consulta");

	if (arqVariavel == NULL)
		return;

	char aux;
	int inicio = 0;
	int fim = 0;

	Aluno tmp = NULL;

	debug("Abre o arquivo para leitura");
	FILE *fl = Fopen(arqVariavel, "r");

	while (!feof(fl)) {

		aux = fgetc(fl);

		while (aux != EOF && aux != getProperty(
				"aluno.arquivo.variavel.fimregistro")[0]) {
			fim++;
			if (aux == getProperty("aluno.arquivo.variavel.token")[0]) {
				printf(" ");
			} else {
				printf("%c", aux);
			}

			aux = fgetc(fl);
		}

		if (fim - inicio != 0) {
			printf(getMessage("aluno.label.processarArquivo.inicioRegistro"),
					"\n", inicio);
			printf(getMessage("aluno.label.processarArquivo.tamanhoRegistro"),
					"\n", (fim - inicio));

			inicio = fim;
		}

		printf("\n");

	}

	fclose(fl);

}

/**
 * Processa a lista de arquivo de tamanho variavel.
 */
LIST carregarAlunoArquivoVariavel(char *inputFile, LIST alunos,
		boolean exibirAluno) {

	debug("Verifica se a lista de alunos não foi criada");
	if (alunos == NULL) {
		debug("Cria a lista de alunos");
		alunos = newList();
	}

	debug("Abre o arquivo de tamanho variavel para leitura");
	FILE *arq = Fopen(inputFile, "r");

	debug("Obtem o token que separa os registros para arquivo variavel");
	char *token = getProperty("aluno.arquivo.variavel.token");

	char line[READ_BUFFER_SIZE];
	int ra = -1, countRec = 0;
	int index = 0, lineSize = 0;
	boolean inList = false;
	Aluno aluno = NULL;
	char *tmp;
	while (fgets(line, READ_BUFFER_SIZE, arq) != NULL) {

		debug("Obtem o tamanho da linha");
		lineSize = strlen(line);

		countRec = 1;

		debugs("Processando linha: ", line);
		char *registro = strtok(line, token);

		debug("Obtem o ra");
		ra = atoi(registro);

		debug("Verifica se o aluno existe na lista");
		aluno = findAlunoByRaList(alunos, ra);
		if (aluno == NULL) {

			inList = false;
			aluno = MEM_ALLOC(Aluno);

		} else {
			inList = true;
		}

		while (registro) {
			tmp = strip(registro);

			if (!inList) {
				switch (countRec) {

				case 1:
					aluno->ra = ra;
					break;
				case 2:
					aluno->nome = MEM_ALLOC_N(char, strlen(tmp));
					strcpy(aluno->nome, tmp);
					break;
				case 3:
					aluno->cidade = MEM_ALLOC_N(char, strlen(tmp) );
					strcpy(aluno->cidade, tmp);
					break;
				case 4:
					aluno->telContato = MEM_ALLOC_N(char, strlen(tmp));
					strcpy(aluno->telContato, tmp);
					break;
				case 5:
					aluno->telAlternativo = MEM_ALLOC_N(char, strlen(tmp));
					strcpy(aluno->telAlternativo, tmp);
					break;
				case 6:
					aluno->sexo = registro[0];
					break;
				case 7:
					aluno->curso
							= atoi(strSubString(tmp, 0, (strlen(tmp) - 2)));
					break;
				default:
					break;
				}
			}

			registro = strtok(END_STR_TOKEN, token);
			countRec++;
		}

		debug("Seta a posicao no arquivo");
		aluno->byteIndex = index;

		debug("Incrementa a posicao em byte no arquivo");
		index += lineSize;

		if (!inList) {
			debug("Insere o novo aluno na lista");
			rearInsert(alunos, aluno);
		}

		if (exibirAluno) {
			debug("Exibe os dados do aluno");
			showAluno(aluno);
		}

	}

	fclose(arq);

	return alunos;

}

/**
 * Obtem um aluno no arquivo variavel.
 */
Aluno findAlunoByRaArquivoVariavel(int ra, char *fileName) {

	debug("Abre o arquivo de tamanho variavel para leitura");
	FILE *arq = Fopen(fileName, "r");

	debug("Obtem o token que separa os registros para arquivo variavel");
	char *token = getProperty("aluno.arquivo.variavel.token");

	char line[READ_BUFFER_SIZE];
	int ra_registro = -1, countRec = 0;
	int index = 0, lineSize = 0;
	Aluno aluno = NULL;
	char *tmp;
	while (fgets(line, READ_BUFFER_SIZE, arq) != NULL) {

		lineSize = strlen(line);
		countRec = 1;

		debugs("Processando linha: ", line);
		char *registro = strtok(line, token);

		debug("Obtem o ra");
		ra_registro = atoi(registro);

		debug("Verifica se eh o RA procurado");
		if (ra_registro != ra) {
			index += lineSize;
			debug("RA invalido. Pulando para o proximo registro.");
			continue;
		}

		debug("Aloca memoria para o aluno");
		aluno = MEM_ALLOC(Aluno);
		aluno->byteIndex = index;

		while (registro) {
			tmp = strip(registro);

			switch (countRec) {

			case 1:
				aluno->ra = ra_registro;
				break;
			case 2:
				aluno->nome = MEM_ALLOC_N(char, strlen(tmp));
				strcpy(aluno->nome, tmp);
				break;
			case 3:
				aluno->cidade = MEM_ALLOC_N(char, strlen(tmp) );
				strcpy(aluno->cidade, tmp);
				break;
			case 4:
				aluno->telContato = MEM_ALLOC_N(char, strlen(tmp));
				strcpy(aluno->telContato, tmp);
				break;
			case 5:
				aluno->telAlternativo = MEM_ALLOC_N(char, strlen(tmp));
				strcpy(aluno->telAlternativo, tmp);
				break;
			case 6:
				aluno->sexo = registro[0];
				break;
			case 7:
				aluno->curso = atoi(strSubString(tmp, 0, (strlen(tmp) - 2)));
				break;
			default:
				break;
			}

			registro = strtok(END_STR_TOKEN, token);
			countRec++;
		}

		if (aluno != NULL)
			break;

	}

	fclose(arq);

	return aluno;

}

/**
 * Exibe a estrutura do arquivo de tamanho fixo.
 *
 * param alunos - Estrutura de alunos processados.
 */
char *showArquivoFormatoFixo(LIST alunos) {

	debug("Exibe o arquivo de tamanho fixo para consulta");

	debug("Escreve output de consulta em html");
	FILE *outFile = Fopen(ARQUIVO_CONSULTA_FIXO_HTML, "w");

	writeFileFormatoHTML_inicio(outFile);

	debug("Obtem o primeiro item da lista");

	int i = 0;
	nodeptr n = alunos->content;
	while (n != NULL) {

		Aluno aluno = n->value;

		writeFileFormatoHTML(outFile, aluno);
		showAluno(aluno);

		i++;
		if (i >= listSize(alunos)) {
			break;
		}

		n = n->next;

	}

	writeFileFormatoHTML_fim(outFile);

	fclose(outFile);

	return ARQUIVO_CONSULTA_FIXO_HTML;
}

void writeFileFormatoHTML_inicio(FILE *file) {
	fprintf(file, cabecalho);
}

void writeFileFormatoHTML(FILE *file, Aluno aln) {

	if (file != NULL && aln != NULL && aln->nome != NULL) {

		if (alternate) {
			fprintf(
					file,
					"<tr style='background: gray;' ><td><pre>%i</pre></td><td><pre>%s</pre></td><td><pre>%s</pre></td><td><pre>%s</pre></td><td><pre>%s</pre></td><td><pre>%c</pre></td><td><pre>%i</pre></td></tr>",
					aln->ra, aln->nome, aln->cidade, aln->telContato,
					aln->telAlternativo, aln->sexo, aln->curso);

		} else {
			fprintf(
					file,
					"<tr style='background: white;' ><td><pre>%i</pre></td><td><pre>%s</pre></td><td><pre>%s</pre></td><td><pre>%s</pre></td><td><pre>%s</pre></td><td><pre>%c</pre></td><td><pre>%i</pre></td></tr>",
					aln->ra, aln->nome, aln->cidade, aln->telContato,
					aln->telAlternativo, aln->sexo, aln->curso);
		}
		alternate = !alternate;
	}

}

void writeFileFormatoHTML_fim(FILE *file) {
	fprintf(file, FIM_HTML);
}

/**
 * Monta o arquivo com as chaves para indexar o arquivo de tamanho variavel.
 *
 */
void extractFileKey(char *inputFile) {

	if (inputFile != NULL) {

		debug("Cria o arquivo de index de aluno");
		FILE *indexFile = Fopen(INDEX_ALUNO_FILE, "w");

		debug("Abre o arquivo de tamanho variavel para leitura");
		FILE *arq = Fopen(inputFile, "r");

		debug("Obtem o token que separa os registros para arquivo variavel");
		char *token = getProperty("aluno.arquivo.variavel.token");

		char line[READ_BUFFER_SIZE];
		int ra = -1;
		int index = 0, lineSize = 0;
		while (fgets(line, READ_BUFFER_SIZE, arq) != NULL) {

			debug("Obtem o tamanho da linha");
			lineSize = strlen(line);

			debugs("Processando linha: ", line);
			char *registro = strtok(line, token);

			debug("Obtem o ra");
			ra = atoi(registro);
			fprintf(indexFile, "%i=%i\n", ra, index);

			debug("Incrementa a posicao em byte no arquivo");
			index += lineSize;

		}

		fclose(arq);

		debug("Fecha o arquivo de index");
		fclose(indexFile);
	}

}

/**
 * Ordena o arquivo de index
 */
void sortFileKey(char *inputFile) {

	debug("Cria o arquivo de indexes");
	extractFileKey(inputFile);

	system(str_join("sort ", str_join(INDEX_ALUNO_FILE, str_join(" > ",
			INDEX_ALUNO_FILE_SORTED))));

}

/**
 * Libera da memoria a estrutura de alunos.
 *
 * param alunos - Estrutura de alunos a serem liberadas.
 */
void freeAluno(Aluno aluno) {

	debug("Removendo aluno da memoria");

	if (aluno != NULL) {
		debugi("Removendo da memoria aluno ", aluno->ra);
		free(aluno);
	}

}

/**
 * Libera da memoria a estrutura de alunos.
 *
 * param alunos - Estrutura de alunos a serem liberadas.
 */
void freeAlunoList(LIST alunos) {

	if (alunos != NULL) {

		freeList(alunos, freeAluno);

	}

}

/**
 * Obtem um aluno pelo ra.
 */
Aluno findAlunoByRaList(LIST alunos, int ra) {

	if (alunos != NULL && alunos->count > 0) {
		nodeptr n = alunos->content;
		int count = 0;
		while (n != NULL) {

			Aluno a = n->value;
			if (a->ra == ra)
				return a;

			n = n->next;
			count++;

			if (count >= listSize(alunos)) {
				return NULL;
			}
		}
	}

	return NULL;

}

