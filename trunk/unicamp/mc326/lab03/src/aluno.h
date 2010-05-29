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
#include "mylist.h"

// Macro para retornar descricao do sexo
#define SEXO(a) (a == 'M' ? getMessage("aluno.label.sexo.masculino") : getMessage("aluno.label.sexo.feminino"))

// Flag para registro nao encontrado
#define INDEX_NOT_FOUND_FOR_ALUNO -1

// Arquivo html temporario para consulta de aluno via browser
#define ARQUIVO_CONSULTA_FIXO_HTML "arquivo_consulta_fixo.html"
#define cabecalho "<HTML><HEAD><TITLE>Cadastro de Alunos da Unicamp.</TITLE></HEAD><body></body><table style='border: 1px solid black;'>"
#define FIM_HTML "</table></body></html>"

// Flags de dominio para sexo
#define SEXO_MASCULINO 'M'
#define SEXO_FEMININO 'F'

// Flags de controle pra exclusao de registro
#define ENABLED_RECORD 'E'
#define DISABLED_RECORD 'D'

#define INDEX_ALUNO_RECORD_TOKEN "="
#define INDEX_ALUNO_FILE "index_aluno.txt"
#define INDEX_ALUNO_FILE_SORTED "index_aluno.txt.sorted"

// Nome do arquivo de estatistica csv
#define STATISTICS_CSV_FILE "_statistic_sort.csv"

// Dados de run file
#define RUN_FILE_TMP "runfile.tmp"
#define RUN_FILE "runfile_"
#define EXTENSAO_RUN_FILE ".run"

// Chaves de ordenacao do arquivo de tamanho fixo
#define KEY_NOME "NOME"
#define KEY_RA "RA"

/** Apontador para Aluno */
typedef struct AlunoStr* Aluno;

/**Struct para guardar os dados do aluno */
typedef struct AlunoStr {
	// Ra do aluno
	int ra;

	// Nome do aluno
	char *nome;

	// Cidade do aluno
	char *cidade;

	// Telefone de contato do aluno
	char *telContato;

	// Telefone alternativo
	char *telAlternativo;

	// Sexo do aluno
	char sexo;

	// Codigo do curso na unicamp
	int curso;

	// Indica se o registro esta ativo ou deletado
	char ativo;

	// Posição em byte do aluno no arquivo variavel
	int byteIndex;

} AlunoStr;

/**
 * Obtem os dados de um aluno pelo RA.
 *
 */
Aluno findAlunoIndexByRa(int ra, char *indexFile, char *variableFile);

/**
 * Exibe os dados de um aluno.
 *
 */
void showAluno(Aluno aluno);

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
		boolean generateHtmlOutput);

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
		boolean generateHtmlOutput, char *arquivoFixo);

/**
 * Cria o arquivo de formato variavel.
 */
void writeFileFormatoVariavel(FILE *file, Aluno aln);

/** Guarda dados do aluno em struct */
Aluno newAluno(char *value);

/**
 * Cria um arquivo apartir de um linha de tamanho variavel.
 *
 * @param line linha do arquivo variavel
 * @param index contador de posicao dos registros no arquivo, para indexacao.
 *
 */
Aluno newAlunoVariableLine(char *line, int *index);

/**
 * Exibe as informacoes do arquivo de tamanho variavel.
 *
 * param arqVariavel nome do arquivo variavel
 * param alunos estrutura de alunos processados
 */
void showInformacoesArquivoVariavel(char *arqVariavel);

/**
 * Escreve o aluno no html de consulta.
 */
void writeFileFormatoHTML(FILE *file, Aluno aln);

void writeFileFormatoHTML_inicio(FILE *file);

void writeFileFormatoHTML_fim(FILE *file);

/**
 * Monta o arquivo com as chaves para indexar o arquivo de tamanho variavel.
 *
 */
void extractFileKey(char *inputFile);

/**
 * Ordena o arquivo de index
 */
void sortFileKey(char *inputFile);

/**
 * Libera da memoria a estrutura de alunos.
 *
 * param alunos - Estrutura de alunos a serem liberadas.
 */
void freeAluno(Aluno aluno);

/**
 * Obtem um aluno no arquivo variavel.
 *
 * @param ra ra do aluno
 * @param fileName nome do arquivo variavel.
 * @param arquivoFixo nome do arquivo fixo, caso o variavel nao exista.
 *
 */
Aluno findAlunoByRaArquivoVariavel(int ra, char *fileName, char *arquivoFixo);

/**
 * Obtem um aluno no arquivo variavel, considerando um arquivo de index.
 */
Aluno findIndexAlunoByRa(int ra, char *fileName);

/**
 * Obtem o Ra na linha do arquivo de index
 */
int getRaLineIndex(FILE *arq, int ra, int *index);

/**
 * Realizar busca binaria no arquivo para localizar o ra do aluno desejado.
 */
int indexByRa(int ra, char *indexFile);

/**
 * Converte um aluno para uma string variavel para escrever no arquivo.
 */
char *converAlunoToVariableLine(Aluno aln, boolean escape);

/**
 * Deleta um registro logicamente no arquivo variavel.
 *
 * @param ra - Ra do aluno a ser deletado.
 * @param indexFile - Nome do arquivo de indexes.
 * @param pIndex - Index do aluno a ser excluido, para facilitar a delecao.
 *
 */
int deleteAluno(int ra, char *indexFile, char *variableFile, int pIndex);

/**
 * Gera o nome para o run file
 * @param count - Contador de run.
 * @return retorna o nome do arquivo de run.
 */
char *generateRunFileName(int count);

/**
 * Obtem a chave da linha do arquivo de tamanho fixo.
 *
 * @param line - Linha do arquivo
 * @param key - Chave de ordenacao.
 * @return chave da linha.
 */
char *getKeyLine(char *line, char *key);
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
		long *wrCount, long *recordCount);

/**
 * Remove todos os arquivos de run processados anteriormente.
 */
void deleteRunFiles();

/**
 * Gera o nome do arquivo csv para estatistica de sort.
 */
char *generateStatisticSortFileName();

/**
 * Obtem o index da linha do arquivo de index.
 *
 * @param line - Linha que contem chave e index.
 * @return index da linha.
 */
int getIndiceByLine(char *line);

/**
 * Ordena o um arquivo de aluno de tamanho fixo se baseando em um arquivo de indexes.
 *
 * @param inFile - arquivo de index.
 * @param outFile - arquivo de saida com os dados ordenados.
 * @param dataFile - arquivo original com os dados a serem ordenados.
 * @return true caso o processo tenha executado com sucesso.s
 */
boolean sortFinalFile(char *inFile, char *outFile, char *dataFile);
