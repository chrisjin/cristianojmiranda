package it.sauronsoftware.grab4j;

import it.sauronsoftware.grab4j.html.HTMLDocument;
import it.sauronsoftware.grab4j.html.HTMLDocumentFactory;
import it.sauronsoftware.grab4j.html.HTMLParseException;
import it.sauronsoftware.grab4j.toolkit.EnvironmentToolkit;

import java.io.File;
import java.net.URL;

import junit.framework.TestCase;

/**
 * Teste unitario para WebGrabber.
 * 
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

		assertNotNull("Era esperado um resultado.", res);
		assertTrue("Era esperado o valor 'Teste 1'", "Teste 1"
				.equalsIgnoreCase(res.toString()));
	}

	/**
	 * @throws Exception
	 */
	public void testGrabPTagHTMLDocument() throws Exception {

		URL url = new File(PATH + "testGrabPTag.html").toURL();

		HTMLDocument document = HTMLDocumentFactory.buildDocument(url);

		Object res = WebGrabber.grab(document, new File(PATH
				+ "testGrabPTag.js"));

		assertNotNull("Era esperado um resultado.", res);
		assertTrue("Era esperado o valor 'Teste 1'", "Teste 1"
				.equalsIgnoreCase(res.toString()));

	}

	/**
	 * @throws Exception
	 */
	public void testGrabPTagHTMLStringJs() throws Exception {

		URL url = new File(PATH + "testGrabPTag.html").toURL();

		HTMLDocument document = HTMLDocumentFactory.buildDocument(url);

		StringBuffer buffer = new StringBuffer();

		buffer.append(" var ret = \"\"; ");
		buffer
				.append(" var paragraphs = document.searchElements(\"html/body/p\"); ");
		buffer.append(" for ( var i = 0; i < paragraphs.length; i++) { ");
		buffer.append(" var text = paragraphs[i].getInnerText(); ");
		buffer.append(" ret += \"\" + text; ");
		buffer.append(" } ");
		buffer.append(" result = ret; ");

		Object res = WebGrabber.grab(document, buffer.toString());
		EnvironmentToolkit.print("testGrabPTagHTMLStringJs: " + (String) res);

		assertNotNull("Era esperado um resultado.", res);
		assertTrue("Era esperado o valor 'Teste 1'", "Teste 1"
				.equalsIgnoreCase(res.toString()));

	}

	/**
	 * @throws Exception
	 */
	public void testGrabPTagHTMLLongPath() throws Exception {

		URL url = new File(PATH + "testGrabPTagLongPath.html").toURL();

		HTMLDocument document = HTMLDocumentFactory.buildDocument(url);

		Object res = WebGrabber.grab(document, new File(PATH
				+ "testGrabPTagLongPath.js"));

		assertNotNull("Era esperado um resultado.", res);
		assertTrue("Era esperado o valor 'Teste 1'", "Teste 1"
				.equalsIgnoreCase(res.toString()));

	}

	/**
	 * @throws Exception
	 */
	public void testGrabNullScript() throws Exception {

		try {

			URL url = new File(PATH + "testGrabPTagLongPath.html").toURL();

			HTMLDocument document = HTMLDocumentFactory.buildDocument(url);

			String jsLogic = null;
			Object res = WebGrabber.grab(document, jsLogic);
			fail("Era esperado um ScriptException.");

			assertNotNull("Era esperado um resultado.", res);
			assertTrue("Era esperado o valor 'Teste 1'", "Teste 1"
					.equalsIgnoreCase(res.toString()));

		} catch (ScriptException scriptException) {

		} catch (Exception e) {
			fail("Era esperado um ScriptException, ao invez de " + e);
		}

	}

	/**
	 * @throws Exception
	 */
	public void testGrabUrlNull() throws Exception {

		URL url = null;

		try {

			HTMLDocument document = HTMLDocumentFactory.buildDocument(url);

			fail("Era esperado um nullpointer exception");
			Object res = WebGrabber.grab(document, new File(PATH
					+ "testGrabPTagLongPath.js"));

			assertNotNull("Era esperado um resultado.", res);
			assertTrue("Era esperado o valor 'Teste 1'", "Teste 1"
					.equalsIgnoreCase(res.toString()));
		} catch (NullPointerException nullPointerException) {

		}

	}

	/**
	 * @throws Exception
	 */
	public void testGrabMavePageGetBreadCrumb() throws Exception {

		URL url = new File(PATH + "WhatisMaven.html").toURL();

		HTMLDocument document = HTMLDocumentFactory.buildDocument(url);

		StringBuffer script = new StringBuffer();
		script.append(" var ret = \"\"; ");
		script
				.append(" var paragraphs = document.searchElements(\"html/body/div(id=breadcrumbs)\"); ");
		script.append(" for ( var i = 0; i < paragraphs.length; i++) { ");
		script.append(" var text = paragraphs[i].getInnerText(); ");
		script.append(" ret += \"\" + text; ");
		script.append(" } ");
		script.append(" result = ret; ");

		String res = (String) WebGrabber.grab(document, script.toString());
		EnvironmentToolkit.print("testGrabMavePageGetBreadCrumb:" + res);

		assertNotNull("Era esperado um resultado.", res);
		assertTrue(
				"Era esperado o valor 'Apache > Maven > What is Maven? Last Published: 2011-11-18'",
				"Apache > Maven > What is Maven? Last Published: 2011-11-18"
						.equalsIgnoreCase(res.toString()));

	}

	/**
	 * @throws Exception
	 */
	public void testGrabMavePageGetSections() throws Exception {

		URL url = new File(PATH + "WhatisMaven.html").toURL();

		HTMLDocument document = HTMLDocumentFactory.buildDocument(url);

		StringBuffer script = new StringBuffer();
		script.append(" var ret = ''; ");
		script.append(" var paragraphs = document.getElementsByTag('h2'); ");
		script.append(" for ( var i = 0; i < paragraphs.length; i++) { ");
		script.append(" var text = paragraphs[i].getInnerText(); ");
		script.append(" ret += (ret == '' ? '' : ', ') + text; ");
		script.append(" } ");
		script.append(" result = ret; ");

		String res = (String) WebGrabber.grab(document, script.toString());
		EnvironmentToolkit.print("testGrabMavePageGetSections:" + res);

		assertNotNull("Era esperado um resultado.", res);
		assertTrue(
				"Era esperado o valor 'Introduction, Maven's Objectives, What is Maven Not?'",
				"Introduction, Maven's Objectives, What is Maven Not?"
						.equalsIgnoreCase(res.toString()));

	}

	/**
	 * @throws Exception
	 */
	public void testGrabMavePageGetFirstSection() throws Exception {

		URL url = new File(PATH + "WhatisMaven.html").toURL();

		HTMLDocument document = HTMLDocumentFactory.buildDocument(url);

		StringBuffer script = new StringBuffer();
		script.append(" var ret = ''; ");
		script.append(" var paragraphs = document.getElementsByTag('h2'); ");
		script.append(" for ( var i = 0; i < paragraphs.length; i++) { ");
		script.append(" var text = paragraphs[i].getInnerText(); ");
		script.append(" ret += (ret == '' ? '' : ', ') + text; break;");
		script.append(" } ");
		script.append(" result = ret; ");

		String res = (String) WebGrabber.grab(document, script.toString());
		EnvironmentToolkit.print("testGrabMavePageGetFirstSection:" + res);

		assertNotNull("Era esperado um resultado.", res);
		assertTrue("Era esperado o valor 'Introduction'", "Introduction"
				.equalsIgnoreCase(res.toString()));

	}

	/**
	 * @throws Exception
	 */
	public void testGrabMavePageGetImages() throws Exception {

		URL url = new File(PATH + "WhatisMaven.html").toURL();

		HTMLDocument document = HTMLDocumentFactory.buildDocument(url);

		StringBuffer script = new StringBuffer();
		script.append(" var ret = ''; ");
		script.append(" var paragraphs = document.getElementsByTag('img'); ");
		script.append(" for ( var i = 0; i < paragraphs.length; i++) { ");
		script.append(" var text = paragraphs[i].getImageURL(); ");
		script.append("var pt = text.split('/');");
		script.append("text = pt[pt.length - 1];");
		script.append(" ret += (ret == '' ? '' : ', ') + text;");
		script.append(" } ");
		script.append(" result = ret; ");

		String res = (String) WebGrabber.grab(document, script.toString());
		EnvironmentToolkit.print("testGrabMavePageGetImages:" + res);

		String[] imgs = res.split(",");

		assertNotNull("Era esperado um resultado.", res);
		assertTrue(
				"Era esperado o valor 'apache-maven-project-2.png, maven-logo-2.gif, maven-feather.png'",
				"apache-maven-project-2.png, maven-logo-2.gif, maven-feather.png"
						.equalsIgnoreCase(res.toString()));
		assertTrue("Era esperado 3 imagens", imgs.length == 3);

	}

	/**
	 * @throws Exception
	 */
	public void testGrabMavePageGetFooter() throws Exception {

		URL url = new File(PATH + "WhatisMaven.html").toURL();

		HTMLDocument document = HTMLDocumentFactory.buildDocument(url);

		StringBuffer script = new StringBuffer();
		script.append(" var ret = ''; ");
		script
				.append(" var paragraphs = document.getElementsByAttribute('id', 'footer'); ");
		script.append(" for ( var i = 0; i < paragraphs.length; i++) { ");
		script
				.append(" var text = (paragraphs[i].getElements()[0]).getInnerText(); ");
		script.append("var pt = text.split('/');");
		script.append("text = pt[pt.length - 1];");
		script.append(" ret += (ret == '' ? '' : ', ') + text;");
		script.append(" } ");
		script.append(" result = ret; ");

		String res = (String) WebGrabber.grab(document, script.toString());
		EnvironmentToolkit.print("testGrabMavePageGetFooter:" + res);

		assertNotNull("Era esperado um resultado.", res);
		assertTrue("Footer não encontrado.", res
				.indexOf("The Apache Software Foundation - Privacy Policy") > 0);

	}

	/**
	 * @throws Exception
	 */
	public void testGrabMavePageGetLinks() throws Exception {

		URL url = new File(PATH + "WhatisMaven.html").toURL();

		HTMLDocument document = HTMLDocumentFactory.buildDocument(url);

		StringBuffer script = new StringBuffer();
		script.append(" var ret = ''; ");
		script.append(" var links = document.getElementsByTag('a'); ");
		script.append(" for ( var i = 0; i < links.length; i++) { ");
		script.append(" var text = links[i].getLinkURL(); ");
		script.append(" ret += (ret == '' ? '' : ', ') + text;");
		script.append(" } ");
		script.append(" result = ret; ");

		String res = (String) WebGrabber.grab(document, script.toString());
		EnvironmentToolkit.print("testGrabMavePageGetLinks:" + res);

		String[] links = res.split(",");

		assertNotNull("Era esperado um resultado.", res);
		assertTrue("Era esperado no minimo 50 links.", links.length >= 50);

		for (String link : links) {
			assertTrue("Link invalido: " + link,
					(link.indexOf("http") < 0 || link.indexOf("file") < 0));
		}

	}

	/**
	 * @throws Exception
	 */
	public void testGrabMavePageGetBanner() throws Exception {

		URL url = new File(PATH + "WhatisMaven.html").toURL();

		HTMLDocument document = HTMLDocumentFactory.buildDocument(url);

		StringBuffer script = new StringBuffer();
		script.append(" var ret = ''; ");
		script.append(" var banner = document.getElementById('banner'); ");
		script.append(" var bannerImgs = banner.getElementsByTag('img');");
		script.append(" b = bannerImgs[0].getImageURL().split('/'); ");
		script.append(" result = b[b.length - 1]");

		String res = (String) WebGrabber.grab(document, script.toString());
		EnvironmentToolkit.print("testGrabMavePageGetBanner:" + res);

		assertNotNull("Era esperado um resultado.", res);
		assertTrue("Era esperado o banner 'apache-maven-project-2.png' .",
				"apache-maven-project-2.png".equals(res));

	}

	/**
	 * @throws Exception
	 */
	public void testGrabWhatisMavenFullScript() throws Exception {

		URL url = new File(PATH + "WhatisMaven.html").toURL();

		HTMLDocument document = HTMLDocumentFactory.buildDocument(url);

		String res = (String) WebGrabber.grab(document, new File(PATH
				+ "scriptCompletoWhatIsMaven.js"));
		EnvironmentToolkit.print("testGrabWhatisMavenFullScript:" + res);

		assertNotNull("Era esperado um resultado.", res);

		// Validando script
		String[] results = res.split(",");
		for (String result : results) {

			String[] rt = result.split(":");
			assertTrue(rt[1], "true".equalsIgnoreCase(rt[0]));

		}

	}

	/**
	 * @throws Exception
	 */
	public void testGrabInvalidHtml() throws Exception {

		try {

			URL url = new File(PATH + "testGrabInvalidHtml.html").toURL();

			HTMLDocument document = HTMLDocumentFactory.buildDocument(url);

			fail("Era esperado um HTMLParseException, visto que o hml fornecido não esta em um formato valido.");

			String res = (String) WebGrabber
					.grab(
							document,
							"document.getElementById('bannerRight');result = '' + document.getElements().length;");
			EnvironmentToolkit.print("testGrabInvalidHtml:" + res);

			assertNotNull("Era esperado um resultado.", res);

		} catch (HTMLParseException e) {

		}

	}
}
