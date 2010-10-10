package br.unicamp.mc536.t2010s2a.forum.web;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import br.unicamp.mc536.t2010s2a.forum.domain.Usuario;

/**
 * @author Cristiano
 * 
 */
@RequestMapping(value = "/login")
@Controller
public class LoginController {

	/**
	 * For every request for this controller, this will create a person instance
	 * for the form.
	 */
	@ModelAttribute
	public Usuario newRequest(@RequestParam(required = false) Integer id) {

		System.out.println("Id: " + id);

		Usuario usuario = new Usuario();
		usuario.setDsLogin("-- XXX --");
		return usuario;

	}

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

		model.addAttribute("usuario", new Usuario());

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

		if (usuario != null) {

			// Tenta localizar o usuario por login e senha
			List<Usuario> usuarios = Usuario.findUsuarioByLoginAndPass(usuario
					.getDsLogin(), usuario.getDsSenha());

			// Caso tenha encontrado o usuario
			if (usuarios != null && !usuarios.isEmpty()) {

				return "index";

			}
		}

		usuario = new Usuario();

		return "login";
	}

}
