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
