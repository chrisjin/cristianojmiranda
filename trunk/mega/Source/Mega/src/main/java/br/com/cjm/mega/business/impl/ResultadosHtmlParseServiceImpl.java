package br.com.cjm.mega.business.impl;

import java.io.File;
import java.util.Date;
import java.util.Iterator;

import org.apache.commons.lang.StringUtils;
import org.hibernate.classic.Session;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.input.SAXBuilder;

import br.com.cjm.mega.datatype.ConcursoTO;
import br.com.cjm.mega.datatype.DezenaKey;
import br.com.cjm.mega.datatype.DezenaTO;
import br.com.cjm.mega.persistence.HibernateUtil;

public class ResultadosHtmlParseServiceImpl {

	/*
	 * select d.vrDezena, count(d.vrDezena) as "ocorrencia" from mega.tbdezenas
	 * d group by d.vrDezena order by ocorrencia desc;
	 */

	/**
	 * Importa os resultados da planilha de html.
	 * 
	 * @param fileName
	 */
	public void importarResultadosHtml(String fileName) {

		try {

			SAXBuilder builder = new SAXBuilder();
			Document document = builder.build(new File(fileName));

			Element content = (Element) document.getContent(0);
			Iterator it = content.getContent().iterator();
			while (it.hasNext()) {

				Object obj = it.next();
				if (obj instanceof Element) {

					// Instancia um novo concurso a ser persistido
					ConcursoTO concurso = new ConcursoTO();

					Element e = (Element) obj;
					Iterator it2 = e.getContent().iterator();
					int index = 0;
					int nuOrdem = 1;
					while (it2.hasNext()) {

						Object obj2 = it2.next();
						if (obj2 instanceof Element) {

							Element e2 = (Element) obj2;

							switch (index) {

							case 0:
								concurso.setId(new Long(e2.getValue()));
								break;
							case 1:
								concurso.setDtSorteio(new Date(e2.getValue()));
								break;

							case 8:

								concurso.setVrArrecadacao(convertToFloat(e2
										.getValue()));
								break;

							case 9:
								concurso.setQtGanhadoresSena(new Integer(e2
										.getValue()));
								break;

							case 10:
								concurso.setVrRateioSena(convertToFloat(e2
										.getValue()));
								break;

							case 11:
								concurso.setQtGanhadoresQuina(new Integer(e2
										.getValue()));
								break;

							case 12:
								concurso.setVrRateioQuina(convertToFloat(e2
										.getValue()));
								break;

							case 13:
								concurso.setQtGanhadoresQuadra(new Integer(e2
										.getValue()));
								break;

							case 14:
								concurso.setVrRateioQuadra(convertToFloat(e2
										.getValue()));
								break;

							case 15:
								if ("sim".equalsIgnoreCase(e2.getValue())) {
									concurso.setFlAcumulado(Boolean.TRUE);
								}
								break;

							case 16:
								concurso
										.setVrEstimativaPremio(convertToFloat(e2
												.getValue()));
								break;

							case 17:
								concurso.setVrAcumuladoNatal(convertToFloat(e2
										.getValue()));
								break;

							default:

								if (index >= 2 && index <= 7) {

									DezenaTO dezena = new DezenaTO();
									dezena.setId(new DezenaKey());
									dezena.getId().setIdConcurso(
											concurso.getId());
									dezena.getId().setNuOrdem(nuOrdem++);
									dezena.setVrDezena(new Integer(e2
											.getValue()));
									concurso.getDezenas().add(dezena);

								}

								break;
							}

							index++;

						}

					}

					// Obtem a sessão hibernate
					Session session = HibernateUtil.getSessionFactory()
							.openSession();

					// Abre a transação
					session.beginTransaction();

					// Salva o concurso
					session.save(concurso);

					// Comita a sessão
					session.getTransaction().commit();

				}

			}

		} catch (Exception e) {

			e.printStackTrace();

		}

	}

	private Float convertToFloat(String value) {

		if (value != null && value.trim().length() > 0) {

			value = StringUtils.remove(value, ".");
			value = StringUtils.replace(value, ",", ".");
			return new Float(value);
		}

		return null;

	}
}
