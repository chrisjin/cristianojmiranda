/*
 * controleacessoimpl.c
 *
 *  Created on: 21/03/2013
 *      Author: Cristiano
 */

#include<stdio.h>
#include<stdlib.h>
#include <string.h>

#include "mem.h"
#include "controleacesso.h"

/**
 * Aloca memoria para usuario;
 */
Usuario mallocUsuario() {

	// Aloca memoria para usuario
	Usuario usuario = (Usuario) MEM_ALLOC(Usuario);
	//usuario->documento = MEM_ALLOC(int);
	usuario ->nome = MEM_ALLOC_N(char, 50);
	usuario->tipoUsuario = MEM_ALLOC_N(char, 10);

	return usuario;
}

/**
 * Pesquisa um usuario por seu numero de documento.
 */
Usuario obterUsuarioPorDocumento(int nrDocumento) {

	// TODO: quando for conveniente mudar o controle de usuario para um arquivo .csv

	if (nrDocumento == 1111) {

		Usuario usuario = mallocUsuario();
		usuario->documento = 1111;
		strcat(usuario->nome, "cliente 01");
		strcat(usuario->tipoUsuario, USUARIO_CLIENTE);
		return usuario;
	}

	if (nrDocumento == 2222) {

		Usuario usuario = mallocUsuario();
		usuario->documento = 2222;
		strcat(usuario->nome, "cliente 02");
		strcat(usuario->tipoUsuario, USUARIO_CLIENTE);
		return usuario;
	}

	if (nrDocumento == 3333) {

		Usuario usuario = mallocUsuario();
		usuario->documento = 3333;
		strcat(usuario->nome, "livraria 01");
		strcat(usuario->tipoUsuario, USUARIO_LIVRARIA);
		return usuario;
	}

	return NULL;
}

/**
 * Exibe as informações do usuario.
 */
void printUsuario(Usuario usuario) {

	printf("\n--- Dados do Usuario ---\n");
	if (usuario) {
		printf("\tDocumento: %i\n", usuario->documento);
		printf("\tNome: %s\n", usuario->nome);
		printf("\tTipo de Usuario: %s\n", usuario->tipoUsuario);
	} else {
		puts("\n\n\t *** Usuario inexistente. *** ");
	}

}
