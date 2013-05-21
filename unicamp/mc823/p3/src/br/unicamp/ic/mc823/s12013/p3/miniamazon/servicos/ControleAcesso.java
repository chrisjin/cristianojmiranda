package br.unicamp.ic.mc823.s12013.p3.miniamazon.servicos;

import br.unicamp.ic.mc823.s12013.p3.miniamazon.modelo.Usuario;

/**
 * Controle de acesso da livraria
 * 
 * @author Cristiano
 * 
 */
public interface ControleAcesso {

	/**
	 * Obtem o usuario pelo login
	 * 
	 * @param login
	 * @return
	 * @throws UsuarioNaoEncontradoException
	 */
	Usuario obterUsuarioPorLogin(String login)
			throws UsuarioNaoEncontradoException;

}
