package it.sauronsoftware.grab4j.html;

import it.sauronsoftware.grab4j.toolkit.EnvironmentToolkit;
import junit.framework.TestCase;

/**
 * @author Cristiano
 * 
 */
public class HTMLEntitiesTest extends TestCase {

	/**
	 * 
	 */
	public void testEncode() {

		String encode = HTMLEntities.encode("<div id='idDiv'>ma��</div>");
		EnvironmentToolkit.print("testEncode: " + encode);

		assertEquals("Falha ao realizar encoding.",
				"&lt;div id='idDiv'&gt;ma&ccedil;&atilde;&lt;/div&gt;", encode);

	}

	public void testDecode() {

		String decode = HTMLEntities

		.decode("&lt;div id='idDiv'&gt;ma&ccedil;&atilde;&lt;/div&gt;");

		EnvironmentToolkit.print("testeDecode: " + decode);

		assertEquals("", "<div id='idDiv'>ma��</div>", decode);

	}

	public void testEncodeDecode() {

		String original = "<span id='hehe'>NA��O, jos�, ling�i�a, ma��, v�em,�... ph � </span>";
		String encode = HTMLEntities.encode(original);
		String decode = HTMLEntities.decode(encode);

		assertEquals("Erro ao codificar/decodificar a string.", original,
				decode);
	}
}
