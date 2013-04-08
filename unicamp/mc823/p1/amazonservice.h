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

#define OBTER_TODOS_ISBNS "OBTER_TODOS_ISBNS"
#define OBTER_DESCRICAO_POR_ISBN "OBTER_DESCRICAO_POR_ISBN"
#define OBTER_LIVRO_POR_ISBN "OBTER_LIVRO_POR_ISBN"
#define OBTER_TODOS_LIVROS "OBTER_TODOS_LIVROS"
#define ALTERAR_NR_EXEMPLARES_ESTOQUE "ALTERAR_NR_EXEMPLARES_ESTOQUE"
#define OBTER_NR_EXEMPLARES_ESTOQUE "OBTER_NR_EXEMPLARES_ESTOQUE"

#define RESPONSE_END "RESPONSE_END"
#define RESPONSE_USUARIO_INVALIDO "RESPONSE_USUARIO_INVALIDO"
#define RESPONSE_USUARIO_SEM_PERMISSAO "RESPONSE_USUARIO_SEM_PERMISSAO"
#define RESPONSE_COMANDO_INVALIDO "COMANDO_INVALIDO"
#define ISBN_INVALIDO "ISBN invalido."

#define REQUEST_END "FIM"

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
 * Obtem a descri?o de um livro dado um ISBN.
 */
char* obterDescricaoPorISBN(char* isbn);

/**
 * Obtem todas as informa?es de um livro dado um ISBN.
 */
livro obterLivroPorISBN(char* isbn);
/**
 * Obtem uma lista com todos os livros
 */
livro_list obtemTodosLivros(int *list_size);

/**
 * Altera o nr de exemplares em estoque para um dado livro.
 * Retona -1 caso n? exista o isbn, caso contrario opera?o realizada com sucesso.
 */
int alterarNrExemplaresEstoquePorISBN(char* isbn, int quantidade);

/**
 * Obtem a quantidade de exemplares em estoque para um determinado ISBN.
 * Caso n? encontre o isbn retorna -1;
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
