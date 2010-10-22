package br.com.cjm.mega.business.impl;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.hibernate.Query;
import org.hibernate.classic.Session;

import br.com.cjm.mega.datatype.ConcursoTO;
import br.com.cjm.mega.datatype.DezenaTO;
import br.com.cjm.mega.datatype.FrequenciaDezenasTO;
import br.com.cjm.mega.datatype.FrequenciaDuplasTO;
import br.com.cjm.mega.datatype.FrequenciaTrincaTO;
import br.com.cjm.mega.persistence.HibernateUtil;

public class FrequenciaServiceImpl {

	/**
	 * Gera a chave para um dupla de dezenas
	 * 
	 * @param d1
	 * @param d2
	 * @return
	 */
	public Integer generateDuplaKey(int d1, int d2) {

		return new Integer((d1 * 100) + d2);

	}

	/**
	 * Gera a chave para um dupla de dezenas
	 * 
	 * @param d1
	 * @param d2
	 * @return
	 */
	public Integer generateTrincaKey(int d1, int d2, int d3) {

		return new Integer((d1 * 10000) + (d2 * 100) + d3);

	}

	/**
	 * Gera a chave para um dupla de dezenas
	 * 
	 * @param d1
	 * @param d2
	 * @return
	 */
	public Integer generateQuadraKey(int d1, int d2, int d3, int d4) {

		return new Integer((d1 * 1000000) + (d2 * 10000) + (d3 * 100) + d4);

	}

	/**
	 * Gera a chave para um dupla de dezenas
	 * 
	 * @param d1
	 * @param d2
	 * @return
	 */
	public Integer generateQuinaKey(int d1, int d2, int d3, int d4, int d5) {

		return new Integer((d1 * 100000000) + (d2 * 1000000) + (d3 * 10000)
				+ (d4 * 100) + d5);

	}

	/**
	 * Cria a lista de frequencias duplas
	 * 
	 */
	public Map<Integer, FrequenciaDuplasTO> criarFrequenciaDuplas(
			boolean dbIntegration) {

		// Map de resultados
		Map<Integer, FrequenciaDuplasTO> resultMap = new HashMap<Integer, FrequenciaDuplasTO>();

		Session session = null;
		if (dbIntegration) {
			// Obtem a sessão hibernate
			session = HibernateUtil.getSessionFactory().openSession();
		}

		try {

			if (dbIntegration) {
				session.beginTransaction();

				// Apaga todas as frequencias
				session.createQuery("delete FrequenciaDuplasTO")
						.executeUpdate();
			}

			for (int i = 1; i <= 60; i++) {

				for (int j = 1; j <= 60; j++) {

					if (i != j && j > i) {

						// Monta a frequencia
						FrequenciaDuplasTO freqDupla = new FrequenciaDuplasTO();
						freqDupla.setDezena1(i);
						freqDupla.setDezena2(j);

						// Adiciona a frequencia na map de saida
						resultMap.put(generateDuplaKey(i, j), freqDupla);

						if (dbIntegration) {
							session.save(freqDupla);
							session.flush();
						}

					}

				}

			}

			if (dbIntegration) {
				session.getTransaction().commit();
			}

			return resultMap;

		} catch (Exception e) {
			e.printStackTrace();
		}

		return null;

	}

	/**
	 * Cria a lista de frequencias de trincas
	 * 
	 */
	public Map<Integer, FrequenciaTrincaTO> criarFrequenciaTrincas(
			boolean dbIntegration) {

		// Map de resultados
		Map<Integer, FrequenciaTrincaTO> resultMap = new HashMap<Integer, FrequenciaTrincaTO>();

		Session session = null;
		if (dbIntegration) {
			// Obtem a sessão hibernate
			session = HibernateUtil.getSessionFactory().openSession();
		}

		try {

			if (dbIntegration) {
				session.beginTransaction();

				// Apaga todas as frequencias
				session.createQuery("delete FrequenciaTrincaTO")
						.executeUpdate();
			}

			for (int i = 1; i <= 60; i++) {

				for (int j = 1; j <= 60; j++) {

					for (int k = 1; k <= 60; k++) {

						// Mantem a ordem crescente das dezenas na chave da
						// trinca
						if (i != j && k != j && k != i && j > i && k > j) {

							// Monta a frequencia
							FrequenciaTrincaTO freq = new FrequenciaTrincaTO();
							freq.setDezena1(i);
							freq.setDezena2(j);
							freq.setDezena3(k);

							// Adiciona a frequencia na map de saida
							resultMap.put(generateTrincaKey(i, j, k), freq);

							if (dbIntegration) {
								session.save(freq);
								session.flush();
							}

						}
					}

				}

			}

			if (dbIntegration) {
				session.getTransaction().commit();
			}

			return resultMap;

		} catch (Exception e) {
			e.printStackTrace();
		}

		return null;

	}

