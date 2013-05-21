package br.unicamp.ic.mc823.s12013.p3.miniamazon.servicos.impl;

import java.util.ArrayList;
import java.util.List;

import br.unicamp.ic.mc823.s12013.p3.miniamazon.modelo.Usuario;
import br.unicamp.ic.mc823.s12013.p3.miniamazon.servicos.ControleAcesso;
import br.unicamp.ic.mc823.s12013.p3.miniamazon.servicos.UsuarioNaoEncontradoException;
import br.unicamp.ic.mc823.s12013.p3.miniamazon.utils.LoggerUtils;
import br.unicamp.ic.mc823.s12013.p3.miniamazon.utils.StringUtils;

/**
 * @author Cristiano
 * 
 */
public class ControleAcessoImpl implements ControleAcesso {

	/**
	 * Lista de usuarios da livraria
	 */
	private List<Usuario> usuariosDb;

	/**
	 * 
	 */
	public ControleAcessoImpl() {

		// Cria a lista de clientes
		usuariosDb = new ArrayList<Usuario>();
		usuariosDb.add(new Usuario("cliente01", "cliente 01",
				Usuario.TIPO_USUARIO_CLIENTE));
		usuariosDb.add(new Usuario("cliente02", "cliente 02",
				Usuario.TIPO_USUARIO_CLIENTE));
		usuariosDb.add(new Usuario("cliente03", "cliente 03",
				Usuario.TIPO_USUARIO_CLIENTE));
		usuariosDb.add(new Usuario("cliente04", "cliente 04",
				Usuario.TIPO_USUARIO_CLIENTE));

		// Cria a lista de livrarias
		usuariosDb.add(new Usuario("livraria01", "livraria 01",
				Usuario.TIPO_USUARIO_LIVRARIA));
		usuariosDb.add(new Usuario("livraria02", "livraria 02",
				Usuario.TIPO_USUARIO_LIVRARIA));
		usuariosDb.add(new Usuario("livraria03", "livraria 03",
				Usuario.TIPO_USUARIO_LIVRARIA));
		usuariosDb.add(new Usuario("livraria04", "livraria 04",
				Usuario.TIPO_USUARIO_LIVRARIA));

	}

	@Override
	public Usuario obterUsuarioPorLogin(String login)
			throws UsuarioNaoEncontradoException {

		long inicio = System.currentTimeMillis();

		if (StringUtils.estaNulloOuVazio(login)) {
			LoggerUtils.logger("servertimer.csv", "SERVER",
					"OBTER_USUARIO_POR_LOGIN", inicio);
			throw new IllegalArgumentException("O campo login é obrigatório");
		}

		for (Usuario usuario : usuariosDb) {
			if (usuario.getLogin().equals(login)) {
				LoggerUtils.logger("servertimer.csv", "SERVER",
						"OBTER_USUARIO_POR_LOGIN", inicio);
				return usuario;
			}
		}

		LoggerUtils.logger("servertimer.csv", "SERVER",
				"OBTER_USUARIO_POR_LOGIN", inicio);
		throw new UsuarioNaoEncontradoException(
				"Não foi possível localizar o usuario com login " + login);
	}

}
