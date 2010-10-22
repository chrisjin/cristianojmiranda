package br.com.cjm.mega.business.test;

import java.util.Map;

import junit.framework.TestCase;
import br.com.cjm.mega.business.impl.FrequenciaServiceImpl;
import br.com.cjm.mega.business.impl.ResultadosHtmlParseServiceImpl;
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

		FrequenciaServiceImpl service = new FrequenciaServiceImpl();
		service.processarFrequencias();

	}

	/**
	 * Teste para carregar a base de frequencias de duplas
	 */
	public void testCarregarFrequenciasDuplas() {

		FrequenciaServiceImpl service = new FrequenciaServiceImpl();
		Map<Integer, FrequenciaDuplasTO> frequencias = service
				.criarFrequenciaDuplas(false);
		service.processarFrequenciaDuplas(null, frequencias);
	}

	/**
	 * Teste para carregar a base de frequencias de trincas
	 */
	public void testCarregarFrequenciasTrincas() {

		FrequenciaServiceImpl service = new FrequenciaServiceImpl();
		Map<Integer, FrequenciaTrincaTO> frequencias = service
				.criarFrequenciaTrincas(false);
		service.processarFrequenciaTrincas(null, frequencias);
	}

	/**
	 * Teste para carregar a base de frequencias de trincas
	 */
	public void testCarregarFrequenciasQuadras() {

		FrequenciaServiceImpl service = new FrequenciaServiceImpl();
		Map<Integer, FrequenciaQuadraTO> frequencias = service
				.criarFrequenciaQuadra(false);
		service.processarFrequenciaQuadras(null, frequencias);
	}

	/**
	 * Teste para importar a base de frequencias e sorteios
	 */
	public void testImportarResultadosHtml() {

		ResultadosHtmlParseServiceImpl service = new ResultadosHtmlParseServiceImpl();
		service.importarResultadosHtml("classpath:D_MEGA2.HTM");

	}

}
