package br.unicamp.ic.mc823.s12013.p3.miniamazon.utils;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.text.DecimalFormat;

public final class LoggerUtils {

	private LoggerUtils() {

	}

	/**
	 * @param filePath
	 * @param tipo
	 * @param message
	 * @param inicio
	 * @param fim
	 */
	public static void logger(String filePath, String tipo, String message,
			long inicio, long fim) {

		try {

			DecimalFormat df = new DecimalFormat("0.000000");

			StringBuffer line = new StringBuffer(tipo);
			line.append(";");
			line.append(message);
			line.append(";");
			line.append(inicio);
			line.append(";");
			line.append(fim);
			line.append(";");
			line.append(fim - inicio);
			line.append(";");
			line.append(df.format((fim - inicio) / 1000.0));
			line.append(";\n");

			File file = new File(filePath);
			if (!file.exists()) {
				file.createNewFile();
			}

			FileWriter fw = new FileWriter(file.getAbsoluteFile(), true);
			BufferedWriter bw = new BufferedWriter(fw);
			bw.write(line.toString());
			bw.close();

		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	/**
	 * @param filePath
	 * @param tipo
	 * @param message
	 * @param inicio
	 */
	public static void logger(String filePath, String tipo, String message,
			long inicio) {
		logger(filePath, tipo, message, inicio, System.currentTimeMillis());
	}

}
