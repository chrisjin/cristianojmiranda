package br.unicamp.mc536.t2010s2a.forum.web.dwr;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;

import org.directwebremoting.WebContextFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.ReloadableResourceBundleMessageSource;
import org.springframework.web.context.support.SpringBeanAutowiringSupport;
import org.springframework.web.servlet.support.RequestContextUtils;

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

	/**
	 * 
	 * Consulta de usuarios com resultado para injetar na tela de busca.
	 * 
	 * @return
	 * @throws IOException
	 * @throws ServletException
	 */
	public String listarUsuariosInject() throws ServletException, IOException {

		String result = "";

		// Obtem todos os usuarios
		List<Usuario> usuarios = Usuario.findAllUsuarios();

		if (usuarios != null && !usuarios.isEmpty()) {

			// Coloca a lista de usuarios na request
			WebContextFactory.get().getHttpServletRequest().setAttribute(
					"usuarios", usuarios);

			WebContextFactory.get().getHttpServletRequest().setAttribute(
					"labelNome", "Nome");

			WebContextFactory.get().getHttpServletRequest().setAttribute(
					"labelNomePais", "Pais");

			// Processa a pagina de usuarios
			result = WebContextFactory.get().forwardToString(
					"/WEB-INF/views/usuarios/dwrListUsuarios.jspx");

		}

		return result;

	}
	
}
