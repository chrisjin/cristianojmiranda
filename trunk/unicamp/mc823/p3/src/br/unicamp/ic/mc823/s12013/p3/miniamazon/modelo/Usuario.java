package br.unicamp.ic.mc823.s12013.p3.miniamazon.modelo;

import java.io.Serializable;

/**
 * 
 * 
 * @author Cristiano
 * 
 */
public class Usuario implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1706285845232664326L;

	public static final Integer TIPO_USUARIO_CLIENTE = 0;
	public static final Integer TIPO_USUARIO_LIVRARIA = 1;

	private String login;
	private String nome;
	private Integer tipoUsuario;

	/**
	 * @param login
	 * @param nome
	 * @param tipoUsuario
	 */
	public Usuario(String login, String nome, Integer tipoUsuario) {
		super();
		this.login = login;
		this.nome = nome;
		this.tipoUsuario = tipoUsuario;
	}

	public String getLogin() {
		return login;
	}

	public String getNome() {
		return nome;
	}

	public Integer getTipoUsuario() {
		return tipoUsuario;
	}

}
