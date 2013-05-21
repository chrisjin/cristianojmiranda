package br.unicamp.ic.mc823.s12013.p3.miniamazon.utils;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.Reader;
import java.io.StreamTokenizer;

public final class IOUtils {

	private static Reader reader = new BufferedReader(new InputStreamReader(
			System.in));

	private static BufferedReader bufferedReader = new BufferedReader(
			new InputStreamReader(System.in));

	private IOUtils() {

	}

	/**
	 * @param mensagem
	 * @return
	 */
	public static int getInt(String mensagem) {

		System.out.println(mensagem);

		StreamTokenizer st = new StreamTokenizer(reader);

		try {
			st.nextToken();
		} catch (IOException e) {
			System.out.println("Erro na leitura do teclado");
			return (0);
		}

		return ((int) st.nval);
	}

	/**
	 * @param mensagem
	 * @return
	 */
	public static long getLong(String mensagem) {

		System.out.println(mensagem);

		StreamTokenizer st = new StreamTokenizer(reader);

		try {
			st.nextToken();
		} catch (IOException e) {
			System.out.println("Erro na leitura do teclado");
			return (0);
		}

		return ((long) st.nval);
	}

	/**
	 * @param mensagem
	 * @return
	 */
	public static String getString(String mensagem) {

		System.out.println(mensagem);

		String input = null;

		try {
			input = bufferedReader.readLine();
		} catch (IOException e) {
			System.out.println("Erro na leitura do teclado");
		}

		return input;

	}

}
