package br.unicamp.mc536.t2010s2a.forum.utils;

public class StringUtils extends org.springframework.util.StringUtils {

	/**
	 * @param value
	 * @return
	 */
	public static boolean isBlankOrNull(String value) {

		if (value == null)
			return true;

		if (value.trim().length() == 0)
			return true;

		return false;

	}

	public static boolean isLong(String value) {

		try {

			new Long(value);

		} catch (Exception e) {
			return false;
		}

		return true;

	}
}
