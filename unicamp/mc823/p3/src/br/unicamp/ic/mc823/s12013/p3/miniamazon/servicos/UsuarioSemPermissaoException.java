package br.unicamp.ic.mc823.s12013.p3.miniamazon.servicos;

/**
 * @author Cristiano
 * 
 */
public class UsuarioSemPermissaoException extends Exception {

	/**
	 * 
	 */
	private static final long serialVersionUID = -8652952858899458147L;

	/**
	 * @param message
	 * @param cause
	 */
	public UsuarioSemPermissaoException(String message, Throwable cause) {
		super(message, cause);
	}

	/**
	 * @param message
	 */
	public UsuarioSemPermissaoException(String message) {
		super(message);
	}

}
