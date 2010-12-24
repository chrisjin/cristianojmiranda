package br.com.cjm.mega.business.test;

import java.io.IOException;
import java.net.MalformedURLException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import junit.framework.TestCase;

import org.apache.log4j.Logger;
import org.jdom.JDOMException;

import br.com.cjm.mega.business.impl.FrequenciaServiceImpl;
import br.com.cjm.mega.business.impl.ResultadosHtmlParseServiceImpl;
import br.com.cjm.mega.business.impl.SorteioServiceImpl;
import br.com.cjm.mega.datatype.ConcursoTO;
import br.com.cjm.mega.datatype.FrequenciaDezenasTO;
import br.com.cjm.mega.datatype.FrequenciaDuplasTO;
import br.com.cjm.mega.datatype.FrequenciaQuadraTO;
import br.com.cjm.mega.datatype.FrequenciaTrincaTO;

/**
 * Testes unitarios
 * 
 * @author Cristiano
 * 
 */
public class ResultadosHtmlParseServiceTest extends TestCase {

	public Logger log = Logger.getLogger(ResultadosHtmlParseServiceTest.class);

	/**
	 * Teste para carregar a base de frequencias por dezenas
	 */
	public void testCarregarFrequencias() {

		Map<Integer, FrequenciaDezenasTO> frequencias = FrequenciaServiceImpl
				.getInstance().criarFrequencia(false);
		FrequenciaServiceImpl.getInstance().processarFrequencia(null,
				frequencias);

	}

	/**
	 * Teste para carregar a base de frequencias de duplas
	 */
	public void testCarregarFrequenciasDuplas() {

		Map<Integer, FrequenciaDuplasTO> frequencias = FrequenciaServiceImpl
				.getInstance().criarFrequenciaDuplas(false);
		FrequenciaServiceImpl.getInstance().processarFrequenciaDuplas(null,
				frequencias);
	}

	/**
	 * Teste para carregar a base de frequencias de trincas
	 */
	public void testCarregarFrequenciasTrincas() {

		Map<Integer, FrequenciaTrincaTO> frequencias = FrequenciaServiceImpl
				.getInstance().criarFrequenciaTrincas(false);
		FrequenciaServiceImpl.getInstance().processarFrequenciaTrincas(null,
				frequencias);
	}

	/**
	 * Teste para carregar a base de frequencias de trincas
	 */
	public void testCarregarFrequenciasQuadras() {

		Map<Integer, FrequenciaQuadraTO> frequencias = FrequenciaServiceImpl
				.getInstance().criarFrequenciaQuadra(false);
		FrequenciaServiceImpl.getInstance().processarFrequenciaQuadras(null,
				frequencias);
	}

	/**
	 * Teste para carregar a base de frequencias de quinas
	 */
	public void testCarregarFrequenciasQuinas() {

		// FrequenciaServiceImpl.getInstance().criarFrequenciaQuina();
		FrequenciaServiceImpl.getInstance().processarFrequenciaQuina(null);
	}

	/**
	 * Teste para importar a base de frequencias e sorteios
	 */
	public void testImportarResultadosHtml() {

		ResultadosHtmlParseServiceImpl service = new ResultadosHtmlParseServiceImpl();
		service.importarResultadosHtml("classpath:D_MEGA2.HTM");

	}

	public void testProcessarSorteio() throws MalformedURLException,
			JDOMException, IOException {

		SorteioServiceImpl.getInstance().procesarSorteioOnline(1L, false);

	}

