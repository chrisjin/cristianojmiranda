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
#include<time.h>
#include "log.h"
#include "utils.h"
#include "bundle.h"
#include "mem.h"
#include "aluno.h"
#include "btreealuno.h"

int alternate = true;

/** Guarda dados do aluno em struct */
Aluno newAluno(char *value) {

	debug("Cria um novo aluno apartir das linhas do arquivo de tamanho fixo ");
	debugs("Linha: ", value);

	debug("Obtem a posição do ultimo caracter de arquivo fixo ");
	int sizeLine = atoi(getProperty("aluno.field.end.fimregistro"));
	if (value == NULL || strlen(value) < sizeLine) {

		debug(
				"Linha nao apresenta o tamanho minimo. Registro corrompido. Descartando registro.");

		return NULL;
	}

	debug("Alocando memoria para aluno");
	Aluno aln = (Aluno) MEM_ALLOC(Aluno);

	debug("Obtendo posicao para ra");
	int inicio = atoi(getProperty("aluno.field.start.ra"));
	int fim = atoi(getProperty("aluno.field.end.ra"));

	debug("Obtem o ra do aluno");
	char *ra = strSubString(value, inicio, fim);

	debug("Verificando se ra eh numerico");
	if (!isNumeric(ra)) {
		debug("RA do aluno deve ser numerico. Registro descartado.");
		free(aln);
		return NULL;
	}

	aln->ra = atoi(ra);

	debug("Obtendo nome do aluno");
	inicio = atoi(getProperty("aluno.field.start.nome"));
	fim = atoi(getProperty("aluno.field.end.nome"));
	char *data = strSubString(value, inicio, fim);

	debug("Verifica se o nome foi fornecido");
	if (isEmptyString(data)) {

		debug("Nome nao preenchido. Descartando registro.");
		return NULL;

	}

	aln->nome = MEM_ALLOC_N(char, strlen(data));
	strcat(aln->nome, data);

	debug("Obtendo cidade do aluno");
	inicio = atoi(getProperty("aluno.field.start.cidade"));
	fim = atoi(getProperty("aluno.field.end.cidade"));
	data = strSubString(value, inicio, fim);
	aln->cidade = MEM_ALLOC_N(char, strlen(data));
	strcat(aln->cidade, data);

	debug("Obtendo telefone de contato do aluno");
	inicio = atoi(getProperty("aluno.field.start.telContato"));
	fim = atoi(getProperty("aluno.field.end.telContato"));
	data = strSubString(value, inicio, fim);
	aln->telContato = MEM_ALLOC_N(char, strlen(data));
	strcat(aln->telContato, data);

	debug("Verifica se o telefone de contato foi fornecido");
	if (isEmptyString(aln->telContato)) {

		debug("Telefone de contato nao preenchido. Descartando registro.");
		return NULL;

	}

	inicio = atoi(getProperty("aluno.field.start.telAlternativo"));
	fim = atoi(getProperty("aluno.field.end.telAlternativo"));
	data = strSubString(value, inicio, fim);
	aln->telAlternativo = MEM_ALLOC_N(char, strlen(data));
	strcat(aln->telAlternativo, data);

	debug("Obtendo sexo do aluno");
	inicio = atoi(getProperty("aluno.field.start.sexo"));
	fim = atoi(getProperty("aluno.field.end.sexo"));
	data = strSubString(value, inicio, fim);
	aln->sexo = data[0];

	debug("Validando dominio para sexo");
	if (aln->sexo != SEXO_MASCULINO && aln->sexo != SEXO_FEMININO) {

		debug("Sexo nao confere. Registro invalido");
		return NULL;

	}

	debug("Obtendo curso do aluno");
	inicio = atoi(getProperty("aluno.field.start.curso"));
	fim = atoi(getProperty("aluno.field.end.curso"));
	data = strSubString(value, inicio, fim);

	debug("Verifica se o curso foi fornecido");
	if (isEmptyString(data)) {

		debug("Curso nao preenchido. Descartando registro.");
		return NULL;

	}

	debug("Verificando se o curso é numerico");
	if (!isNumeric(data)) {

		debug("Curso deveria ser numerico. Descartando registro");
		return NULL;
	}

	aln->curso = atoi(data);

	debug("Seta o aluno como ativo");
	aln->ativo = ENABLED_RECORD;
	aln->byteIndex = -1;

	return aln;
}

/**
 * Cria um arquivo apartir de um linha de tamanho variavel.
 *
 * @param line linha do arquivo variavel
 * @param index contador de posicao dos registros no arquivo, para indexacao.
 *
 */
Aluno newAlunoVariableLine(char *line, int *index) {

	int countRec = 1;
	int lineSize = strlen(line);

	debug("Obtem o token que separa os registros para arquivo variavel");
	char *token = getProperty("aluno.arquivo.variavel.token");

	debugs("Processando linha: ", line);
	char *registro = strtok(line, token);

	debug("Verificando se ra eh numerico");
	if (!isNumeric(registro)) {
		debug("RA do aluno deve ser numerico. Registro descartado.");
		return NULL;
	}

	debug("Obtem o ra");
	int ra_registro = atoi(registro);

	debug("Aloca memoria para o aluno");
	Aluno aluno = MEM_ALLOC(Aluno);

	char *tmp = NULL;
	char *curso = NULL;
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
			curso = strip(tmp);
			debug("Verifica se o curso foi fornecido");
			if (isEmptyString(curso)) {

				debug("Curso nao preenchido. Descartando registro.");
				return NULL;

			}

			debug("Verificando se o curso é numerico");
			if (!isNumeric(curso)) {

				debug("Curso deveria ser numerico. Descartando registro");
				return NULL;
			}
			aluno->curso = atoi(curso);
			break;
		case 8:
			tmp = strMerge(tmp, getProperty(
					"aluno.arquivo.variavel.fimregistro"), ESPACE);
			tmp = strip(tmp);
			aluno->ativo = tmp[0];

			if (aluno->ativo != ENABLED_RECORD && aluno->ativo
					!= DISABLED_RECORD) {
				debug("Inativando o registro por falta de dominio de valor");
				aluno->ativo = DISABLED_RECORD;
			}

			break;
		default:
			break;
		}

		registro = strtok(END_STR_TOKEN, token);
		countRec++;
	}

	debug("Verifica se o nome foi fornecido");
	if (isEmptyString(aluno->nome)) {

		debug("Nome nao preenchido. Descartando registro.");
		return NULL;

	}

	debug("Verifica se o telefone de contato foi fornecido");
	if (isEmptyString(aluno->telContato)) {

		debug("Telefone de contato nao preenchido. Descartando registro.");
		return NULL;

	}

	debug("Validando dominio para sexo");
	if (aluno->sexo != SEXO_MASCULINO && aluno->sexo != SEXO_FEMININO) {

		debug("Sexo nao confere. Registro invalido");
		return NULL;

	}

	debug("Seta a posicao do index do registro em relacao ao arquivo");
	aluno->byteIndex = *index;

	debug("Atualiza o index");
	*index += lineSize;

	return aluno;
}

