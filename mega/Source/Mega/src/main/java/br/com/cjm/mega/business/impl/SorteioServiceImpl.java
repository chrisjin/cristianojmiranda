package br.com.cjm.mega.business.impl;

import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.lang.StringUtils;
import org.hibernate.Query;
import org.hibernate.classic.Session;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.JDOMException;
import org.jdom.input.SAXBuilder;

import br.com.cjm.mega.datatype.ConcursoTO;
import br.com.cjm.mega.datatype.DezenaKey;
import br.com.cjm.mega.datatype.DezenaTO;
import br.com.cjm.mega.datatype.FrequenciaQuadraTO;
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
	public ConcursoTO procesarSorteioOnline(Long idConcurso, Boolean save)
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
		if (concurso != null && save) {

			// Obtem a sessão hibernate
			Session session = HibernateUtil.getSessionFactory().openSession();

			// Abre a transação
			session.beginTransaction();

			// Salva o concurso
			session.save(concurso);

			// Comita a sessão
			session.getTransaction().commit();

		}

		return concurso;

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

		vrTotalArrecadado = StringUtils.remove(vrTotalArrecadado, '.').replace(
				',', '.');

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

	/**
	 * @throws MalformedURLException
	 * @throws JDOMException
	 * @throws IOException
	 */
	public void processarSorteios() throws MalformedURLException,
			JDOMException, IOException {

		// Obtem o ultimo sorteio processado
		Long ultimoConcProcess = obtemUltimoConcurso();

		// Obtem o ultimo concurso online
		ConcursoTO concOnline = procesarSorteioOnline(null, false);

		// Caso a base esteja desatualizada
		if (concOnline != null && concOnline.getId() > ultimoConcProcess) {

			for (long i = ultimoConcProcess.longValue() + 1; i <= concOnline
					.getId(); i++) {

				procesarSorteioOnline(i, true);

			}

		} else if (concOnline != null
				&& !concOnline.getId().equals(ultimoConcProcess)) {

			procesarSorteioOnline(null, true);

		}

	}

	/**
	 * Obtem o ultimo concurso processado
	 * 
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public Long obtemUltimoConcurso() {

		// Obtem a sessão hibernate
		Session session = HibernateUtil.getSessionFactory().openSession();

		List<Object> result = session.createQuery(" max(id) from ConcursoTO")
				.list();

		if (result != null && !result.isEmpty()) {

			return (Long) result.get(0);
		}

		return -1L;

	}

	@SuppressWarnings("unchecked")
	public void processarCenario(List<Set<Integer>> apostas,
			List<ConcursoTO> concuros) {

		// Obtem a sessão hibernate
		Session session = HibernateUtil.getSessionFactory().openSession();

		// Obtem os concursos
		if (concuros == null || concuros.isEmpty()) {
			concuros = session.createQuery("from ConcursoTO order by id")
					.list();
		}

		Set<Long> concursosGanhadores = new HashSet<Long>();
		int senaTotalCount = 0;
		int quinaTotalCount = 0;
		int quadraTotalCount = 0;

		float vrAposta = 2;
		float gasto = 0;
		float premio = 0;

		Map<Set<Integer>, Integer> mapStAposta = new HashMap<Set<Integer>, Integer>();

		for (ConcursoTO concurso : concuros) {

			gasto = gasto + (vrAposta * apostas.size());

			int senaCount = 0;
			int quinaCount = 0;
			int quadraCount = 0;

			System.out.println("-------------------------------------------");
			System.out.println("Processando concurso: " + concurso.getId());

			for (Set<Integer> apostaList : apostas) {

				// System.out.print("Aposta: [");
				// printAposta(apostaList);
				// System.out.println("]");

				Integer pontos = concurso
						.verificarPontuacaoConcurso(apostaList);

				if (pontos >= 4) {

					concursosGanhadores.add(concurso.getId());

					if (mapStAposta.containsKey(apostaList)) {
						Integer ct = mapStAposta.get(apostaList);
						ct++;
						mapStAposta.put(apostaList, ct);
					} else {

						mapStAposta.put(apostaList, 1);
					}

					switch (pontos) {

					case 4:
						premio = premio + concurso.getVrRateioQuadra();
						System.out.println("Pontos $$$ Quadra");
						quadraCount++;
						quadraTotalCount++;
						break;

					case 5:
						premio = premio + concurso.getVrRateioQuina();
						System.out.println("Pontos $$$ Quina");
						quinaCount++;
						quinaTotalCount++;
						break;

					case 6:
						premio = premio + concurso.getVrRateioSena();
						System.out.println("Pontos $$$ SENA !");
						senaCount++;
						senaTotalCount++;
						break;

					default:
						break;
					}

				}

			}

			System.out.println("Quadras: " + quadraCount + ", Quinas: "
					+ quinaCount + ", Senas: " + senaCount);

		}

		System.out.println("Cobertura: "
				+ (float) (concursosGanhadores.size() * 100 / concuros.size())
				+ "%");
		System.out.println("[" + quadraTotalCount + ":" + quinaTotalCount + ":"
				+ senaTotalCount + ":" + mapStAposta.size() + "]");

		long tmpIntervalo = -1;
		long maiorIntervalo = 0;
		System.out.println("Concursos ganhadores: ");
		List<Long> concursosGanhadoresSortList = new ArrayList<Long>(
				concursosGanhadores);
		Collections.sort(concursosGanhadoresSortList);

		for (Long cg : concursosGanhadoresSortList) {
			System.out.print(cg + ", ");

			if (tmpIntervalo < 0) {

				tmpIntervalo = cg;

			} else {

				if ((cg - tmpIntervalo > maiorIntervalo)) {

					maiorIntervalo = cg - tmpIntervalo;

				}

				tmpIntervalo = cg;

			}

		}

		System.out.println("\nMaior intervalo: " + maiorIntervalo);
		System.out.println("Lucro[" + gasto + "|" + premio + "|"
				+ (premio - gasto) + "]");

	}

	public void printAposta(List<Integer> aposta) {

		if (aposta != null) {

			for (int i = 0; i < aposta.size(); i++) {
				System.out.print(aposta.get(i));
				if (i != aposta.size() - 2) {
					System.out.print(", ");
				}
			}

		}

	}

	@SuppressWarnings("unchecked")
	public List<Set<Integer>> obtemApostasParaQuadra() {

		List<Set<Integer>> result = new ArrayList<Set<Integer>>();

		// Obtem a sessão hibernate
		Session session = HibernateUtil.getSessionFactory().openSession();

		// Obtem os concursos
		List<FrequenciaQuadraTO> quadras = session
				.createQuery(
						"from FrequenciaQuadraTO where qtdSOrteada > 1 order by qtdSorteada desc, dezena1, dezena2, dezena3")
				.list();

		List<Set<Integer>> quadraList = new ArrayList<Set<Integer>>();
		for (FrequenciaQuadraTO f : quadras) {

			quadraList.add(f.obterDezenas());

		}

		List<Set<Integer>> deleteList = new ArrayList<Set<Integer>>();
		for (Set<Integer> q1 : quadraList) {

			for (Set<Integer> q2 : quadraList) {

				if (!q1.equals(q2) && !deleteList.contains(q2)) {

					List<Integer> merge = mergeQuadraIncomum(q1, q2);
					if (merge.size() == 4) {

						q1.addAll(merge);
						deleteList.add(q2);

					}

				}

				// Caso a lista já esteja completa
				if (q1.size() == 6) {
					break;
				}

			}

			if (q1.size() == 6) {
				result.add(q1);
			} else {
				deleteList.add(q1);
			}

		}

		return result;

	}

	@SuppressWarnings("unchecked")
	public List<Set<Integer>> obtemApostasParaQuadraNaoSorteados() {

		List<Set<Integer>> result = new ArrayList<Set<Integer>>();

		// Obtem a sessão hibernate
		Session session = HibernateUtil.getSessionFactory().openSession();

		// Obtem os concursos
		Query query = session
				.createQuery("from FrequenciaQuadraTO where qtdSOrteada = 0 order by qtdSorteada desc, dezena1, dezena2, dezena3");

		query.setMaxResults(1000);
		query.setFirstResult(1000);

		List<FrequenciaQuadraTO> quadras = query.list();

		List<Set<Integer>> quadraList = new ArrayList<Set<Integer>>();
		for (FrequenciaQuadraTO f : quadras) {

			quadraList.add(f.obterDezenas());

		}

		List<Set<Integer>> deleteList = new ArrayList<Set<Integer>>();
		for (Set<Integer> q1 : quadraList) {

			for (Set<Integer> q2 : quadraList) {

				if (!q1.equals(q2) && !deleteList.contains(q2)) {

					List<Integer> merge = mergeQuadraIncomum(q1, q2);
					if (merge.size() == 4) {

						q1.addAll(merge);
						deleteList.add(q2);

					}

				}

				// Caso a lista já esteja completa
				if (q1.size() == 6) {
					break;
				}

			}

			if (q1.size() == 6) {
				result.add(q1);
			} else {
				deleteList.add(q1);
			}

		}

		return result;

	}

	/**
	 * @param l1
	 * @param l2
	 * @return
	 */
	public List<Integer> mergeQuadraIncomum(Set<Integer> l1, Set<Integer> l2) {

		List<Integer> tmp1 = new ArrayList<Integer>(l1);
		List<Integer> tmp2 = new ArrayList<Integer>(l2);

		tmp1.removeAll(l2);
		tmp2.removeAll(l1);

		tmp1.addAll(tmp2);

		Collections.sort(tmp1);

		return tmp1;

	}

	public List<Set<Integer>> gerarApostasH6(Set<Integer> dezenas) {

		Set<Set<Integer>> apostas = new HashSet<Set<Integer>>();

		if (dezenas == null || dezenas.size() < 6) {

			return null;
		}

		for (int i = 0; i < dezenas.size(); i++) {

			for (int j = i + 1; j < dezenas.size(); j++) {

				for (int k = j + 1; k < dezenas.size(); k++) {

					for (int l = k + 1; l < dezenas.size(); l++) {

						for (int m = l + 1; m < dezenas.size(); m++) {

							for (int n = m + 1; n < dezenas.size(); n++) {

								Set<Integer> a = new HashSet<Integer>(6);
								a.add((Integer) dezenas.toArray()[i]);
								a.add((Integer) dezenas.toArray()[j]);
								a.add((Integer) dezenas.toArray()[k]);
								a.add((Integer) dezenas.toArray()[l]);
								a.add((Integer) dezenas.toArray()[m]);
								a.add((Integer) dezenas.toArray()[n]);

								if (a.size() == 6) {
									apostas.add(a);
								}

							}

						}

					}

				}
			}

		}

		return new ArrayList<Set<Integer>>(apostas);

	}
}