	/**
	 * Teste Cenario 1 Cobertura: 9.0% [105:7:0]
	 * 
	 */
	public void testApostaCenario1() {

		List<Set<Integer>> apostas = new ArrayList<Set<Integer>>();

		// Quadras que mais sairam (n3), completada com as duplas que mais
		// sairam

		apostas.add(makeApostaList(30, 38, 46, 59, 5, 33));
		apostas.add(makeApostaList(11, 21, 30, 52, 5, 33));
		apostas.add(makeApostaList(33, 40, 41, 59, 5, 9));
		apostas.add(makeApostaList(23, 30, 49, 55, 5, 33));
		apostas.add(makeApostaList(5, 11, 38, 53, 33, 9));

		// Quadras que mais sairam (n2),

		apostas.add(makeApostaList(8, 39, 43, 52, 5, 33));
		apostas.add(makeApostaList(25, 30, 46, 51, 5, 33));
		apostas.add(makeApostaList(27, 29, 40, 56, 5, 33));
		apostas.add(makeApostaList(8, 40, 43, 49, 5, 33));
		apostas.add(makeApostaList(8, 27, 53, 56, 5, 33));
		apostas.add(makeApostaList(25, 32, 33, 43, 5, 9));
		apostas.add(makeApostaList(8, 41, 53, 56, 5, 33));
		apostas.add(makeApostaList(5, 6, 19, 39, 9, 33));
		apostas.add(makeApostaList(28, 38, 41, 57, 5, 33));
		apostas.add(makeApostaList(5, 6, 23, 39, 9, 41));
		apostas.add(makeApostaList(8, 28, 32, 38, 5, 33));
		apostas.add(makeApostaList(6, 9, 11, 18, 5, 33));
		apostas.add(makeApostaList(28, 43, 52, 56, 9, 41));
		apostas.add(makeApostaList(28, 43, 51, 56, 9, 41));
		apostas.add(makeApostaList(16, 20, 33, 60, 5, 33));
		apostas.add(makeApostaList(7, 31, 34, 37, 33, 41));
		apostas.add(makeApostaList(6, 7, 12, 24, 5, 41));
		apostas.add(makeApostaList(6, 7, 28, 35, 39, 49));
		apostas.add(makeApostaList(7, 32, 38, 51, 17, 33));
		apostas.add(makeApostaList(5, 14, 33, 44, 18, 52));
		apostas.add(makeApostaList(8, 20, 26, 42, 5, 33));
		apostas.add(makeApostaList(7, 8, 35, 53, 5, 33));
		apostas.add(makeApostaList(7, 8, 30, 32, 5, 33));
		apostas.add(makeApostaList(7, 8, 18, 39, 5, 33));
		apostas.add(makeApostaList(7, 8, 18, 43, 5, 41));
		apostas.add(makeApostaList(17, 34, 47, 56, 5, 41));
		apostas.add(makeApostaList(6, 25, 32, 49, 5, 33));
		apostas.add(makeApostaList(8, 19, 30, 50, 5, 33));
		apostas.add(makeApostaList(7, 9, 17, 32, 5, 41));
		apostas.add(makeApostaList(6, 23, 28, 35, 5, 33));
		apostas.add(makeApostaList(6, 23, 39, 51, 5, 41));
		apostas.add(makeApostaList(6, 23, 35, 41, 5, 33));
		apostas.add(makeApostaList(7, 9, 44, 60, 5, 33));
		apostas.add(makeApostaList(5, 12, 15, 29, 9, 41));
		apostas.add(makeApostaList(40, 43, 46, 54, 5, 33));
		apostas.add(makeApostaList(5, 17, 33, 39, 9, 41));
		apostas.add(makeApostaList(8, 23, 34, 52, 9, 5));
		apostas.add(makeApostaList(5, 17, 20, 32, 9, 41));
		apostas.add(makeApostaList(6, 28, 43, 51, 5, 41));
		apostas.add(makeApostaList(6, 28, 43, 56, 5, 33));
		apostas.add(makeApostaList(5, 16, 20, 30, 9, 33));
		apostas.add(makeApostaList(5, 16, 18, 22, 9, 41));
		apostas.add(makeApostaList(5, 16, 43, 56, 9, 41));
		apostas.add(makeApostaList(25, 28, 41, 57, 5, 33));
		apostas.add(makeApostaList(5, 15, 26, 33, 41, 9));

		assertTrue("Lista deve conter 50 apostas", apostas.size() == 50);
		SorteioServiceImpl.getInstance().processarCenario(apostas, null);

	}

	/**
	 * Teste Cenario 2 Cobertura: 41.0% [476:29:2]
	 * 
	 */
	public void testApostaCenario2() {

		List<Set<Integer>> apostas = SorteioServiceImpl.getInstance()
				.obtemApostasParaQuadra();

		SorteioServiceImpl.getInstance().processarCenario(apostas, null);

	}

	/**
	 * Teste Cenario 3 Cobertura: 24.0% [277:17:2]
	 * 
	 */
	public void testApostaCenario3() {

		List<Set<Integer>> apostas = SorteioServiceImpl.getInstance()
				.obtemApostasParaQuadra();

		SorteioServiceImpl.getInstance().processarCenario(
				apostas.subList(0, 1000), null);

	}

	/**
	 * Teste Cenario 2 Cobertura: 41.0% [476:29:2]
	 * 
	 * @throws IOException
	 * @throws JDOMException
	 * @throws MalformedURLException
	 * 
	 */
	public void testApostaCenario4() throws MalformedURLException,
			JDOMException, IOException {

		List<Set<Integer>> apostas = SorteioServiceImpl.getInstance()
				.obtemApostasParaQuadra();

		Long ultimoConcurso = 1211L;// SorteioServiceImpl.getInstance().obtemUltimoConcurso();

		List<ConcursoTO> concursos = new ArrayList<ConcursoTO>();
		ConcursoTO ultimoConcursoRemoto = SorteioServiceImpl.getInstance()
				.procesarSorteioOnline(null, false);

		for (long i = (ultimoConcurso + 1); i < ultimoConcursoRemoto.getId(); i++) {

			concursos.add(SorteioServiceImpl.getInstance()
					.procesarSorteioOnline(i, false));

		}
		concursos.add(ultimoConcursoRemoto);

		SorteioServiceImpl.getInstance().processarCenario(apostas, concursos);

	}