/**
 * Obtem os dados de um aluno pelo RA.
 *
 */
Aluno findAlunoIndexByRa(int ra, char *indexFile, char *variableFile) {

	Aluno a = NULL;

	debug("Localiza o ra do aluno no index.");
	int index = indexByRa(ra, indexFile);

	debugi("Index: ", index);

	if (index != INDEX_NOT_FOUND_FOR_ALUNO) {

		debug("Abre o arquivo variavel para leitura");
		FILE *arq = Fopen(variableFile, "r");

		debug("Posiciona o arquivo no index");
		fseek(arq, index, SEEK_SET);

		char line[READ_BUFFER_SIZE];
		if (fgets(line, READ_BUFFER_SIZE, arq) != NULL) {
			a = newAlunoVariableLine(line, &index);

			if (a->ativo == DISABLED_RECORD) {
				debug("Aluno deletado");
				a = NULL;
			}
		}

		debug("Fechar o arquivo variavel");
		fclose(arq);

	}

	return a;
}

/**
 * Deleta um registro logicamente no arquivo variavel.
 *
 * @param ra - Ra do aluno a ser deletado.
 * @param indexFile - Nome do arquivo de indexes.
 * @param pIndex - Index do aluno a ser excluido, para facilitar a delecao.
 *
 */
int deleteAluno(int ra, char *indexFile, char *variableFile, int pIndex) {

	int result = -1;
	int index = -1;

	if (pIndex < 0) {
		debug("Localiza o ra do aluno no index.");
		index = indexByRa(ra, indexFile);
		debugi("Index do RA", index);
	} else {
		index = pIndex;
	}

	debugi("Index: ", index);

	if (index != INDEX_NOT_FOUND_FOR_ALUNO) {

		debug("Abre o arquivo variavel para leitura");
		FILE *arq = Fopen(variableFile, "r+");

		debug("Posiciona o arquivo no index");
		fseek(arq, index, SEEK_SET);

		char line[READ_BUFFER_SIZE];
		if (fgets(line, READ_BUFFER_SIZE, arq) != NULL) {
			fseek(arq, index, SEEK_SET);
			Aluno a = newAlunoVariableLine(line, &index);

			debug("Verifica se o registro esta ativo");
			if (a->ativo == ENABLED_RECORD) {
				a->ativo = DISABLED_RECORD;
				char *lnAluno = converAlunoToVariableLine(a, false);
				fprintf(arq, lnAluno);
				result = 0;
			}
		}

		debug("Fechar o arquivo variavel");
		fclose(arq);

	}

	debug("Aluno nao encontrado");
	return result;

}

/**
 * Realizar busca binaria no arquivo para localizar o ra do aluno desejado.
 */
int indexByRa(int ra, char *indexFile) {

	debug("Obtem o tamanho de cada registro do arquivo de index");
	int recSize = atoi(getProperty("aluno.index.file.record.size"));

	debug("Obtem o tamanho do arquivo de indexes");
	int pFim = fileSize(indexFile);
	int recordCount = pFim / recSize;
	pFim = pFim - recSize;

	debug("Abre o arquivo para leitura");
	FILE *arq = Fopen(indexFile, "r");

	debug("Variaveis de controle da busca binaria");
	int pInicio = 0, pMeio;
	int index = -1;
	int raInicio, raFim;

	int count = 0;
	debug("Localizando a chave no arquivo ");
	while (count <= recordCount) {

		debug("Posiciona o cursor no inicio do periodo");
		fseek(arq, pInicio, SEEK_SET);

		debug("Le a linha do inicio do periodo");
		raInicio = getRaLineIndex(arq, ra, &index);

		debug("Caso tenha localizado");
		if (index != -1) {
			break;
		}

		debug("Caso o Ra procurado seja menor que o Ra do inicio do periodo");
		if (pInicio == 0 && ra < raInicio) {
			break;
		}

		debug("Posiciona o curso no final do periodo");
		fseek(arq, pFim, SEEK_SET);

		debug("Le a linha do fim do periodo");
		raFim = getRaLineIndex(arq, ra, &index);

		debug("Caso tenha localizado");
		if (index != -1) {
			break;
		}

		debug("Caso o Ra procurado seja maior que o Ra do fim do periodo");
		if (pInicio == 0 && ra > raFim) {
			break;
		}

		debug("Verifica se o ra procurado esta no periodo no entre meio");
		pMeio = pInicio + ((pFim - pInicio) / 2);
		if (recordCount % 2 == 0) {

			pInicio += recSize;

		} else {

			debug("Posiciona o curso no meio do periodo");
			fseek(arq, pMeio, SEEK_SET);

			debug("Le a linha do meio do periodo");
			raInicio = getRaLineIndex(arq, ra, &index);

			debug("Caso tenha localizado");
			if (index != -1) {
				break;
			}

			debug("Caso o Ra esteje no periodo inferior");
			if (ra > raInicio) {
				pInicio = pMeio;
			} else {
				pFim = pMeio;
			}
		}

		count++;

	}

	debug("Fecha o arquivo de indexes");
	fclose(arq);

	debug("Retorna o index caso tenha encontrado o RA");
	if (index != -1) {
		return index;
	}

	debug("Arquivo nao encontrado");
	return INDEX_NOT_FOUND_FOR_ALUNO;
}

/**
 * Obtem o Ra na linha do arquivo de index
 */
int getRaLineIndex(FILE *arq, int ra, int *index) {

	*index = -1;
	char *split = NULL;
	char line[READ_BUFFER_SIZE];
	if (fgets(line, READ_BUFFER_SIZE, arq) == NULL) {

		debug("Linha nao retornada, possivel fim do arquivo");
		return -1;

	} else {

		debugs("Linha do index a ser processada: ", line);

		debug("Normaliza a linha");
		char *tmp_line = (char*) strip(strMerge(line, END_OF_LINE,
				STR_END_TOKEN));
		//char *tmp_line = strMerge(line, END_OF_LINE, STR_END_TOKEN);
		//char *tmp_line = strtok(line, END_OF_LINE);

		split = strtok(tmp_line, INDEX_ALUNO_RECORD_TOKEN);
		if (split) {

			debug("Obtem o ra da linha");
			int line_ra = atoi(split);

			debugi("Ra da linha: ", line_ra);

			debug("Verifica se eh o ra procurado");
			if (line_ra == ra) {

				debug("RA encontrado!");
				split = strtok(END_STR_TOKEN, INDEX_ALUNO_RECORD_TOKEN);
				if (split) {
					debugs("Index a ser retornado: ", split);
					*index = atoi(split);
				}
			}

			return line_ra;

		} else {
			debug("Linha inconsistente");
			return -1;
		}

	}
}

/**
 * Exibe os dados de um aluno.
 *
 */
