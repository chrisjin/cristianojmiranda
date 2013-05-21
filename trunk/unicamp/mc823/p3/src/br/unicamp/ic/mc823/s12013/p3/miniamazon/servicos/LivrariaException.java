package br.unicamp.ic.mc823.s12013.p3.miniamazon.servicos;

/**
 * @author Cristiano
 * 
 */
public class LivrariaException extends Exception {

	/**
	 * 
	 */
	private static final long serialVersionUID = -8652952858899318147L;

	/**
	 * @param message
	 * @param cause
	 */
	public LivrariaException(String message, Throwable cause) {
		super(message, cause);
	}

	/**
	 * @param message
	 */
	public LivrariaException(String message) {
		super(message);
	}

}