	/**
	 * Teste Cenario 5
	 * 
	 * @throws IOException
	 * @throws JDOMException
	 * @throws MalformedURLException
	 * 
	 */
	public void testApostaCenario5() throws MalformedURLException,
			JDOMException, IOException {

		List<Set<Integer>> apostas = SorteioServiceImpl.getInstance()
				.obtemApostasParaQuadraNaoSorteados();

		Long ultimoConcurso = 1211L;

		List<ConcursoTO> concursos = new ArrayList<ConcursoTO>();
		ConcursoTO ultimoConcursoRemoto = SorteioServiceImpl.getInstance()
				.procesarSorteioOnline(null, false);

		for (long i = (ultimoConcurso + 1); i < ultimoConcursoRemoto.getId(); i++) {

			concursos.add(SorteioServiceImpl.getInstance()
					.procesarSorteioOnline(i, false));

		}
		concursos.add(ultimoConcursoRemoto);

		SorteioServiceImpl.getInstance().processarCenario(apostas, concursos);

	}

	/**
	 * Teste Cenario 5
	 * 
	 * @throws IOException
	 * @throws JDOMException
	 * @throws MalformedURLException
	 * 
	 */
	public void testApostaCenario6() throws MalformedURLException,
			JDOMException, IOException {

		List<Set<Integer>> apostas = new ArrayList<Set<Integer>>();

		// Quadras que mais sairam (n3), completada com as duplas que mais
		// sairam

		apostas.add(makeApostaList(30, 38, 46, 59, 5, 33));
		apostas.add(makeApostaList(11, 21, 30, 52, 5, 33));
		apostas.add(makeApostaList(33, 40, 41, 59, 5, 9));
		apostas.add(makeApostaList(23, 30, 49, 55, 5, 33));
		apostas.add(makeApostaList(5, 11, 38, 53, 33, 9));

		// Quadras que mais sairam (n2),

		apostas.add(makeApostaList(8, 39, 43, 52, 5, 33));
		apostas.add(makeApostaList(25, 30, 46, 51, 5, 33));
		apostas.add(makeApostaList(27, 29, 40, 56, 5, 33));
		apostas.add(makeApostaList(8, 40, 43, 49, 5, 33));
		apostas.add(makeApostaList(8, 27, 53, 56, 5, 33));
		apostas.add(makeApostaList(25, 32, 33, 43, 5, 9));
		apostas.add(makeApostaList(8, 41, 53, 56, 5, 33));
		apostas.add(makeApostaList(5, 6, 19, 39, 9, 33));
		apostas.add(makeApostaList(28, 38, 41, 57, 5, 33));
		apostas.add(makeApostaList(5, 6, 23, 39, 9, 41));
		apostas.add(makeApostaList(8, 28, 32, 38, 5, 33));
		apostas.add(makeApostaList(6, 9, 11, 18, 5, 33));
		apostas.add(makeApostaList(28, 43, 52, 56, 9, 41));
		apostas.add(makeApostaList(28, 43, 51, 56, 9, 41));
		apostas.add(makeApostaList(16, 20, 33, 60, 5, 33));
		apostas.add(makeApostaList(7, 31, 34, 37, 33, 41));
		apostas.add(makeApostaList(6, 7, 12, 24, 5, 41));
		apostas.add(makeApostaList(6, 7, 28, 35, 39, 49));
		apostas.add(makeApostaList(7, 32, 38, 51, 17, 33));
		apostas.add(makeApostaList(5, 14, 33, 44, 18, 52));
		apostas.add(makeApostaList(8, 20, 26, 42, 5, 33));
		apostas.add(makeApostaList(7, 8, 35, 53, 5, 33));
		apostas.add(makeApostaList(7, 8, 30, 32, 5, 33));
		apostas.add(makeApostaList(7, 8, 18, 39, 5, 33));
		apostas.add(makeApostaList(7, 8, 18, 43, 5, 41));
		apostas.add(makeApostaList(17, 34, 47, 56, 5, 41));
		apostas.add(makeApostaList(6, 25, 32, 49, 5, 33));
		apostas.add(makeApostaList(8, 19, 30, 50, 5, 33));
		apostas.add(makeApostaList(7, 9, 17, 32, 5, 41));
		apostas.add(makeApostaList(6, 23, 28, 35, 5, 33));
		apostas.add(makeApostaList(6, 23, 39, 51, 5, 41));
		apostas.add(makeApostaList(6, 23, 35, 41, 5, 33));
		apostas.add(makeApostaList(7, 9, 44, 60, 5, 33));
		apostas.add(makeApostaList(5, 12, 15, 29, 9, 41));
		apostas.add(makeApostaList(40, 43, 46, 54, 5, 33));
		apostas.add(makeApostaList(5, 17, 33, 39, 9, 41));
		apostas.add(makeApostaList(8, 23, 34, 52, 9, 5));
		apostas.add(makeApostaList(5, 17, 20, 32, 9, 41));
		apostas.add(makeApostaList(6, 28, 43, 51, 5, 41));
		apostas.add(makeApostaList(6, 28, 43, 56, 5, 33));
		apostas.add(makeApostaList(5, 16, 20, 30, 9, 33));
		apostas.add(makeApostaList(5, 16, 18, 22, 9, 41));
		apostas.add(makeApostaList(5, 16, 43, 56, 9, 41));
		apostas.add(makeApostaList(25, 28, 41, 57, 5, 33));
		apostas.add(makeApostaList(5, 15, 26, 33, 41, 9));

		Long ultimoConcurso = 1211L;

		List<ConcursoTO> concursos = new ArrayList<ConcursoTO>();
		ConcursoTO ultimoConcursoRemoto = SorteioServiceImpl.getInstance()
				.procesarSorteioOnline(null, false);

		for (long i = (ultimoConcurso + 1); i < ultimoConcursoRemoto.getId(); i++) {

			concursos.add(SorteioServiceImpl.getInstance()
					.procesarSorteioOnline(i, false));

		}
		concursos.add(ultimoConcursoRemoto);

		SorteioServiceImpl.getInstance().processarCenario(apostas, concursos);

	}