void showAluno(Aluno aluno) {

	if (aluno != NULL && aluno->nome != NULL && aluno->ativo == ENABLED_RECORD) {
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

		if (aluno->byteIndex >= 0) {
			printf(getMessage("aluno.label.posicao"), "\t\t", aluno->byteIndex,
					"\n\n");
		}
	}

}

/**
 * Cria o arquivo de formato variavel.
 *
 * param inputFile - Nome do arquivo de entrada.
 * param outputFile - Nome do arquivo de saida.
 * param showAlunos - Flag para exibir o aluno processado
 * param showEstatisticas - Flag para exibir as estatisticas da importacao
 * param generateHtmlOutput - Flag para gerar consulta html.
 */
char *processarArquivoFormatoVariavel(char *inputFile, char *outputFile,
		boolean showAlunos, boolean showEstatisticas,
		boolean generateHtmlOutput) {

	debug(
			"Processando criacao do arquivo variavel e retornando estrutura de alunos");

	FILE *htmlFile = NULL;
	FILE *inFile = Fopen(inputFile, "r");
	FILE *outFile = Fopen(outputFile, "w");

	if (generateHtmlOutput) {
		debug("Escreve output de consulta em html");
		htmlFile = Fopen(ARQUIVO_CONSULTA_FIXO_HTML, "w");
		writeFileFormatoHTML_inicio(htmlFile);
	}

	debug("Contadores");
	int linhas = 0;
	int registrosValidos = 0;

	char line[READ_BUFFER_SIZE];

	debug("Processa o arquivo de tamanho fixo, criando a lista de alunos");
	Aluno aluno = NULL;
	while (fgets(line, READ_BUFFER_SIZE, inFile) != NULL) {

		debug("Incrementa contador de linhas do arquivo");
		linhas++;

		char *tmpLine = MEM_ALLOC_N(char, strlen(line));
		strcpy(tmpLine, line);

		debug("Criando um novo aluno apartir da linha de tamanho fixo");
		aluno = newAluno(tmpLine);

		if (aluno != NULL) {

			debug("Incrementa registros validos");
			registrosValidos++;

			debug("Grava o aluno no arquivo de tamanho variavel");
			writeFileFormatoVariavel(outFile, aluno);

			if (showAlunos) {
				showAluno(aluno);
			}

			if (generateHtmlOutput) {
				writeFileFormatoHTML(htmlFile, aluno);
			}

		}

	}

	if (generateHtmlOutput) {
		writeFileFormatoHTML_fim(htmlFile);
		fclose(htmlFile);
	}

	fclose(outFile);
	fclose(inFile);

	if (showEstatisticas) {
		printf(getMessage("aluno.label.processarArquivo.registrosLidos"),
				"\n\n\t", linhas, "\n");
		printf(getMessage("aluno.label.processarArquivo.registrosValidos"),
				"\t", registrosValidos, "\n");
		printf(getMessage("aluno.label.processarArquivo.tamanhoArqOriginal"),
				"\t", inputFile, fileSize(inputFile), "\n");
		printf(getMessage("aluno.label.processarArquivo.tamanhoArqConvertido"),
				"\t", outputFile, fileSize(outputFile), "\n\n");
	}

	if (generateHtmlOutput) {
		return ARQUIVO_CONSULTA_FIXO_HTML;
	}

	return NULL;

}

/**
 *
 */
void writeFileFormatoVariavel(FILE *file, Aluno aln) {

	if (file != NULL && aln != NULL && aln->nome != NULL) {
		aln->ativo = ENABLED_RECORD;
		fprintf(file, converAlunoToVariableLine(aln, true));
	}

}

/**
 * Converte um aluno para uma string variavel para escrever no arquivo.
 */