	/**
	 * Processa as duplas.
	 * 
	 * @param concuros
	 */
	@SuppressWarnings("unchecked")
	public void processarFrequenciaDuplas(List<ConcursoTO> concuros,
			Map<Integer, FrequenciaDuplasTO> frequencias) {

		// Obtem a sessão hibernate
		Session session = HibernateUtil.getSessionFactory().openSession();

		// Obtem os concursos
		if (concuros == null || concuros.isEmpty()) {
			concuros = session.createQuery("from ConcursoTO order by id")
					.list();
		}

		int counter = 1;
		for (ConcursoTO concurso : concuros) {

			System.out.println("\n\n\n\n\n\n\n\nPROCESSANDO CONCURSO "
					+ counter + " DE " + concuros.size() + "\n\n");
			counter++;

			try {

				// Localiza as dezenas da dupla no concurso
				List<FrequenciaDuplasTO> conflictList = new ArrayList<FrequenciaDuplasTO>();
				for (DezenaTO dezena1 : concurso.getDezenas()) {

					for (DezenaTO dezena2 : concurso.getDezenas()) {

						if (!dezena1.getVrDezena()
								.equals(dezena2.getVrDezena())) {

							Integer d1 = dezena1.getVrDezena();
							Integer d2 = dezena2.getVrDezena();

							if (d1.intValue() > d2.intValue()) {
								d1 = dezena2.getVrDezena();
								d2 = dezena1.getVrDezena();
							}

							// Obtem a frequencia na hash
							FrequenciaDuplasTO freqDupla = frequencias
									.get(generateDuplaKey(d1, d2));

							conflictList.add(freqDupla);

							freqDupla.setAtrasoUltimo(freqDupla
									.getAtrasoAtual() + 1L);
							freqDupla.setAtrasoAtual(0L);

							if (freqDupla.getAtrasoMaior().longValue() < freqDupla
									.getAtrasoUltimo().longValue()) {
								freqDupla.setAtrasoMaior(freqDupla
										.getAtrasoUltimo());
							}

							freqDupla
									.setQtdSorteada(freqDupla.getQtdSorteada() + 1L);

						}

					}

				}

				// Atualiza atraso
				for (FrequenciaDuplasTO fd : frequencias.values()) {

					if (!conflictList.contains(fd)
							&& !fd.getQtdSorteada().equals(0L)) {

						fd.setAtrasoUltimo(fd.getAtrasoAtual());
						fd.setAtrasoAtual(fd.getAtrasoAtual() + 1L);

						if (fd.getAtrasoMaior().longValue() < fd
								.getAtrasoUltimo().longValue()) {
							fd.setAtrasoMaior(fd.getAtrasoUltimo());
						}

					}

				}

			} catch (Exception e) {
				e.printStackTrace();
			}

		}

		// Atualiza frequencias na base
		session.beginTransaction();

		// Apaga todas as frequencias
		session.createQuery("delete FrequenciaDuplasTO").executeUpdate();

		// Atualiza atraso
		for (FrequenciaDuplasTO freqDupla : frequencias.values()) {

			session.save(freqDupla);
			session.flush();

		}

		session.getTransaction().commit();

	}

