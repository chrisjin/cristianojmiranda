/*
 ============================================================================
 Name        : mc823-S12013-p1-miniAmazon.c
 Author      : Cristiano J. Miranda
 Version     :
 Copyright   : Your copyright notice
 Description : in C, Ansi-style
 ============================================================================
 */

#include <stdio.h>
#include <stdlib.h>

#include "controleacesso.h"
#include "amazonservice.h"

/**
 * Essa classe executa os testes nas principais bibliotecas do sistema.
 */
int main(void) {

	printf("mini Amazon - Testes");

	// Testa controle de acesso de usuario
	printUsuario(obterUsuarioPorDocumento(1111));
	printUsuario(obterUsuarioPorDocumento(2222));
	printUsuario(obterUsuarioPorDocumento(3333));
	printUsuario(obterUsuarioPorDocumento(4444));

	// ----  Testa amazon services --------
	
	// Testando pesquisa de todos os livros
	int tamanho_lista;
	livro_list livros = obtemTodosLivros(&tamanho_lista);
	printLivros(livros, tamanho_lista);

	// Testando obtencao de descricao de livro por isbn
	printf("\n");
	printf("Descricao do livro ISBN 000000001: %s\n", obterDescricaoPorISBN("000000001"));
	printf("Descricao do livro ISBN 000000002: %s\n", obterDescricaoPorISBN("000000002"));
	printf("Descricao do livro ISBN 000000003: %s\n", obterDescricaoPorISBN("000000003"));
	printf("Descricao do livro ISBN 000000004: %s\n", obterDescricaoPorISBN("000000004"));
	printf("Descricao do livro ISBN nao_exist: %s\n", obterDescricaoPorISBN("nao_exist"));
	printf("Descricao do livro ISBN nao_exist_2: %s\n", obterDescricaoPorISBN("nao_exist_2"));
	
	// Testando a obtencao de um livro por isbn
	printf("\n");
	printf("Obtendo o livro isbn: 000000001\n");
	livro livro1 = obterLivroPorISBN("000000001");
	printLivro(livro1);
	
	printf("Obtendo o livro isbn: 000000002\n");
	livro livro2 = obterLivroPorISBN("000000002");
	printLivro(livro2);
	
	printf("Obtendo o livro isbn: nao_exist\n");
	livro livro3 = obterLivroPorISBN("nao_exist");
	printLivro(livro3);
	
	// Testando obtencao de numer de exemplares em estoque de livro por isbn
	printf("\n");
	printf("Exemplares em estoque do livro ISBN 000000001: %d\n", obterNrExemplaresEstoque("000000001"));
	printf("Exemplares em estoque do livro ISBN 000000002: %d\n", obterNrExemplaresEstoque("000000002"));
	printf("Exemplares em estoque do livro ISBN 000000003: %d\n", obterNrExemplaresEstoque("000000003"));
	printf("Exemplares em estoque do livro ISBN 000000004: %d\n", obterNrExemplaresEstoque("000000004"));
	printf("Exemplares em estoque do livro ISBN nao_exist: %d\n", obterNrExemplaresEstoque("nao_exist"));
	printf("Exemplares em estoque do livro ISBN nao_exist_2: %d\n", obterNrExemplaresEstoque("nao_exist_2"));
	
	// Testando a obtencao de  todos os ISBN's da base de dados
	printf("\nObtendo todos os isbns");
	char* isbns = obterTodosISBNS();
	printf("\nTodos os ISBNs: \n%s", isbns);
	
	printf("\nAltenrando o nr de examplares\n");
	printf("Exemplares em estoque do livro ISBN 000000001: %d\n", obterNrExemplaresEstoque("000000001"));
	alterarNrExemplaresEstoquePorISBN("000000001", 1000);
	printf("Exemplares em estoque do livro ISBN 000000001: %d\n", obterNrExemplaresEstoque("000000001"));
	alterarNrExemplaresEstoquePorISBN("000000001", 2);
	printf("Exemplares em estoque do livro ISBN 000000001: %d\n", obterNrExemplaresEstoque("000000001"));
	
	alterarNrExemplaresEstoquePorISBN("000000002", 55);
	printf("Exemplares em estoque do livro ISBN 000000002: %d\n", obterNrExemplaresEstoque("000000002"));
	alterarNrExemplaresEstoquePorISBN("000000002", 999);
	printf("Exemplares em estoque do livro ISBN 000000002: %d\n", obterNrExemplaresEstoque("000000002"));
	alterarNrExemplaresEstoquePorISBN("notfound", -1);
	

	return EXIT_SUCCESS;
}