package br.unicamp.mc536.t2010s2a.forum.web;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.context.request.RequestAttributes;
import org.springframework.web.context.request.RequestContextHolder;

import br.unicamp.mc536.t2010s2a.forum.domain.Usuario;
import br.unicamp.mc536.t2010s2a.forum.utils.Constantes;

import com.mysql.jdbc.StringUtils;

/**
 * @author Cristiano
 * 
 */
@RequestMapping(value = "/login")
@Controller
public class LoginController {

	/**
	 * <p>
	 * Login form request.
	 * </p>
	 * 
	 * <p>
	 * Expected HTTP GET and request '/login?form'.
	 * </p>
	 */
	@RequestMapping(params = "form", method = RequestMethod.GET)
	public String createForm(Model model) {

		// Remove o usuario da sessão
		RequestContextHolder.currentRequestAttributes().removeAttribute(
				Constantes.SESSION_USER, RequestAttributes.SCOPE_SESSION);

		model.addAttribute("usuario", new Usuario());
		model.addAttribute("message", Constantes.MSG_EMPTY);

		return "login";
	}

	/**
	 * <p>
	 * Executa o login.
	 * </p>
	 * 
	 */
	@RequestMapping(params = "executeLogin", method = RequestMethod.POST)
	public String executeLogin(Usuario usuario, Model model) {

		// Verifica se os campos foram preenchidos
		if (usuario == null || StringUtils.isNullOrEmpty(usuario.getDsLogin())
				|| StringUtils.isNullOrEmpty(usuario.getDsSenha())) {

			model.addAttribute("message",
					Constantes.MSG_CAMPO_OBRIGATORIO_NAO_PREENCHIDO);
			return "login";

		}

		if (usuario != null) {

			// Tenta localizar o usuario por login e senha
			List<Usuario> usuarios = Usuario.findUsuarioByLoginAndPass(usuario
					.getDsLogin(), usuario.getDsSenha());

			// Caso tenha encontrado o usuario
			if (usuarios != null && usuarios.size() == 1) {

				// Coloca o usuario na sessão
				RequestContextHolder.currentRequestAttributes().setAttribute(
						Constantes.SESSION_USER, usuarios.get(0),
						RequestAttributes.SCOPE_SESSION);
				return "index";

			} else {

				model.addAttribute("message", Constantes.MSG_LOGIN_INVALIDO);

			}
		}

		usuario = new Usuario();

		return "login";
	}

}
