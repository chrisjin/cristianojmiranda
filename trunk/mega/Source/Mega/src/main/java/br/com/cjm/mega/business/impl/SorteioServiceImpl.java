package br.com.cjm.mega.business.impl;

import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;
import java.util.Date;

import org.apache.commons.lang.StringUtils;
import org.hibernate.classic.Session;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.JDOMException;
import org.jdom.input.SAXBuilder;

import br.com.cjm.mega.datatype.ConcursoTO;
import br.com.cjm.mega.datatype.DezenaKey;
import br.com.cjm.mega.datatype.DezenaTO;
import br.com.cjm.mega.persistence.HibernateUtil;
import br.com.cjm.mega.util.MegaUtil;

/**
 * @author Cristiano
 * 
 */
public class SorteioServiceImpl {

	/**
	 * Instancia do serviço
	 */
	private static SorteioServiceImpl instance;

	private SorteioServiceImpl() {

	}

	/**
	 * Obtem a instancia do serviço
	 * 
	 * @return
	 */
	public static SorteioServiceImpl getInstance() {

		if (instance == null)
			instance = new SorteioServiceImpl();

		return instance;
	}

	/**
	 * Processa o ultimo sorteio
	 * 
	 * @throws MalformedURLException
	 * @throws JDOMException
	 * @throws IOException
	 */
	public void procesarSorteioOnline(Long idConcurso)
			throws MalformedURLException, JDOMException, IOException {

		SAXBuilder builder = new SAXBuilder();
		Document document = null;

		if (idConcurso != null && idConcurso.intValue() > 0) {

			document = builder.build(new URL(
					"http://webservice.claudiomedeiros.net/loterias/megasena/"
							+ idConcurso + ".xml"));

		} else {

			document = builder
					.build(new URL(
							"http://webservice.claudiomedeiros.net/loterias/megasena.xml"));

		}

		// Executa o parse do concurso
		ConcursoTO concurso = obtemConcursoRemoto(document);

		// Caso tenha conseguido fazer parse do concurso
		if (concurso != null) {

			// Obtem a sessão hibernate
			Session session = HibernateUtil.getSessionFactory().openSession();

			// Abre a transação
			session.beginTransaction();

			// Salva o concurso
			session.save(concurso);

			// Comita a sessão
			session.getTransaction().commit();

		}

	}

	/**
	 * Faz o parse do concurso remoto
	 * 
	 * @param document
	 * @return
	 */
	@SuppressWarnings("deprecation")
	private ConcursoTO obtemConcursoRemoto(Document document) {

		ConcursoTO concurso = new ConcursoTO();
		concurso.setId(new Long(((Element) ((Element) document.getContent(0))
				.getContent(1)).getContent(1).getValue()));

		concurso.setDtSorteio(new Date(((Element) ((Element) document
				.getContent(0)).getContent(1)).getContent(5).getValue()));

		String vrTotalArrecadado = ((Element) ((Element) document.getContent(0))
				.getContent(1)).getContent(9).getValue();

		concurso.setVrArrecadacao(new Float(0));
		if (!MegaUtil.isNullOrBlack(vrTotalArrecadado)) {
			concurso.setVrArrecadacao(new Float(vrTotalArrecadado));
		}

		concurso.setQtGanhadoresSena(new Integer(
				StringUtils.remove(((Element) ((Element) ((Element) document
						.getContent(0)).getContent(3)).getContent(1))
						.getContent(1).getValue(), '.')));

		concurso.setVrRateioSena(new Float(
				StringUtils
						.remove(
								((Element) ((Element) ((Element) document
										.getContent(0)).getContent(3))
										.getContent(1)).getContent(3)
										.getValue(), '.').replace(',', '.')));

		concurso.setQtGanhadoresQuina(new Integer(
				StringUtils.remove(((Element) ((Element) ((Element) document
						.getContent(0)).getContent(3)).getContent(2))
						.getContent(1).getValue(), '.')));

		concurso.setVrRateioQuina(new Float(
				StringUtils
						.remove(
								((Element) ((Element) ((Element) document
										.getContent(0)).getContent(3))
										.getContent(2)).getContent(3)
										.getValue(), '.').replace(',', '.')));

		concurso.setQtGanhadoresQuadra(new Integer(
				StringUtils.remove(((Element) ((Element) ((Element) document
						.getContent(0)).getContent(3)).getContent(3))
						.getContent(1).getValue(), '.')));

		concurso.setVrRateioQuadra(new Float(
				StringUtils
						.remove(
								((Element) ((Element) ((Element) document
										.getContent(0)).getContent(3))
										.getContent(3)).getContent(3)
										.getValue(), '.').replace(',', '.')));

		String vrAcumuladoNatal = ((Element) ((Element) ((Element) document
				.getContent(0)).getContent(5))).getContent(1).getValue();
		concurso.setVrAcumuladoNatal(new Float(0));
		if (!MegaUtil.isNullOrBlack(vrAcumuladoNatal)) {
			concurso.setVrAcumuladoNatal(new Float(StringUtils.remove(
					vrAcumuladoNatal, '.').replace(',', '.')));
		}

		String vrAcumulado = StringUtils.remove(
				((Element) ((Element) document.getContent(0)).getContent(1))
						.getContent(3).getValue(), '.').replace(',', '.');
		concurso.setFlAcumulado(Boolean.FALSE);
		if (!MegaUtil.isNullOrBlack(vrAcumulado)
				&& StringUtils.isNumeric(vrAcumulado)) {

			Float vrFloatAcumulado = new Float(vrAcumulado);

			if (vrFloatAcumulado.floatValue() > 0) {
				concurso.setFlAcumulado(true);
			}
		}

		// Obtem as dezenas
		concurso.setDezenas(new ArrayList<DezenaTO>(6));
		for (int i = 1; i <= 11; i = i + 2) {

			DezenaTO dezena = new DezenaTO();
			dezena.setId(new DezenaKey());
			dezena.getId().setIdConcurso(concurso.getId());
			dezena.getId().setNuOrdem(concurso.getDezenas().size() + 1);
			dezena.setVrDezena(new Integer(((Element) ((Element) document
					.getContent(0)).getContent(2)).getContent(i).getValue()));
			concurso.getDezenas().add(dezena);

		}

		return concurso;
	}
}
