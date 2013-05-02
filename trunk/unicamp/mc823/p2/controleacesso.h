/*
 * controleacesso.h
 *
 *  Created on: 21/03/2013
 *      Author: Cristiano
 */

#ifndef CONTROLEACESSO_H_
#define CONTROLEACESSO_H_

// Constantes para o tipo de acesso do usuario
#define USUARIO_LIVRARIA  "LIVRARIA"
#define USUARIO_CLIENTE  "CLIENTE"

// Apontador para usuario
typedef struct UsuarioStr* Usuario;

/**
 * Struct para armazenar informa��es do usuario que esta acessando a aplica��o.
 */
typedef struct UsuarioStr {

	// Documento do usuario
	int documento;
	char* nome;
	char* tipoUsuario;

};

/**
 * Pesquisa um usuario por seu numero de documento.
 */
Usuario obterUsuarioPorDocumento(int nrDocumento);

/**
 * Exibe as informa��es do usuario.
 */
void printUsuario(Usuario usuario);

#endif /* CONTROLEACESSO_H_ */
