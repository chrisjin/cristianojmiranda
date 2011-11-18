package it.sauronsoftware.grab4j;

import java.io.File;
import java.net.URL;

import junit.framework.TestCase;

/**
 * @author Cristiano
 * 
 */
public class WebGrabberTest extends TestCase {

	private static final String PATH = "src/test/resources/";

	/**
	 * @throws Exception
	 */
	public void testGrabPTag() throws Exception {

		// Obtem o arquivo de teste
		URL pageUrl = new File(PATH + "testGrabPTag.html").toURL();

		// Obtem o script para teste
		File jsLogicFile = new File(PATH + "testGrabPTag.js");

		// Executa o grab
		Object res = WebGrabber.grab(pageUrl, jsLogicFile);

		System.out.println(res);

		assertNotNull("Era esperado um resultado.", res);
		assertTrue("Era esperado o valor 'Teste 1'", "Teste 1"
				.equalsIgnoreCase(res.toString()));
	}

}
