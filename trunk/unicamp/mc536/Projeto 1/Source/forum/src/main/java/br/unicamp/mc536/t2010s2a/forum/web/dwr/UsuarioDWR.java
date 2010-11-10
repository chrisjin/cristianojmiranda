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

public class UsuarioDWR extends SpringBeanAutowiringSupport {

	@Autowired
	private ReloadableResourceBundleMessageSource bundle;

	/**
	 * @return the bundle
	 */
	public ReloadableResourceBundleMessageSource getBundle() {
		return bundle;
	}

	/**
	 * @param bundle
	 *            the bundle to set
	 */
	public void setBundle(ReloadableResourceBundleMessageSource bundle) {
		this.bundle = bundle;
	}

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

			WebContextFactory
					.get()
					.getHttpServletRequest()
					.setAttribute(
							"labelNome",
							this.bundle
									.getMessage(
											"label_br_unicamp_mc536_t2010s2a_forum_domain_usuario_nmusuario",
											null,
											RequestContextUtils
													.getLocale(WebContextFactory
															.get()
															.getHttpServletRequest())));

			WebContextFactory.get().getHttpServletRequest().setAttribute(
					"labelNome", "Nome");

			// Processa a pagina de usuarios
			result = WebContextFactory.get().forwardToString(
					"/WEB-INF/views/usuarios/dwrListUsuarios.jspx");

		}

		return result;

	}
}
