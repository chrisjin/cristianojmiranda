/*
 * amazonservice.h
 *
 *  Created on: 21/03/2013
 *      Author: Cristiano
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "mem.h"
#include "io.h"
#include "utils.h"
#include "amazonservice.h"

livro_list livro_list_cache = NULL;
int livro_list_cache_size = 0;

/**
 * Obtem todos os ISBN's da livraria.
 */
char* obterTodosISBNS() {

	// Localiza todos os livros da base
	int list_size;
	livro_list livros = obtemTodosLivros(&list_size);
	livro_list it = livros;
	
	// Caso nao exista livros na base
	if (list_size == 0) {
		return NULL;
	}
	
	char* isbns = NULL;
	int contador = 0;
	while (it != NULL) {
		livro lv = it->titulo;
		if (lv != NULL) {
		
			//printf("\nobterTodosISBNS() - isbn: %s\n", lv->isbn);
			//printf("obterTodosISBNS() - isbns: %s\n", isbns);
		
			// Calcula o tamanho de um novo registros
			int tam_registro = strlen(lv->isbn) + strlen(lv->titulo) + 5;
		
			// Aloca o resultado
			if (isbns == NULL) {
				isbns = MEM_ALLOC_N(char, tam_registro);
				//printf("alocando size: %d\n", tam_registro);
				snprintf(isbns, tam_registro, "%s - %s\n", lv->isbn, lv->titulo);				
			} else {
				int tam_registro_realloc = strlen(isbns) + tam_registro + 2;
				//printf("realocando size: %d\n", tam_registro_realloc);
				char* tmp = MEM_ALLOC_N(char, strlen(isbns) + 1);
				strcpy(tmp, isbns);
				isbns = (char*) realloc(isbns, tam_registro_realloc);
				snprintf(isbns, tam_registro_realloc, "%s%s - %s\n", tmp, lv->isbn, lv->titulo);
			}
			
			//strncat(isbns, lv->isbn, strlen(lv->isbn));
			//strncat(isbns, "\n", 1);			
		}
		
		++contador;
		if (contador == list_size){
			break;
		}
		it = it->proximo;
	}

	return isbns;
}

/**
 * Obtem a descri?o de um livro dado um ISBN.
 */
char* obterDescricaoPorISBN(char* isbn) {
	
	livro lvr = obterLivroPorISBN(isbn);
	if (lvr) {
		return lvr->descricao;
	}

	return NULL;
}

/**
 * Obtem todas as informa?es de um livro dado um ISBN.
 */
livro obterLivroPorISBN(char* isbn) {

	// Localiza todos os livros da base
	int list_size;
	livro_list livros = obtemTodosLivros(&list_size);
	livro_list it = livros;
	
	// Caso nao exista livros na base
	if (list_size == 0) {
		printf("Livro nao encontrado.\n");
		return NULL;
	}
	
	int contador = 0;
	while (it) {
		livro lv = it->titulo;
		if (strcmp(lv->isbn, isbn) == 0) {
			return lv;
		}
		++contador;
		
		if (contador == list_size){
			break;
		}
		
		it = it->proximo;
	}

	printf("Livro nao encontrado.\n");
	return NULL;
}

/**
 * Converte uma linha do arquivo database em um registro de livro.
 *
 * Estrutura do csv:
 * isbn;titulo;autores;editora;descricao;anoPublicacao;exemplaresEstoque;
 */
livro parseDbLineToLivro(char* line) {

	printf("parseDbLineToLivro(), line: '%s'\n", line);

	if (strlen(line) == 0) {
		printf("Linha vazia\n");
		return NULL;
	}


	// Aloca o vetor para ler o database
	char* parsedLine[7];

	// Realiza o parse da linha do csv
	csvParse(line, parsedLine, 7);

	if (strlen(parsedLine[0]) < 10) {
		printf("empty parse\n");
		return NULL;
	}

	// Aloca memoria para o livro
	livro lv = (livro) MEM_ALLOC(livro);

	// Aloca memoria para os valores da linha
	lv->isbn = MEM_ALLOC_N(char, strlen(parsedLine[0]));
	lv->titulo = MEM_ALLOC_N(char, strlen(parsedLine[1]));
	lv->autores = MEM_ALLOC_N(char, strlen(parsedLine[2]));
	lv->editora = MEM_ALLOC_N(char, strlen(parsedLine[3]));
	lv->descricao = MEM_ALLOC_N(char, strlen(parsedLine[4]));

	lv->isbn = copyStr(parsedLine[0]);
	lv->titulo = copyStr(parsedLine[1]);
	lv->autores = copyStr(parsedLine[2]);
	lv->editora = copyStr(parsedLine[3]);
	lv->descricao = copyStr(parsedLine[4]);
	
	lv->anoPublicacao = atoi(parsedLine[5]);
	lv->exemplaresEstoque = atoi(parsedLine[6]);

	return lv;
}

/**
 * Obtem uma lista com todos os livros
 */