	/**
	 * Teste Cenario 7
	 * 
	 */
	public void testApostaCenario7() {

		Set<Integer> dezenas = new HashSet<Integer>();
		dezenas.add(5);
		dezenas.add(41);
		dezenas.add(33);
		dezenas.add(4);
		dezenas.add(17);
		dezenas.add(49);
		dezenas.add(54);
		dezenas.add(42);
		dezenas.add(16);
		dezenas.add(23);
		List<Set<Integer>> apostas = SorteioServiceImpl.getInstance()
				.gerarApostasH6(dezenas);

		SorteioServiceImpl.getInstance().processarCenario(apostas, null);

	}

	/**
	 * Teste Cenario 7
	 * 
	 * @throws IOException
	 * @throws JDOMException
	 * @throws MalformedURLException
	 * 
	 */
	public void testApostaCenario8() throws MalformedURLException,
			JDOMException, IOException {

		Set<Integer> dezenas = new HashSet<Integer>();
		dezenas.add(26);
		dezenas.add(39);
		dezenas.add(22);
		dezenas.add(9);
		dezenas.add(46);
		dezenas.add(2);
		dezenas.add(48);
		dezenas.add(45);
		dezenas.add(11);
		dezenas.add(19);

		dezenas.add(5);
		dezenas.add(41);
		dezenas.add(33);
		dezenas.add(4);
		dezenas.add(17);
		dezenas.add(49);
		dezenas.add(54);
		dezenas.add(42);
		dezenas.add(16);
		dezenas.add(23);
		List<Set<Integer>> apostas = SorteioServiceImpl.getInstance()
				.gerarApostasH6(dezenas);

		Long ultimoConcurso = 1211L;

		List<ConcursoTO> concursos = new ArrayList<ConcursoTO>();
		ConcursoTO ultimoConcursoRemoto = SorteioServiceImpl.getInstance()
				.procesarSorteioOnline(null, false);

		for (long i = (ultimoConcurso + 1); i < ultimoConcursoRemoto.getId(); i++) {

			concursos.add(SorteioServiceImpl.getInstance()
					.procesarSorteioOnline(i, false));

		}
		concursos.add(ultimoConcursoRemoto);

		SorteioServiceImpl.getInstance().processarCenario(apostas, concursos);

	}

	public Set<Integer> makeApostaList(Integer d1, Integer d2, Integer d3,
			Integer d4, Integer d5, Integer d6) {

		Set<Integer> result = new HashSet<Integer>();
		result.add(d1);
		result.add(d2);
		result.add(d3);
		result.add(d4);
		result.add(d5);
		result.add(d6);

		return result;

	}

	public void testLog() {

		log.debug("Teste");

	}

}
