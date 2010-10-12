package br.unicamp.mc536.t2010s2a.forum.web.dwr;

import java.util.List;

import br.unicamp.mc536.t2010s2a.forum.domain.Usuario;

public class UsuarioDWR {

	/**
	 * Consulta todos os usuarios
	 * 
	 * @return
	 */
	public List<Usuario> listarUsuarios() {

		return Usuario.findAllUsuarios();
	}

}
