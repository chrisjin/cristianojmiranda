package br.com.cjm.mega.util;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;

import sun.misc.BASE64Decoder;
import sun.misc.BASE64Encoder;

/**
 * Classe utilitaria
 * 
 * @author Cristiano
 * 
 */
public class MegaUtil {

	/**
	 * Serializa um objeto para uma String
	 * 
	 * @param obj
	 * @return
	 */
	public static String objToString(Object obj) {
		String out = null;
		if (obj != null) {
			BASE64Encoder encode = new BASE64Encoder();
			try {
				ByteArrayOutputStream baos = new ByteArrayOutputStream();
				ObjectOutputStream oos = new ObjectOutputStream(baos);
				oos.writeObject(obj);
				out = encode.encode(baos.toByteArray());
			} catch (IOException e) {
				e.printStackTrace();
				return null;
			}
		}
		return out;
	}

	/**
	 * Deserializa uma String para um objeto
	 * 
	 * @param str
	 * @return
	 */
	public static Object stringToObject(String str) {
		long start = System.currentTimeMillis();
		Object out = null;
		if (str != null) {
			BASE64Decoder decode = new BASE64Decoder();
			try {

				ByteArrayInputStream bios = new ByteArrayInputStream(decode
						.decodeBuffer(str));
				ObjectInputStream ois = new ObjectInputStream(bios);
				out = ois.readObject();
			} catch (IOException e) {
				e.printStackTrace();
				return null;
			} catch (ClassNotFoundException e) {
				e.printStackTrace();
				return null;
			}
		}
		long end = System.currentTimeMillis();
		System.out.println("Decode:" + (end - start));
		return out;
	}

}
