/*
 * amazonservice.h
 *
 *  Created on: 21/03/2013
 *      Author: Cristiano
 */

#ifndef AMAZONSERVICE_H_
#define AMAZONSERVICE_H_

#define DATA_BASE_FILE "amazon-db.csv"
#define IGNORE_CSV_LINE_TOKEN '#'

// Apontador para Livro
typedef struct livro_s* livro;

// Struct com as informacoes de um livro
typedef struct livro_s {
	char* isbn;
	char* titulo;
	char* autores;
	char* editora;
	char* descricao;
	int anoPublicacao;
	int exemplaresEstoque;
} livro_s;

// Apontador para livro list
typedef struct livro_list_s* livro_list;

// Struct para armazenar a lista de livros
struct livro_list_s{
	livro titulo;
	livro_list proximo;
};

/**
 * Obtem todos os ISBN's da livraria.
 */
char* obterTodosISBNS();

/**
 * Obtem a descrição de um livro dado um ISBN.
 */
char* obterDescricaoPorISBN(char* isbn);

/**
 * Obtem todas as informações de um livro dado um ISBN.
 */
livro obterLivroPorISBN(char* isbn);
/**
 * Obtem uma lista com todos os livros
 */
livro_list obtemTodosLivros(int *list_size);

/**
 * Altera o nr de exemplares em estoque para um dado livro.
 * Retona -1 caso não exista o isbn, caso contrario operação realizada com sucesso.
 */
int alterarNrExemplaresEstoquePorISBN(char* isbn, int quantidade);

/**
 * Obtem a quantidade de exemplares em estoque para um determinado ISBN.
 * Caso não encontre o isbn retorna -1;
 */
int obterNrExemplaresEstoque(char* isbn);

/**
 * Imprime os dados de um livro.
 *
 */
void printLivro(livro livro);

/**
 * Imprime a lista de livros.
 */
void printLivros(livro_list lista, int list_size);

char* buildCsvLine(livro lv, int lineSize);

#endif /* AMAZONSERVICE_H_ */