	/**
	 * Processa a lista de concursos recriando as trincas.
	 * 
	 * @param concuros
	 * @param frequencias
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<ConcursoTO> processarFrequenciaTrincas(
			List<ConcursoTO> concuros,
			Map<Integer, FrequenciaTrincaTO> frequencias) {

		// Lista com os concursos que obtiveram erro de processamento
		List<ConcursoTO> concursosErro = new ArrayList<ConcursoTO>();

		// Obtem a sessão hibernate
		Session session = HibernateUtil.getSessionFactory().openSession();

		// Obtem os concursos
		if (concuros == null || concuros.isEmpty()) {
			concuros = session.createQuery("from ConcursoTO order by id")
					.list();
		}

		int counter = 1;
		for (ConcursoTO concurso : concuros) {

			System.out.println("PROCESSANDO CONCURSO " + counter + " DE "
					+ concuros.size());
			counter++;

			try {

				// Localiza as dezenas da dupla no concurso
				List<FrequenciaTrincaTO> conflictList = new ArrayList<FrequenciaTrincaTO>();
				for (DezenaTO dezena1 : concurso.getDezenas()) {

					for (DezenaTO dezena2 : concurso.getDezenas()) {

						for (DezenaTO dezena3 : concurso.getDezenas()) {

							// Carante que as dezenas não são iguais
							if (!dezena1.getVrDezena().equals(
									dezena2.getVrDezena())
									&& !dezena1.getVrDezena().equals(
											dezena3.getVrDezena())
									&& !dezena2.getVrDezena().equals(
											dezena3.getVrDezena())) {

								// Ordena as dezenas
								List<Integer> dezenas = new ArrayList<Integer>();
								dezenas.add(dezena1.getVrDezena());
								dezenas.add(dezena2.getVrDezena());
								dezenas.add(dezena3.getVrDezena());

								// Ordena a lista
								Collections.sort(dezenas);

								// Obtem a frequencia na hash
								FrequenciaTrincaTO freqDupla = frequencias
										.get(generateTrincaKey(dezenas.get(0),
												dezenas.get(1), dezenas.get(2)));

								conflictList.add(freqDupla);

								freqDupla.setAtrasoUltimo(freqDupla
										.getAtrasoAtual() + 1L);
								freqDupla.setAtrasoAtual(0L);

								if (freqDupla.getAtrasoMaior().longValue() < freqDupla
										.getAtrasoUltimo().longValue()) {
									freqDupla.setAtrasoMaior(freqDupla
											.getAtrasoUltimo());
								}

								freqDupla.setQtdSorteada(freqDupla
										.getQtdSorteada() + 1L);

							}

						}
					}

				}

				// Atualiza atraso
				for (FrequenciaTrincaTO fd : frequencias.values()) {

					if (!conflictList.contains(fd)
							&& !fd.getQtdSorteada().equals(0L)) {

						fd.setAtrasoUltimo(fd.getAtrasoAtual());
						fd.setAtrasoAtual(fd.getAtrasoAtual() + 1L);

						if (fd.getAtrasoMaior().longValue() < fd
								.getAtrasoUltimo().longValue()) {
							fd.setAtrasoMaior(fd.getAtrasoUltimo());
						}

					}

				}

			} catch (Exception e) {
				e.printStackTrace();
				concursosErro.add(concurso);
			}

		}

		// Atualiza frequencias na base
		session.beginTransaction();

		// Apaga todas as frequencias
		session.createQuery("delete FrequenciaTrincaTO").executeUpdate();

		// Atualiza atraso
		counter = 1;
		List<FrequenciaTrincaTO> ft = new ArrayList<FrequenciaTrincaTO>(
				frequencias.values());
		for (FrequenciaTrincaTO freqDupla : ft) {

			System.out.println("PROCESSANDO FREQUENCIA " + counter + " DE "
					+ ft.size());

			session.save(freqDupla);

			// Executa commite parcial
			if ((counter % 3000) == 0) {

				System.out.println("Comitando transação...");
				session.getTransaction().commit();
				session.beginTransaction();
			}

			counter++;

		}

		session.getTransaction().commit();

		// Retorna a lista de erros
		return concursosErro;

	}

	/**
	 * Processa as frequencias
	 */
	@SuppressWarnings("unchecked")
	public void processarFrequencias() {

		// Obtem a sessão hibernate
		Session session = HibernateUtil.getSessionFactory().openSession();

		Query sqlDelete = session.createQuery("delete FrequenciaDezenasTO");
		sqlDelete.executeUpdate();

		Query sqlFindAllConcursos = session
				.createQuery("from ConcursoTO order by id");
		List<ConcursoTO> concursos = sqlFindAllConcursos.list();

		for (ConcursoTO concurso : concursos) {

			try {
				// Abre a transação
				session.beginTransaction();

				String dezenasSorteadas = "";
				int count = 1;

				for (DezenaTO dezena : concurso.getDezenas()) {

					dezenasSorteadas += dezena.getVrDezena();
					if (count < 6) {
						dezenasSorteadas += ", ";
					}
					count++;

					Query sqlFrequencia = session
							.createQuery("from FrequenciaDezenasTO where dezena = "
									+ dezena.getVrDezena());
					List<FrequenciaDezenasTO> fs = sqlFrequencia.list();

					if (fs.isEmpty()) {

						FrequenciaDezenasTO freq = new FrequenciaDezenasTO();
						freq.setAtrasoAtual(0L);
						freq.setAtrasoMaior(0L);
						freq.setAtrasoUltimo(0L);
						freq.setDezena(dezena.getVrDezena());
						freq.setQtdSorteada(1L);

						session.save(freq);

					} else {

						FrequenciaDezenasTO freq = fs.get(0);
						freq.setAtrasoUltimo(freq.getAtrasoAtual() + 1L);
						freq.setAtrasoAtual(0L);

						if (freq.getAtrasoMaior().longValue() < freq
								.getAtrasoUltimo().longValue()) {
							freq.setAtrasoMaior(freq.getAtrasoUltimo());
						}

						freq.setQtdSorteada(freq.getQtdSorteada() + 1L);
						session.save(freq);

					}

				}

				List<FrequenciaDezenasTO> atrasos = session.createQuery(
						"from FrequenciaDezenasTO where dezena not in ("
								+ dezenasSorteadas + ")").list();

				for (FrequenciaDezenasTO freq : atrasos) {

					freq.setAtrasoUltimo(freq.getAtrasoAtual());
					freq.setAtrasoAtual(freq.getAtrasoAtual() + 1L);

					if (freq.getAtrasoMaior().longValue() < freq
							.getAtrasoUltimo().longValue()) {
						freq.setAtrasoMaior(freq.getAtrasoUltimo());
					}

					session.save(freq);

				}

				// Comita a sessão
				session.getTransaction().commit();

			} catch (Exception e) {
				e.printStackTrace();
			}

		}

	}
}
