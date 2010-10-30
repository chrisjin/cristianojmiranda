package br.com.cjm.mega.business.test;

import java.io.IOException;
import java.net.MalformedURLException;
import java.util.Map;

import org.jdom.JDOMException;

import junit.framework.TestCase;
import br.com.cjm.mega.business.impl.FrequenciaServiceImpl;
import br.com.cjm.mega.business.impl.ResultadosHtmlParseServiceImpl;
import br.com.cjm.mega.business.impl.SorteioServiceImpl;
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

		SorteioServiceImpl.getInstance().procesarUltimoSorteio();

	}

}
