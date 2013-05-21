package br.unicamp.ic.mc823.s12013.p3.miniamazon.utils;

/**
 * @author Cristiano
 * 
 */
public final class StringUtils {

	private StringUtils() {

	}

	/**
	 * @param valor
	 * @param token
	 * @param size
	 * @return
	 */
	public static final String completarEsquerda(String valor, String token,
			int size) {

		if (valor.length() == size) {
			return valor;
		} else if (valor.length() > size) {
			return valor.substring(0, size);
		} else {

			StringBuffer tkBuffer = new StringBuffer();
			for (int i = 0; i < size - valor.length(); i++) {
				tkBuffer.append(token);
			}
			tkBuffer.append(valor);

			return completarEsquerda(tkBuffer.toString(), token, size);
		}

	}

	/**
	 * @param isbn
	 * @return
	 */
	public static boolean estaNulloOuVazio(String isbn) {
		return isbn == null || (isbn.trim().length() == 0);
	}

}