livro_list obtemTodosLivros(int *list_size) {
	
	if (livro_list_cache != NULL) {
		//printf("Usando cache...\n");
		
		// Retorna o tamanho da lista
		*list_size = livro_list_cache_size;
		
		return livro_list_cache;
	}
	
	// Abre o arquivo com a base de dados da mini amazon 
	FILE* dbFile = Fopen(DATA_BASE_FILE, "r");
	
	char line[READ_BUFFER_SIZE];
	stripWhiteSpace(line);

	// Instancia a lista de livros
	livro_list lista = (livro_list)malloc(sizeof(livro_list));

	lista->proximo = NULL;
	livro_list it = lista;

	int contador = 0;
	while (fgets(line, READ_BUFFER_SIZE, dbFile) != NULL) {
		
		// Ignore line
		if(line[0] != IGNORE_CSV_LINE_TOKEN) {
		
			//printf("Linha: %s", line);
			
			it->titulo = parseDbLineToLivro(line);
			
			if (it->proximo == NULL) {
				it->proximo = (livro_list)malloc(sizeof(livro_list));
			}
			
			it = it->proximo;
			
			// Incrementa o contador da lista
			contador++;
		}
	}

	// Fecha o arquivo com a base de dados
	fclose(dbFile);
	
	// Retorna o tamanho da lista
	*list_size = contador;
	
	//printf("Existe na base %d livros.\n", contador);

	// Set cache
	livro_list_cache = lista;
	livro_list_cache_size = contador;
	
	// Retorna a lista de livros
	return lista;
}

char* buildCsvLine(livro lv, int lineSize) {
	
	int lineSz = lineSize + 10;
	char* linha = MEM_ALLOC_N(char, lineSz);
	stripWhiteSpace(linha);

	// Remonta a linha do csv a partir do livro
	snprintf(linha, lineSz, "%s;%s;%s;%s;%s;%i;%i;\n", lv->isbn, lv->titulo, lv->autores, lv->editora, lv->descricao, lv->anoPublicacao, 
lv->exemplaresEstoque);
	
	return linha;
}

/**
 * Altera o nr de exemplares em estoque para um dado livro.
 * Retona -1 caso n? exista o isbn, caso contrario opera?o realizada com sucesso.
 */
int alterarNrExemplaresEstoquePorISBN(char* isbn, int quantidade) {

	// Abre o arquivo com a base de dados da mini amazon 
	FILE* dataBaseFile = Fopen(DATA_BASE_FILE, "r+");
	
	char line[READ_BUFFER_SIZE];
	stripWhiteSpace(line);

	int lineSize = 0;
	int posicaoAtual = 0;
	livro lv = NULL;
	while (fgets(line, READ_BUFFER_SIZE, dataBaseFile) != NULL) {
	
		lineSize = strlen(line);
		posicaoAtual = posicaoAtual + lineSize;
		int startLine = posicaoAtual - lineSize;
		
		/*
		printf("Linha: %s\n", line);
		printf("Tamanho da linha corrente: %d\n", lineSize);
		printf("Posicao atual do cursor: %d\n", posicaoAtual);
		printf("Posicao do inicio da linha: %d\n", startLine);
		*/
		
		// Ignore line
		if(line[0] != IGNORE_CSV_LINE_TOKEN) {
			
			// Obtem o livro
			lv = parseDbLineToLivro(line);
			if (strcmp(lv->isbn, isbn) == 0) {
				//printf("\n -->COMENTANDO A LINHA COM O ISB DESEJADO\n");
				fseek(dataBaseFile, startLine, SEEK_SET);
				fputs("#", dataBaseFile);
				fclose(dataBaseFile);
				break;			
			}
			
			lv = NULL;
		}
	}
	
	if (lv != NULL) {
	
		// Abre o arquivo novamente para adicionar a nova linha
		dataBaseFile = Fopen(DATA_BASE_FILE, "a+");
	
		// Atualiza o livro com a quantidade correta
		lv->exemplaresEstoque = quantidade;
		
		// Escreve a linha com o novo valor no banco
		fputs(buildCsvLine(lv, lineSize), dataBaseFile);
	
		livro_list_cache = NULL;
	
		// Fecha o arquivo com a base de dados
		fclose(dataBaseFile);
		
		return 0;
		
	} else {
		printf("Livro nao encontrado.\n");
	}

	return -1;
}

/**
 * Obtem a quantidade de exemplares em estoque para um determinado ISBN.
 * Caso n? encontre o isbn retorna -1;
 */
int obterNrExemplaresEstoque(char* isbn) {

	livro lv = obterLivroPorISBN(isbn);

	if (lv) {
		return lv->exemplaresEstoque;
	}

	return -1;
}

/**
 * Imprime os dados de um livro.
 *
 */
void printLivro(livro lv) {

	if (lv != NULL) {
		printf("\n--- Dados do Livro ---\n");
		printf("\tISBN: %s\n", lv->isbn);
		printf("\tTitulo: %s\n", lv->titulo);
		printf("\tAutores: %s\n", lv->autores);
		printf("\tEditora: %s\n", lv->editora);
		printf("\tAno Publicacao: %i\n", lv->anoPublicacao);
		printf("\tDescricao: %s\n", lv->descricao);
		printf("\tEstoque: %i\n", lv->exemplaresEstoque);
	}

}

/**
 * Imprime a lista de livros.
 */
void printLivros(livro_list livros, int list_size) {
	
	printf("\n------ printLivros ------\n");
	
	if (list_size == 0) {
		printf("\t *** Nenhum livro encontrado ***\n");
	} else {
		int contador = 0;
		livro_list it = livros;
		while (it != NULL) {
			printLivro(it->titulo);
			++contador;
			
			if (contador == list_size){
				break;
			}
			
			it = it->proximo;
		}
	}
}
