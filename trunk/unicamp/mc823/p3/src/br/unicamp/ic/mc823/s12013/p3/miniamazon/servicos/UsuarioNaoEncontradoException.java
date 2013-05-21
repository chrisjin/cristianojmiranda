package br.unicamp.ic.mc823.s12013.p3.miniamazon.servicos;

/**
 * @author Cristiano
 * 
 */
public class UsuarioNaoEncontradoException extends Exception {

	/**
	 * 
	 */
	private static final long serialVersionUID = -8655952858899318147L;

	/**
	 * @param message
	 * @param cause
	 */
	public UsuarioNaoEncontradoException(String message, Throwable cause) {
		super(message, cause);
	}

	/**
	 * @param message
	 */
	public UsuarioNaoEncontradoException(String message) {
		super(message);
	}

}