char *converAlunoToVariableLine(Aluno aln, boolean escape) {
	char line[READ_BUFFER_SIZE];

	char *separete = getProperty("aluno.arquivo.variavel.token");
	char *endLine = getProperty("aluno.arquivo.variavel.fimregistro");

	if (escape) {
		sprintf(line, "%i%s%s%s%s%s%s%s%s%s%c%s%i%s%c%s%s\n", aln->ra,
				separete, strip(aln->nome), separete, strip(aln->cidade),
				separete, strip(aln->telContato), separete, strip(
						aln->telAlternativo), separete, aln->sexo, separete,
				aln->curso, separete, aln->ativo, separete, endLine);
	} else {
		sprintf(line, "%i%s%s%s%s%s%s%s%s%s%c%s%i%s%c%s%s", aln->ra, separete,
				strip(aln->nome), separete, strip(aln->cidade), separete,
				strip(aln->telContato), separete, strip(aln->telAlternativo),
				separete, aln->sexo, separete, aln->curso, separete,
				aln->ativo, separete, endLine);
	}

	return strip(line);
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
 * Exibe os dados do arquivo de tamanho variavel.
 *
 * @param inputFile - Arquivo de tamanho variavel
 * @param exibirAluno - Caso seja necessario exibir os dados do aluno na tela.
 * @param generatedHtmlOutput - Caso seja necessario criar o arquivo de consulta html
 * @param arquivoFixo - Arquivo fixo para criacao do variavel caso esse nao exista.
 * @param nome do arquivo de consulta html.
 * @return arquivo de consulta HTML.
 *
 */
char *carregarAlunoArquivoVariavel(char *inputFile, boolean exibirAluno,
		boolean generateHtmlOutput, char *arquivoFixo) {

	FILE *htmlFile = NULL;

	debug("Verifica se o arquvo variavel existe");
	if (!fileExists(inputFile)) {
		processarArquivoFormatoVariavel(arquivoFixo, inputFile, false, false,
				false);
	}

	debug("Abre o arquivo de tamanho variavel para leitura");
	FILE *arq = Fopen(inputFile, "r");

	if (generateHtmlOutput) {
		debug("Escreve output de consulta em html");
		htmlFile = Fopen(ARQUIVO_CONSULTA_FIXO_HTML, "w");
		writeFileFormatoHTML_inicio(htmlFile);
	}

	debug("Variaveis de iteracao");
	int index = 0;
	Aluno aluno = NULL;
	char line[READ_BUFFER_SIZE];

	debug("Processa o arquivo de tamanho variavel.");
	while (fgets(line, READ_BUFFER_SIZE, arq) != NULL) {

		debug("Processa a linha referente ao aluno");
		aluno = newAlunoVariableLine(line, &index);

		if (exibirAluno) {
			showAluno(aluno);
		}

		if (generateHtmlOutput && aluno != NULL && aluno->ativo
				== ENABLED_RECORD) {
			writeFileFormatoHTML(htmlFile, aluno);
		}

	}

	fclose(arq);

	debug("Finaliza arquivo de consulta HTML");
	if (generateHtmlOutput) {
		writeFileFormatoHTML_fim(htmlFile);
		fclose(htmlFile);
		return ARQUIVO_CONSULTA_FIXO_HTML;
	}

	return NULL;

}

/**
 * Obtem um aluno no arquivo variavel.
 *
 * @param ra ra do aluno
 * @param fileName nome do arquivo variavel.
 * @param arquivoFixo nome do arquivo fixo, caso o variavel nao exista.
 *
 */
Aluno findAlunoByRaArquivoVariavel(int ra, char *fileName, char *arquivoFixo) {

	debug("Verifica se o arquivo variavel existe");
	if (!fileExists(fileName)) {
		processarArquivoFormatoVariavel(arquivoFixo, fileName, false, false,
				false);
	}

	debug("Abre o arquivo de tamanho variavel para leitura");
	FILE *arq = Fopen(fileName, "r");

	int index = 0;
	Aluno aluno = NULL;
	char line[READ_BUFFER_SIZE];
	while (fgets(line, READ_BUFFER_SIZE, arq) != NULL) {

		aluno = newAlunoVariableLine(line, &index);

		if (aluno != NULL && aluno->ra == ra) {
			debug("Aluno encontrado");
			break;
		}

	}

	fclose(arq);

	if (aluno->ativo == DISABLED_RECORD || aluno->ra != ra) {
		return NULL;
	}

	return aluno;

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
		int index = 0, lineSize = 0;
		while (fgets(line, READ_BUFFER_SIZE, arq) != NULL) {

			debug("Obtem o tamanho da linha");
			lineSize = strlen(line);

			debugs("Processando linha: ", line);
			char *registro = strtok(line, token);
			char *str_index = itoa(index);

			debugi("Index Processado: ", index);
			debugs("Index Convertido: ", str_index);

			debug("Escreve a linha do index");
			fprintf(indexFile, "%s%s%s\n", strConcanteStart(registro, "0", 10),
					INDEX_ALUNO_RECORD_TOKEN, strConcanteStart(str_index, "0",
							10));

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
 * Ordena uma arquivo de dados fixos de aluno, que supostamente não caiba em memoria.
 *
 * @param inFile - Nome do arquivo a ser ordenado.
 * @param outFile - Nome do arquivo de saida ordenado.
 * @param memory - Quantidade de memoria utilizada para o processo.
 * @param key - Chave pela qual o arquivo será ordenado.
 * @param showStatistics - Flag para exibicao de estatisticas de processamento na tela.
 * @param generateCsvStatistics - Flag para geracao de arquivo csv com as estatisticas do processaemnto.
 */
void sortArquivoFixo(char *inFile, char *outFile, int memory, char *key,
		boolean showStatistics, boolean generateCsvStatistics) {

	debug("Variaveis de controle de read and write");
	long readCount;
	long writeCount;
	long recordCount;
	long mergeCount;

	debug("Arquivo csv");
	FILE *csvFile = NULL;

	debug("Variaveis para contabilizar o tempo de execução do processo de run files");
	time_t inicioRunFiles, fimRunFiles;

	debug("Seta o timer de inicio");
	time(&inicioRunFiles);

	debug("Criando a lista de run files");
	LIST runFileList = createRunFiles(inFile, memory, key, &readCount,
			&writeCount, &recordCount);

	debug("Seta o timer de fim do processo de run files");
	time(&fimRunFiles);

	debug("Caso seja necessario gravar estatistica do processamento");
	if (showStatistics || generateCsvStatistics) {

		debug("Exibe os dados de processamento dos run files");
		if (showStatistics) {

			printf(getMessage("aluno.quantidadeLeituraExecutadas"), getMessage(
					"aluno.processoRunFile"), readCount, END_OF_LINE);
			printf(getMessage("aluno.quantidadeEscritaExecutadas"), getMessage(
					"aluno.processoRunFile"), writeCount, END_OF_LINE);
			printf(getMessage("aluno.quatidadeRunFiles"), runFileList->count,
					END_OF_LINE);
			printf(getMessage("aluno.quantidadeRegistroProcessados"),
					recordCount, END_OF_LINE);
			printf(getMessage("aluno.tempoExecucaoProcesso"), getMessage(
					"aluno.processoRunFile"), (int) (1000 * difftime(
					fimRunFiles, inicioRunFiles)), END_OF_LINE);

		}

		debug("Grava os dados no arquivo de estatisticas de processamento");
		if (generateCsvStatistics) {

			debug("Cria o arquivo de csv");
			csvFile = Fopen(generateStatisticSortFileName(), WRITE_FLAG);

			fprintf(csvFile,
					getMessage("aluno.csv.quantidadeLeituraExecutadas"),
					getMessage("aluno.processoRunFile"), readCount, END_OF_LINE);
			fprintf(csvFile,
					getMessage("aluno.csv.quantidadeEscritaExecutadas"),
					getMessage("aluno.processoRunFile"), writeCount,
					END_OF_LINE);
			fprintf(csvFile, getMessage("aluno.csv.quatidadeRunFiles"),
					runFileList->count, END_OF_LINE);
			fprintf(csvFile, getMessage(
					"aluno.csv.quantidadeRegistroProcessados"), recordCount,
					END_OF_LINE);
			fprintf(csvFile, getMessage("aluno.csv.tempoExecucaoProcesso"),
					getMessage("aluno.processoRunFile"), (int) (1000
							* difftime(fimRunFiles, inicioRunFiles)),
					END_OF_LINE);

		}
	}

	debug("Limpa os registros dos contadores");
	readCount = 0;
	writeCount = 0;

	debug("Seta o timer de inicio");
	time(&inicioRunFiles);
	debug("Executando merge dos run files");
	char *indexFile = generatedIndexFileByRunFiles(runFileList, &mergeCount,
			&readCount, &writeCount);

	debugs("Index file: ", indexFile);

	debug("Ordenando o arquivo principal apartir do arquivo de index gerado");
	sortFinalFile(indexFile, outFile, inFile, &readCount, &writeCount);

	debug("Seta o timer de fim");
	time(&fimRunFiles);

	debug("Caso seja necessario gravar estatistica do processamento");
	if (showStatistics || generateCsvStatistics) {

		debug("Exibe os dados de processamento dos run files");
		if (showStatistics) {

			printf(getMessage("aluno.quantidadeLeituraExecutadas"), getMessage(
					"aluno.processoMerge"), readCount, END_OF_LINE);
			printf(getMessage("aluno.quantidadeEscritaExecutadas"), getMessage(
					"aluno.processoMerge"), writeCount, END_OF_LINE);
			printf(getMessage("aluno.quantidadeFasesMerge"), mergeCount,
					END_OF_LINE);
			printf(getMessage("aluno.tempoExecucaoProcesso"), getMessage(
					"aluno.processoMerge"), (int) (1000 * difftime(fimRunFiles,
					inicioRunFiles)), END_OF_LINE);

		}

		debug("Grava os dados no arquivo de estatisticas de processamento");
		if (generateCsvStatistics) {

			fprintf(csvFile,
					getMessage("aluno.csv.quantidadeLeituraExecutadas"),
					getMessage("aluno.processoMerge"), readCount, END_OF_LINE);
			fprintf(csvFile,
					getMessage("aluno.csv.quantidadeEscritaExecutadas"),
					getMessage("aluno.processoMerge"), writeCount, END_OF_LINE);
			fprintf(csvFile, getMessage("aluno.csv.quantidadeFasesMerge"),
					mergeCount, END_OF_LINE);
			fprintf(csvFile, getMessage("aluno.csv.tempoExecucaoProcesso"),
					getMessage("aluno.processoMerge"), (int) (1000 * difftime(
							fimRunFiles, inicioRunFiles)), END_OF_LINE);

		}
	}

	debug("Verificando se o arquivo de csv deve ser fechado");
	if (generateCsvStatistics && csvFile != NULL) {

		debug("Fechando arquivo de estatistica");
		fclose(csvFile);

	}

	freeList(runFileList, nop);
	free(runFileList);

}

/**
 * Executa o merge dos arquivos de run, retornando um arquivo de index.
 *
 * @param runFileList - Lista com os arquivos de run
 * @param mergeCount - Contador de fases de merge
 * @param readCount - Contador de read
 * @param writeCount - Contador de write.
 * @return nome do arquivo de index.
 *
 */
char *generatedIndexFileByRunFiles(LIST runFileList, long *mergeCount,
		long *readCount, long *writeCount) {

	debug("Verifica se existem run files processados");
	if (runFileList == NULL || runFileList->count == 0) {
		return NULL;
	}

	debug("Verifica se a lista de run files contem apenas um arquivo");
	if (runFileList->count == 1) {

		debug("Retornando unico run file processado");
		return (char *) getElement(runFileList, 0);

	}

	debug("Variaveis para controle de merge");
	int index = 0;
	char *f1 = NULL;
	char *f2 = NULL;
	char *f3 = NULL;
	char *f4 = NULL;
	char *f5 = NULL;

	debug("Variaveis de estatistica");
	long rdCount = 0;
	long wrCount = 0;
	long mgCount = 0;

	while (runFileList->count > 1) {

		debug("Prepara a proxima iteracao na lista de arquivos");
		index = 1;
		f1 = NULL;
		f2 = NULL;
		f3 = NULL;
		f4 = NULL;
		f5 = NULL;

		debug("Obtem os proximos arquivos na lista a sofrerem merge");
		while (runFileList->count > 0 && index <= 5) {

			if (index == 1) {
				f1 = removeFirst(runFileList);
			} else if (index == 2) {
				f2 = removeFirst(runFileList);
			} else if (index == 3) {
				f3 = removeFirst(runFileList);
			} else if (index == 4) {
				f4 = removeFirst(runFileList);
			} else if (index == 5) {
				f5 = removeFirst(runFileList);
			}

			index++;

		}

		debug("Executando o merge entre os arquivos");
		char *currentSortFile = sortRunFiles(f1, f2, f3, f4, f5, &rdCount,
				&wrCount);

		debug("Inserindo o arquivo de merge na lista a ser processado");
		frontInsert(runFileList, currentSortFile);

		debugl("Incrementa o contador de merge", mgCount);
		mgCount++;

	}

	debug("Seta as variaveis de estaticas de retorno");
	*readCount = rdCount;
	*writeCount = wrCount;
	*mergeCount = mgCount;

	debug("Retorna o arquivo ordenado");
	return (char *) removeFirst(runFileList);

}

/**
 * Executa o merge sorte de ate 5 run files.
 * @param f1..f5 Arquivos de run a serem processados merge.
 * @param sizeList - Tamanho da lista de runFiles.
 * @param readCount - Contador de leitura.
 * @param writeCount - Contador de escrita.
 * @return nome do arquivo com o merge.
 */
char *sortRunFiles(char *f1, char *f2, char *f3, char *f4, char *f5,
		long *readCount, long *writeCount) {

	debug("Verificando se ao menos um arquivo foi informado");
	if (f1 == NULL && f2 == NULL && f3 == NULL && f4 == NULL && f5 == NULL) {

		debug("Nenhum arquivo informado para fazer merge");

		return NULL;
	}

	debug("Variaveis contadores de estatistica");
	long rdCount = *readCount;
	long wrCount = *writeCount;

	debug("Estruturas de arquivo para sort");
	FILE *file1 = NULL;
	FILE *file2 = NULL;
	FILE *file3 = NULL;
	FILE *file4 = NULL;
	FILE *file5 = NULL;

	debug("Gerando o nome do arquivos de merge");
	char *mergeFileName = generateRunFileName(genRand());

	debugs("Abrindo o arquivo de saida", mergeFileName);
	FILE *outputFile = Fopen(mergeFileName, WRITE_FLAG);

	debug("Linhas de merge de cada arquivo");
	char l1[READ_BUFFER_SIZE];
	char l2[READ_BUFFER_SIZE];
	char l3[READ_BUFFER_SIZE];
	char l4[READ_BUFFER_SIZE];
	char l5[READ_BUFFER_SIZE];

	debugs("Verificando arquivo 1", f1);
	if (!isStrEmpty(f1) && fileExists(f1)) {
		file1 = Fopen(f1, READ_FLAG);

		debug("Lendo a primeira linha do arquivo 1");
		fgets(l1, READ_BUFFER_SIZE, file1);
		rdCount++;
	}

	debugs("Verificando arquivo 2", f2);
	if (!isStrEmpty(f2) && fileExists(f2)) {
		file2 = Fopen(f2, READ_FLAG);

		debug("Lendo a primeira linha do arquivo 2");
		fgets(l2, READ_BUFFER_SIZE, file2);
		rdCount++;
	}

	debugs("Verificando arquivo 3", f3);
	if (!isStrEmpty(f3) && fileExists(f3)) {
		file3 = Fopen(f3, READ_FLAG);

		debug("Lendo a primeira linha do arquivo 3");
		fgets(l3, READ_BUFFER_SIZE, file3);
		rdCount++;
	}

	debugs("Verificando arquivo 4", f4);
	if (!isStrEmpty(f4) && fileExists(f4)) {
		file4 = Fopen(f4, READ_FLAG);

		debug("Lendo a primeira linha do arquivo 4");
		fgets(l4, READ_BUFFER_SIZE, file4);
		rdCount++;
	}

	debugs("Verificando arquivo 5", f5);
	if (!isStrEmpty(f5) && fileExists(f5)) {
		file5 = Fopen(f5, READ_FLAG);

		debug("Lendo a primeira linha do arquivo 5");
		fgets(l5, READ_BUFFER_SIZE, file5);
		rdCount++;
	}

	char *menorLinha = NULL;

	debug("Processa o merge entre os arquivos");
	while (file1 != NULL || file2 != NULL || file3 != NULL || file4 != NULL
			|| file5 != NULL) {

		debug("Obtendo a menor linha entre os arquivos a serem processados");
		menorLinha = lessLine(l1, l2, l3, l4, l5);

		if (menorLinha == NULL) {

			debug("Menor linha vazia");

		} else {
			debugs("Escrevendo a menor linha no arquivo de saida:", menorLinha);
			fprintf(outputFile, "%s", menorLinha);
			wrCount++;
		}

		debug("Verificando se a menor linha pertence ao arquivo 1");
		if (file1 != NULL && strcmp(l1, menorLinha) == 0) {

			rdCount++;
			debug("Lendo a proxima linha do arquivo 1");
			if (fgets(l1, READ_BUFFER_SIZE, file1) == NULL) {
				clearString(l1);
				debug("Arquivo 1 chegou ao fim");
				fclose(file1);
				file1 = NULL;

				debug("Remove arquivo 1");
				remove(f1);
			}

			menorLinha = NULL;
			continue;

		}

		debug("Verificando se a menor linha pertence ao arquivo 2");
		if (file2 != NULL && strcmp(l2, menorLinha) == 0) {

			rdCount++;
			debug("Lendo a proxima linha do arquivo 2");
			if (fgets(l2, READ_BUFFER_SIZE, file2) == NULL) {
				clearString(l2);
				debug("Arquivo 2 chegou ao fim");
				fclose(file2);
				file2 = NULL;

				debug("Remove arquivo 2");
				remove(f2);
			}

			menorLinha = NULL;
			continue;
		}

		debug("Verificando se a menor linha pertence ao arquivo 3");
		if (file3 != NULL && strcmp(l3, menorLinha) == 0) {

			rdCount++;
			debug("Lendo a proxima linha do arquivo 3");
			if (fgets(l3, READ_BUFFER_SIZE, file3) == NULL) {
				clearString(l3);
				debug("Arquivo 3 chegou ao fim");
				fclose(file3);
				file3 = NULL;

				debug("Remove arquivo 3");
				remove(f3);
			}

			menorLinha = NULL;
			continue;
		}

		debug("Verificando se a menor linha pertence ao arquivo 4");
		if (file4 != NULL && strcmp(l4, menorLinha) == 0) {

			rdCount++;
			debug("Lendo a proxima linha do arquivo 4");
			if (fgets(l4, READ_BUFFER_SIZE, file4) == NULL) {
				clearString(l4);
				debug("Arquivo 4 chegou ao fim");
				fclose(file4);
				file4 = NULL;

				debug("Remove arquivo 4");
				remove(f4);
			}

			menorLinha = NULL;
			continue;
		}

		debug("Verificando se a menor linha pertence ao arquivo 5");
		if (file5 != NULL && strcmp(l5, menorLinha) == 0) {

			rdCount++;
			debug("Lendo a proxima linha do arquivo 1");
			if (fgets(l5, READ_BUFFER_SIZE, file5) == NULL) {
				clearString(l5);
				debug("Arquivo 5 chegou ao fim");
				fclose(file5);
				file5 = NULL;

				debug("Remove arquivo 5");
				remove(f5);
			}

			menorLinha = NULL;
			continue;
		}
	}

	debug("Fechando o arquivo de merge");
	fclose(outputFile);

	debug("Seta as variaveis de estatistica de retorno");
	*readCount = rdCount;
	*writeCount = wrCount;

	return mergeFileName;

}

/**
 * Obtem a menor linha do arquivo.
 */
char *lessLine(char *l1, char *l2, char *l3, char *l4, char *l5) {

	debug("Verifica se alguma linha foi informada");
	if (l1 == NULL && l2 == NULL && l3 == NULL && l4 == NULL && l5 == NULL) {
		debug("Todas as linhas vazias");
		return NULL;
	}

	debug("Cria a lista de sort");
	LIST lst = newList();

	debugs("Colocando a linha 1 na lista", l1);
	if (!isStrEmpty(l1)) {
		rearInsert(lst, l1);
	}

	debugs("Colocando a linha 2 na lista", l2);
	if (!isStrEmpty(l2)) {
		rearInsert(lst, l2);
	}

	debugs("Colocando a linha 3 na lista", l3);
	if (!isStrEmpty(l3)) {
		rearInsert(lst, l3);
	}

	debugs("Colocando a linha 4 na lista", l4);
	if (!isStrEmpty(l4)) {
		rearInsert(lst, l4);
	}

	debugs("Colocando a linha 5 na lista", l5);
	if (!isStrEmpty(l5)) {
		rearInsert(lst, l5);
	}

	debug("Variavel para armazenar o resultado");
	char *result;
	char *tmp;

	debug("Caso a lista contenha mais que uma linha, processa a menor linha");
	if (lst->count > 1) {

		debug("Obtem o primeiro elemento da lista");
		result = removeFirst(lst);

		while (lst->count != 0) {

			debug("Removendo o proximo elemento da lista");
			tmp = removeFirst(lst);

			debug("Comparando as linhas:");
			debugs("Linha1: ", result);
			debugs("Linha2: ", tmp);
			if (strcmp(result, tmp) >= 0) {

				debug("Linha 2 menor que linha 1, trocando as posicoes");
				result = tmp;

			}

		}

	} else {

		debug("Como a lista contem apenas uma linha, retorna a mesma");
		result = getElement(lst, 0);

		debug("Libera a lista de sort");
		//freeList(lst, nop);
		//free(lst);

		debugs("Menor linha:", result);

		return result;

	}

	debug("Libera a lista de sort");
	//freeList(lst, nop);
	//free(lst);

	debugs("Menor linha:", result);
	return result;

}

/**
 * Gera o nome do arquivo csv para estatistica de sort.
 */
char *generateStatisticSortFileName() {

	char dateTime[100];
	sprintf(dateTime, "%s-%s", __DATE__, __TIME__);

	return str_join(dateTime, STATISTICS_CSV_FILE);

}

/**
 * Cria os arquivos de merge (run files), ordenados apartir de uma chave.
 *
 * @param inFile - Arquivo de entrada a ser ordenados
 * @para memory - Quantidade de memoria limite utilizada pelo processo.
 * @param key - Chave a ser utilizada para ordenar o arquivo.
 * @param rdCount - Apontador para countador de read.
 * @param wrCount - Apontador para contador de write.
 * @param recordCount - Contador de registros processados.
 * @return lista de arquivos runs criados durante o processo.
 */
LIST createRunFiles(char *inFile, int memory, char *key, long *rdCount,
		long *wrCount, long *recordCount) {

	debug("Deleta todos os run files do diretorio");
	deleteRunFiles();

	debug("Abre o arquivo de dados para leitura");
	FILE *alunosFile = Fopen(inFile, "r");

	debug("Cria a lista de retorno para armazenar os run files");
	LIST runFileList = newList();

	debug("Variaveis de controle do processo");
	long readCount = 0;
	long writeCount = 0;
	long writeCountTemp = 0;
	int runFileCount = 1;
	int memoryCount = 0;
	long memoryFullCount = 0;
	char *buffer;
	char line[READ_BUFFER_SIZE];
	FILE *runFile = NULL;
	char *runFileName = NULL;

	debug("Obtendo o tamanho em bytes para um registro no arquivo de tamanho fixo");
	int recordSize = atoi(getProperty("aluno.field.end.fimregistro")) + 1;

	debug("Lista para armazenar as runs para fazer sort em memoria");
	LIST sortListRun = newList();

	debug("Le o arquivo de dados");
	while (fgets(line, READ_BUFFER_SIZE, alunosFile) != NULL) {

		debug("Verifica se a linha do arquivo principal esta vazia");
		if (isStrEmpty(line)) {

			debugi("Linha vazia. Posicao: ", memoryFullCount);

		} else {

			debug("Grava a chave na run");
			buffer = MEM_ALLOC_N(char, READ_BUFFER_SIZE);
			stripWhiteSpace(buffer);

			debug("Obtem a chave e a posicao no arquivo de dados.");
			sprintf(buffer, "%s%s%d", getKeyLine(line, key),
					INDEX_ALUNO_RECORD_TOKEN, memoryFullCount);

			debugs("Insere a run na lista de sorted: ", buffer);
			rearInsert(sortListRun, buffer);

			debug("Incrementa a quantidade de memoria utilizada.");
			memoryCount += recordSize;
			memoryFullCount += recordSize;

			debugi("Memoria utilizada: ", memoryCount);

			debug("Verificando se existe memoria de manipulacao disponivel");
			if ((memoryCount + recordSize) > memory) {

				debug("Memoria de leitura preenchida. Fechando a run.");

				debug("Incrementa o contador de run files");
				runFileName = generateRunFileName(runFileCount);
				debugs("Gerando o nome para o arquivo de run", runFileName);
				runFileCount++;

				debug("Insere o nome do arquivo run na lista de retorno");
				rearInsert(runFileList, runFileName);

				debug("Criando o run file");
				runFile = Fopen(RUN_FILE_TMP, WRITE_FLAG);

				debug("Escre os dados na run");
				writeRunFile(sortListRun, runFile, &writeCountTemp);
				writeCount += writeCountTemp;

				debug("Libera a lista de ordenacao da memoria");
				freeList(sortListRun, nop);

				debug("Fechando o run file");
				fclose(runFile);

				debug("Ordena o arquivo de run");
				sortFile(RUN_FILE_TMP, runFileName);

				debug("Libera contador de memoria");
				memoryCount = 0;

			}

			readCount++;
			debugl("Incrementa o contador de reads. Contador atual: ", readCount);
		}

	}

	debug("Cria o ultimo run file");
	if (sortListRun->count > 0) {

		debug("Incrementa o contador de run files");
		runFileName = generateRunFileName(runFileCount);
		debugs("Gerando o nome para o arquivo de run", runFileName);
		runFileCount++;

		debug("Insere o nome do arquivo run na lista de retorno");
		rearInsert(runFileList, runFileName);

		debug("Criando o run file");
		runFile = Fopen(RUN_FILE_TMP, WRITE_FLAG);

		debug("Escre os dados na run");
		writeRunFile(sortListRun, runFile, &writeCountTemp);
		writeCount += writeCountTemp;

		debug("Libera a lista de ordenacao da memoria");
		freeList(sortListRun, nop);

		debug("Fechando o run file");
		fclose(runFile);

		debug("Ordena o arquivo de run");
		sortFile(RUN_FILE_TMP, runFileName);

		debug("Libera contador de memoria");
		memoryCount = 0;
	}

	debug("Seta as variaveis de retorno");
	*rdCount = readCount;
	*wrCount = writeCount;
	*recordCount = readCount;

	debug("Finalizando o processo e retornando a lista de runFiles");
	return runFileList;

}

/**
 * Escreve os dados no run file.
 * @param dados - lista de dados ordenados a ser gravado na run.
 * @param runFile - Arquivo de run.
 * @param writeCount - Contador de write.
 */
void writeRunFile(LIST dados, FILE *runFile, long *writeCount) {

	debug("Escrevendo a lista de runs no arquivo de run");
	debugi("Tamanho da lista de dados: ", dados->count);

	debug("Contador de write");
	long wrCount = 0;

	if (dados == NULL || dados->count == 0) {
		debug("Nao existem dados na lista");
	} else {

		debug("Obtem o primeiro elemento da lista");
		nodeptr no = dados->content;

		debug("Itera na lista de dados para escrever na run");
		int count = 1;
		while (no != NULL && count <= dados->count) {
			fprintf(runFile, "%s\n", no->value);
			debug("Incrementando contador de write");
			wrCount++;
			debugl("Contador de write: ", wrCount);
			no = no->next;
			count++;
		}

		debug("Arquivo de run completa");
	}

	debug("Retornando contador de write");
	*writeCount = wrCount;

}

/**
 * Gera o nome para o run file
 * @param count - Contador de run.
 * @return retorna o nome do arquivo de run.
 */
char *generateRunFileName(int count) {

	debugi("Gerando run file name: ", count);
	return str_join(RUN_FILE, str_join(itoa(count), EXTENSAO_RUN_FILE));

}

/**
 * Obtem a chave da linha do arquivo de tamanho fixo.
 *
 * @param line - Linha do arquivo
 * @param key - Chave de ordenacao.
 * @return chave da linha.
 */
char *getKeyLine(char *line, char *key) {

	int pInicial = 0;
	int pFim = 0;

	debugs("Verificando qual a chave de ordenacao do arquivo fixo: ", key);
	if (strcmp(strUpperCase(key), KEY_NOME) == 0) {

		debug("Obtendo chave para NOME");

		debug("Obtendo a posicao da chave no arquivo fixo");
		pInicial = atoi(getProperty("aluno.field.start.nome"));
		pFim = atoi(getProperty("aluno.field.end.nome"));

		return strSubString(line, pInicial, pFim);

	} else {

		debug("Obtendo chave para RA");
		pInicial = atoi(getProperty("aluno.field.start.ra"));
		pFim = atoi(getProperty("aluno.field.end.ra"));

		return strSubString(line, pInicial, pFim);
	}

}

/**
 * Remove todos os arquivos de run processados anteriormente.
 */
void deleteRunFiles() {

	debug("Caso exista o primeiro run file, deleta todos.");
	if (fileExists(generateRunFileName(1))) {
		debug("Deletando run files...");
		system(str_join("rm *", str_join(EXTENSAO_RUN_FILE, " &")));
		debug("Run files deletados");
	}

}

/**
 * Ordena o um arquivo de aluno de tamanho fixo se baseando em um arquivo de indexes.
 *
 * @param inFile - arquivo de index.
 * @param outFile - arquivo de saida com os dados ordenados.
 * @param dataFile - arquivo original com os dados a serem ordenados.
 * @param readCount - Contador de leitura
 * @param writeCount - Contador de escrita
 * @return true caso o processo tenha executado com sucesso.
 */
boolean sortFinalFile(char *inFile, char *outFile, char *dataFile,
		long *readCount, long *writeCount) {

	long rdCount = *readCount;
	long wrCount = *writeCount;

	debug("Verificando se o arquivo de indices existe");
	if (!fileExists(inFile)) {
		debug("Arquivo de indices nao existe");
		return false;
	}

	debug("Verificando se o arquivo de dados existe");
	if (!fileExists(dataFile)) {
		debug("Arquivo de dados nao existe");
		return false;
	}

	int index = -1;

	debug("Abrindo o arquivo de indices para leitura");
	FILE *finFile = Fopen(inFile, READ_FLAG);

	debug("Abrindo o arquivo de saida para escrita");
	FILE *foutFile = Fopen(outFile, WRITE_FLAG);

	debug("Abrindo o arquivo de dados para leitura");
	FILE *fdataFile = Fopen(dataFile, READ_FLAG);

	char line[READ_BUFFER_SIZE];
	char lineDados[READ_BUFFER_SIZE];

	debug("Le arquivo de indices linha a linha");
	while (fgets(line, READ_BUFFER_SIZE, finFile) != NULL) {

		debugl("Incrementa contador de leitura", rdCount);
		rdCount++;

		index = getIndiceByLine(line);

		debug("Ve se a linha existe");
		if (index == ERROR_EXECUTION) {

			debugs("linha invalida", line);

		} else {

			debug("Posicionando cursor no arquivo de dados");
			fseek(fdataFile, index, SEEK_SET);

			debug("Pega a linha no fdataFile e poe em line");
			fgets(lineDados, READ_BUFFER_SIZE, fdataFile);

			debug("Escreve o arquivo em foutFile");
			fprintf(foutFile, lineDados);

			debugl("Incrementa o contador de escrita", wrCount);
			wrCount++;

		}
	}

	debug("Atualiza os contadores de retorno");
	*readCount = rdCount;
	*writeCount = wrCount;

	return true;

}

/**
 * Obtem o index da linha do arquivo de index.
 *
 * @param line - Linha que contem chave e index.
 * @return index da linha.
 */
int getIndiceByLine(char *line) {

	if (isStrEmpty(line)) {
		return ERROR_EXECUTION;
	}

	debug("Poe a primeira chamada do strtok numa variavel temp");
	char *temp = strtok(line, INDEX_ALUNO_RECORD_TOKEN);

	debug("Se temp não existe ele retorna -1");
	if (temp == NULL) {
		return ERROR_EXECUTION;
	}

	debug("Obtem o index de fato");
	temp = strtok(END_STR_TOKEN, INDEX_ALUNO_RECORD_TOKEN);
	temp = strMerge(temp, END_OF_LINE, STR_END_TOKEN);

	debugs("Retorna o indice", temp);
	return atoi(temp);

}

/**
 * Carrega a arvore de index.
 *
 * @param inFile - Arquivo de entrada de dados.
 * @param indexFile - Nome do arquivo de index da b-tree.
 * @param duplicateFile - Arquivo para armazenar as chaves duplicadas durante o processamento da b-tree.
 * @param treeOrder - Ordem da b-tree.
 * @param newIndex - Flag para recriar o arquivo de index da b-tree.
 */
int loadBTreeIndex(char *inFile, char *indexFile, char *duplicateFile,
		int treeOrder, boolean newIndex) {

	debug("Verifica se o arquivo de entrada existe");
	if (fileExists(inFile)) {

		debug("Variaveis utilizadas para carregar a b-tree");
		boolean promoted; /* boolean: tells if a promotion from below */
		short root, /* rrn of root page                        */
		promo_rrn; /* rrn promoted from below                  */
		TAlunoNode promo_key, /* key promoted from below       */
		key; /* next key to insert in tree                	   */

		debug("Zera o apontador para a chave a ser promovida");
		promo_key.ra = -1;
		promo_key.index = -1;

		debug("Verificando se o index deve ser recriado.");
		if (newIndex && fileExists(indexFile)) {
			debug("Deletando o arquivo com o index que foi carregado anteriormente");
			remove(indexFile);
		}

		debug("Seta o nome de index da b-tree");
		setBtreeIndexFileName(indexFile);

		debug("Seta o nome do arquivo para registros duplicados na b-tree");
		setBTreeDuplicateFileName(duplicateFile);

		debug("Setando a ordem da arvore.");
		setOrderTree(treeOrder);

		debug("Variaveis utilizadas no processo");
		char line[READ_BUFFER_SIZE];
		long memoryFullCount = 0;

		debug("Obtendo o tamanho em bytes para um registro no arquivo de tamanho fixo");
		int recordSize = atoi(getProperty("aluno.field.end.fimregistro")) + 1;

		debug("Abre o arquivo de dados para leitura");
		FILE *alunosFile = Fopen(inFile, READ_FLAG);

		debug("Tenta abrir o arquivo de index da b-tree");
		if (btopen()) {

			root = getroot();

		} else {

			debug("Lendo a primeira linha para montar a raiz da arvore");
			if (fgets(line, READ_BUFFER_SIZE, alunosFile) != NULL) {

				debug("Aloca node para arvore");
				TAlunoNode node;
				node.ra = atoi(getKeyLine(line, KEY_RA));
				node.index = memoryFullCount;

				debugi("Inserindo RA: ", node.ra);
				debugi("Index: ", node.index);

				debug("Caso nao exista o arquivo cria a arvore");
				root = create_tree(node);

				debug("Incrementa a quantidade de memoria utilizada.");
				memoryFullCount += recordSize;

			} else {

				debug("Nao foi possivel ler o arquivo de dados");
				fclose(alunosFile);
				return false;
			}
		}

		// TODO: remove me
		BTPAGE pg;
		btread(0, &pg);

		debug("Le o arquivo de dados");
		while (fgets(line, READ_BUFFER_SIZE, alunosFile) != NULL) {

			debug("Verifica se a linha do arquivo principal esta vazia");
			if (isStrEmpty(line)) {

				debugi("Linha vazia. Posicao: ", memoryFullCount);

			} else {

				debug("Obtem a chave e a posicao no arquivo de dados.");
				TAlunoNode key;
				key.ra = atoi(getKeyLine(line, KEY_RA));
				key.index = memoryFullCount;

				debugi("Inserindo RA: ", key.ra);
				debugi("Index: ", key.index);

				promoted = insert(root, key, &promo_rrn,
						&promo_key);
				if (promoted) {
					root = create_root(promo_key, root, promo_rrn);
				}

				debug("Incrementa a quantidade de memoria utilizada.");
				memoryFullCount += recordSize;

				debugi("Memoria utilizada: ", memoryFullCount);

			}

		}

		debug("Fecha o arquivo de dados");
		fclose(alunosFile);

		debug("Fecha a b-tree");
		btclose();

		return true;

	}

	debug("Arquivo inexistente retona erro no processamento");
	return false;

}

void findAlunoByRaBTree(int ra) {

}
