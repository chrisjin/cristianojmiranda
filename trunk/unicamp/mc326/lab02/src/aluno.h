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

#define SEXO(a) (a == 'M' ? getMessage("aluno.label.sexo.masculino") : getMessage("aluno.label.sexo.feminino"))
#define INDEX_NOT_FOUND_FOR_ALUNO -1
#define ARQUIVO_CONSULTA_FIXO_HTML "arquivo_consulta_fixo.html"
#define cabecalho "<HTML><HEAD><TITLE>Cadastro de Alunos da Unicamp.</TITLE></HEAD><body></body><table style='border: 1px solid black;'>"
#define FIM_HTML "</table></body></html>"

#define ENABLE_RECORD 'T'
#define DELETED_RECORD 'F'

#define INDEX_ALUNO_RECORD_TOKEN "="
#define INDEX_ALUNO_FILE "index_aluno.txt"
#define INDEX_ALUNO_FILE_SORTED "index_aluno.txt.sorted"

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
 */
LIST processarArquivoFormatoVariavel(char *inputFile, char *outputFile);
/**
 * Processa a lista de arquivo de tamanho variavel.
 */
LIST carregarAlunoArquivoVariavel(char *inputFile, LIST alunos,
		boolean showAluno);

/**
 * Cria o arquivo de formato variavel.
 */
void writeFileFormatoVariavel(FILE *file, Aluno aln);

/** Guarda dados do aluno em struct */
Aluno newAluno(char *value);

/**
 * Exibe as informacoes do arquivo de tamanho variavel.
 *
 * param arqVariavel nome do arquivo variavel
 * param alunos estrutura de alunos processados
 */
void showInformacoesArquivoVariavel(char *arqVariavel);

/**
 * Exibe a estrutura do arquivo de tamanho fixo.
 *
 * param alunos - Estrutura de alunos processados.
 */
char *showArquivoFormatoFixo(LIST alunos);

void writeFileFormatoHTML_inicio(FILE *file);

/**
 * Escreve o aluno no html de consulta.
 */
void writeFileFormatoHTML(FILE *file, Aluno aln);

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
 * Libera da memoria a estrutura de alunos.
 *
 * param alunos - Estrutura de alunos a serem liberadas.
 */
void freeAlunoList(LIST aluno);

/**
 * Obtem um aluno pelo ra.
 */
Aluno findAlunoByRaList(LIST alunos, int ra);

/**
 * Obtem um aluno no arquivo variavel.
 */
Aluno findAlunoByRaArquivoVariavel(int ra, char *fileName);

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
char *converAlunoToVariableLine(Aluno aln);

