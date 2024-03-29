/*
 ============================================================================
 Name        : main.c
 Author      : Cristiano J. Miranda
 Version     :
 Copyright   : mc832.unicamp.s1.2013
 Description : in C, Ansi-style
 ============================================================================
 */

#include <stdio.h>
#include <stdlib.h>

#include "controleacesso.h"
#include "amazonservice.h"
#include "server.h"

/**
 * Classe com a implementa?o de servidor e client, se for chamado com 
 * o parametro S (opera em modo server), 
 * com o parametro C (opera em modo cliente),
 * com o parametro T (roda os testes unitarios do sistema)
 */
int main(int argc, char* argv[]) {

	//printf("argc %d\n", argc);
	if (argc <= 1) {
		perror("Informe ao menos um parametro: [S-Server, C-Client, T-Test] [porta] [host]");
		exit(1);
	} else {
		// Opera me modo server
		if (strcmp(argv[1], "S") == 0) {
		
			if (argc < 3) {
				perror("Para inicilizar o servidor e necessario os parametros: [S] [porta]");
				exit(1);
			}
		
			executarServidor(atoi(argv[2]));
		} 
		
		// Opera em modo cliente
		else if (strcmp(argv[1], "C") == 0) {
		
			// Verifica se host e porta foram informados
			if (argc < 4) {
				perror("Para inicilizar o cliente e necessario os parametros: [C] [porta] [host]");
				exit(1);
			}
			
			// Inicializa o client
			executarCliente(atoi(argv[2]), argv[3]);
		
		} 
		
		// Executa os testes unitarios
		else if (strcmp(argv[1], "T") == 0) {
			executarTestes();
		}
		
		else {
			printf("Parametro invalido. Utilize: S - Server, C - Client, T - Test\n");
		}
	}
	
	return EXIT_SUCCESS;
}

/**
 * Executa teste dos principais servicos da Mini Amazon
 */
void executarTestes() {

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
	printf("Descricao do livro ISBN 0000000001: %s\n", obterDescricaoPorISBN("0000000001"));
	printf("Descricao do livro ISBN 0000000002: %s\n", obterDescricaoPorISBN("0000000002"));
	printf("Descricao do livro ISBN 0000000003: %s\n", obterDescricaoPorISBN("0000000003"));
	printf("Descricao do livro ISBN 0000000004: %s\n", obterDescricaoPorISBN("0000000004"));
	printf("Descricao do livro ISBN nao_exist: %s\n", obterDescricaoPorISBN("nao_exist"));
	printf("Descricao do livro ISBN nao_exist_2: %s\n", obterDescricaoPorISBN("nao_exist_2"));
	
	// Testando a obtencao de um livro por isbn
	printf("\n");
	printf("Obtendo o livro isbn: 0000000001\n");
	livro livro1 = obterLivroPorISBN("0000000001");
	printLivro(livro1);
	
	printf("Obtendo o livro isbn: 0000000002\n");
	livro livro2 = obterLivroPorISBN("0000000002");
	printLivro(livro2);
	
	printf("Obtendo o livro isbn: nao_exist\n");
	livro livro3 = obterLivroPorISBN("nao_exist");
	printLivro(livro3);
	
	// Testando obtencao de numer de exemplares em estoque de livro por isbn
	printf("\n");
	printf("Exemplares em estoque do livro ISBN 0000000001: %d\n", obterNrExemplaresEstoque("0000000001"));
	printf("Exemplares em estoque do livro ISBN 0000000002: %d\n", obterNrExemplaresEstoque("0000000002"));
	printf("Exemplares em estoque do livro ISBN 0000000003: %d\n", obterNrExemplaresEstoque("0000000003"));
	printf("Exemplares em estoque do livro ISBN 0000000004: %d\n", obterNrExemplaresEstoque("0000000004"));
	printf("Exemplares em estoque do livro ISBN nao_exist: %d\n", obterNrExemplaresEstoque("nao_exist"));
	printf("Exemplares em estoque do livro ISBN nao_exist_2: %d\n", obterNrExemplaresEstoque("nao_exist_2"));
	
	// Testando a obtencao de  todos os ISBN's da base de dados
	printf("\nObtendo todos os isbns");
	char* isbns = obterTodosISBNS();
	printf("\nTodos os ISBNs: \n%s", isbns);
	
	printf("\nAltenrando o nr de examplares\n");
	printf("Exemplares em estoque do livro ISBN 0000000001: %d\n", obterNrExemplaresEstoque("0000000001"));
	alterarNrExemplaresEstoquePorISBN("0000000001", 100);
	printf("Exemplares em estoque do livro ISBN 0000000001: %d\n", obterNrExemplaresEstoque("0000000001"));
	alterarNrExemplaresEstoquePorISBN("0000000001", 2);
	printf("Exemplares em estoque do livro ISBN 0000000001: %d\n", obterNrExemplaresEstoque("0000000001"));
	
	alterarNrExemplaresEstoquePorISBN("0000000002", 55);
	printf("Exemplares em estoque do livro ISBN 0000000002: %d\n", obterNrExemplaresEstoque("0000000002"));
	alterarNrExemplaresEstoquePorISBN("0000000002", 999);
	printf("Exemplares em estoque do livro ISBN 0000000002: %d\n", obterNrExemplaresEstoque("0000000002"));
	alterarNrExemplaresEstoquePorISBN("notfound", -1);

}
