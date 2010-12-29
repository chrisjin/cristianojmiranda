package br.com.cjm.mega.business.impl;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.hibernate.classic.Session;

import br.com.cjm.mega.datatype.ConcursoTO;
import br.com.cjm.mega.datatype.DezenaTO;
import br.com.cjm.mega.datatype.FrequenciaDezenasTO;
import br.com.cjm.mega.datatype.FrequenciaDuplasTO;
import br.com.cjm.mega.datatype.FrequenciaQuadraTO;
import br.com.cjm.mega.datatype.FrequenciaQuinaTO;
import br.com.cjm.mega.datatype.FrequenciaTrincaTO;
import br.com.cjm.mega.persistence.HibernateUtil;

/**
 * Serviço para processar as frequencias da sena (dezenas, dupla, trinca, quadra
 * e quina).
 * 
 * @author Cristiano
 * 
 */
public class FrequenciaServiceImpl {

	/**
	 * Instancia do serviço
	 */
	private static FrequenciaServiceImpl instance;

	private FrequenciaServiceImpl() {

	}

	/**
	 * Obtem a instancia do serviço
	 * 
	 * @return
	 */
	public static FrequenciaServiceImpl getInstance() {

		if (instance == null)
			instance = new FrequenciaServiceImpl();

		return instance;
	}

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
	 * Cria a lista de frequencias
	 * 
	 */
	public Map<Integer, FrequenciaDezenasTO> criarFrequencia(
			boolean dbIntegration) {

		// Map de resultados
		Map<Integer, FrequenciaDezenasTO> resultMap = new HashMap<Integer, FrequenciaDezenasTO>();

		Session session = null;
		if (dbIntegration) {
			// Obtem a sessão hibernate
			session = HibernateUtil.getSessionFactory().openSession();
		}

		try {

			if (dbIntegration) {
				session.beginTransaction();

				// Apaga todas as frequencias
				session.createQuery("delete FrequenciaDezenasTO")
						.executeUpdate();
			}

			for (int i = 1; i <= 60; i++) {

				// Monta a frequencia
				FrequenciaDezenasTO freqDupla = new FrequenciaDezenasTO();
				freqDupla.setDezena(i);

				// Adiciona a frequencia na map de saida
				resultMap.put(i, freqDupla);

				if (dbIntegration) {
					session.save(freqDupla);
					session.flush();

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

				for (int j = (i + 1); j <= 60; j++) {

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

				for (int j = (i + 1); j <= 60; j++) {

					for (int k = (j + 1); k <= 60; k++) {

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
	 * Cria a lista de frequencias de quadras
	 * 
	 */
	public Map<Integer, FrequenciaQuadraTO> criarFrequenciaQuadra(
			boolean dbIntegration) {

		// Map de resultados
		Map<Integer, FrequenciaQuadraTO> resultMap = new HashMap<Integer, FrequenciaQuadraTO>();

		Session session = null;
		if (dbIntegration) {
			// Obtem a sessão hibernate
			session = HibernateUtil.getSessionFactory().openSession();
		}

		try {

			if (dbIntegration) {
				session.beginTransaction();

				// Apaga todas as frequencias
				session.createQuery("delete FrequenciaQuadraTO")
						.executeUpdate();
			}

			for (int i = 1; i <= 60; i++) {

				for (int j = (i + 1); j <= 60; j++) {

					for (int k = (j + 1); k <= 60; k++) {

						for (int l = (k + 1); l <= 60; l++) {

							// Monta a frequencia
							FrequenciaQuadraTO freq = new FrequenciaQuadraTO();
							freq.setDezena1(i);
							freq.setDezena2(j);
							freq.setDezena3(k);
							freq.setDezena4(l);

							// Adiciona a frequencia na map de saida
							resultMap.put(generateQuadraKey(i, j, k, l), freq);

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
	 * Cria a lista de frequencias de quina
	 * 
	 */
	public void criarFrequenciaQuina() {

		Session session = null;

		// Obtem a sessão hibernate
		session = HibernateUtil.getSessionFactory().openSession();

		try {

			session.beginTransaction();

			// Apaga todas as frequencias
			session.createQuery("delete FrequenciaQuinaTO").executeUpdate();

			long counter = 1;

			long recordMax = (60 * 59 * 58 * 57 * 56);

			for (int i = 1; i <= 60; i++) {

				for (int j = (i + 1); j <= 60; j++) {

					for (int k = (j + 1); k <= 60; k++) {

						for (int l = (k + 1); l <= 60; l++) {

							for (int m = (l + 1); m <= 60; m++) {

								System.out.println("PROCESSANDO FREQUENCIA "
										+ counter + " DE " + recordMax + ". "
										+ (int) (counter * 100 / recordMax)
										+ "%");

								// Monta a frequencia
								FrequenciaQuinaTO freq = new FrequenciaQuinaTO();
								freq.setId(counter);
								freq.setDezena1(i);
								freq.setDezena2(j);
								freq.setDezena3(k);
								freq.setDezena4(l);
								freq.setDezena5(m);

								session.save(freq);

								if ((counter % 500000) == 0) {

									System.out
											.println("comitando a transação...");

									session.getTransaction().commit();
									session.beginTransaction();
								}
								counter++;

							}

						}
					}

				}

			}

			session.getTransaction().commit();

		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	/**
	 * @param concurso
	 */
	public void processarFrequenciaDezena(ConcursoTO concurso) {

		// Obtem a sessão hibernate
		Session session = HibernateUtil.getSessionFactory().openSession();

		System.out.println("PROCESSANDO FREQUENCIA DUPLA PARA CONCURSO "
				+ concurso.getId());

		// Localiza as dezenas da dupla no concurso
		for (DezenaTO dezena1 : concurso.getDezenas()) {

			// Obtem a frequencia na hash
			FrequenciaDezenasTO freqDupla = (FrequenciaDezenasTO) session
					.createQuery(
							"from FrequenciaDezenasTO where dezena = "
									+ dezena1.getVrDezena()).list().get(0);

			freqDupla.setAtrasoUltimo(freqDupla.getAtrasoAtual() + 1L);
			freqDupla.setAtrasoAtual(0L);

			if (freqDupla.getAtrasoMaior().longValue() < freqDupla
					.getAtrasoUltimo().longValue()) {
				freqDupla.setAtrasoMaior(freqDupla.getAtrasoUltimo());
			}

			freqDupla.setQtdSorteada(freqDupla.getQtdSorteada() + 1L);

		}

		// session.createQuery("update FrequenciaDezenasTO set ")

	}

	/**
	 * Processa a frequencia das dezenas.
	 * 
	 * @param concuros
	 */
	@SuppressWarnings("unchecked")
	public void processarFrequencia(List<ConcursoTO> concuros,
			Map<Integer, FrequenciaDezenasTO> frequencias) {

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
				List<FrequenciaDezenasTO> conflictList = new ArrayList<FrequenciaDezenasTO>();
				for (DezenaTO dezena1 : concurso.getDezenas()) {

					// Obtem a frequencia na hash
					FrequenciaDezenasTO freqDupla = frequencias.get(dezena1
							.getVrDezena());

					conflictList.add(freqDupla);

					freqDupla.setAtrasoUltimo(freqDupla.getAtrasoAtual() + 1L);
					freqDupla.setAtrasoAtual(0L);

					if (freqDupla.getAtrasoMaior().longValue() < freqDupla
							.getAtrasoUltimo().longValue()) {
						freqDupla.setAtrasoMaior(freqDupla.getAtrasoUltimo());
					}

					freqDupla.setQtdSorteada(freqDupla.getQtdSorteada() + 1L);

				}

				// Atualiza atraso
				for (FrequenciaDezenasTO fd : frequencias.values()) {

					if (!conflictList.contains(fd)
							&& !fd.getQtdSorteada().equals(0L)) {

						fd.setAtrasoUltimo(fd.getAtrasoAtual());
						fd.setAtrasoAtual(fd.getAtrasoAtual() + 1L);

						if (fd.getAtrasoMaior().longValue() < fd
								.getAtrasoUltimo().longValue()) {

							fd.setAtrasoMaior(fd.getAtrasoUltimo());

						} else if (fd.getAtrasoMaior().longValue() < fd
								.getAtrasoAtual().longValue()) {

							fd.setAtrasoMaior(fd.getAtrasoAtual());

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
		session.createQuery("delete FrequenciaDezenasTO").executeUpdate();

		// Atualiza atraso
		for (FrequenciaDezenasTO freqDupla : frequencias.values()) {

			freqDupla.processarIfrap();
			session.save(freqDupla);
			session.flush();

		}

		session.getTransaction().commit();

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

			System.out.println("PROCESSANDO CONCURSO " + counter + " DE "
					+ concuros.size());
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

						fd.setAtrasoUltimo(fd.getAtrasoAtual() + 1L);
						fd.setAtrasoAtual(fd.getAtrasoAtual());

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

						if (dezena1.getVrDezena().intValue() < dezena2
								.getVrDezena().intValue()) {

							for (DezenaTO dezena3 : concurso.getDezenas()) {

								// Carante que as dezenas não são iguais
								if (dezena2.getVrDezena().intValue() < dezena3
										.getVrDezena().intValue()) {

									// Ordena as dezenas
									List<Integer> dezenas = new ArrayList<Integer>();
									dezenas.add(dezena1.getVrDezena());
									dezenas.add(dezena2.getVrDezena());
									dezenas.add(dezena3.getVrDezena());

									// Ordena a lista
									Collections.sort(dezenas);

									// Obtem a frequencia na hash
									FrequenciaTrincaTO freqDupla = frequencias
											.get(generateTrincaKey(dezenas
													.get(0), dezenas.get(1),
													dezenas.get(2)));

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
			if ((counter % 5000) == 0) {

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
	 * Processa a lista de concursos recriando as trincas.
	 * 
	 * @param concuros
	 * @param frequencias
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<ConcursoTO> processarFrequenciaQuadras(
			List<ConcursoTO> concuros,
			Map<Integer, FrequenciaQuadraTO> frequencias) {

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
				List<FrequenciaQuadraTO> conflictList = new ArrayList<FrequenciaQuadraTO>();
				for (DezenaTO dezena1 : concurso.getDezenas()) {

					for (DezenaTO dezena2 : concurso.getDezenas()) {

						if (dezena1.getVrDezena().intValue() < dezena2
								.getVrDezena().intValue()) {

							for (DezenaTO dezena3 : concurso.getDezenas()) {

								if (dezena2.getVrDezena().intValue() < dezena3
										.getVrDezena().intValue()) {

									for (DezenaTO dezena4 : concurso
											.getDezenas()) {

										if (dezena3.getVrDezena().intValue() < dezena4
												.getVrDezena().intValue()) {

											// Carante que as dezenas não são
											// iguais
											if (!dezena1.getVrDezena().equals(
													dezena2.getVrDezena())
													&& !dezena1
															.getVrDezena()
															.equals(
																	dezena3
																			.getVrDezena())
													&& !dezena1
															.getVrDezena()
															.equals(
																	dezena4
																			.getVrDezena())
													&& !dezena2
															.getVrDezena()
															.equals(
																	dezena3
																			.getVrDezena())
													&& !dezena2
															.getVrDezena()
															.equals(
																	dezena4
																			.getVrDezena())
													&& !dezena3
															.getVrDezena()
															.equals(
																	dezena4
																			.getVrDezena())) {

												// Ordena as dezenas
												List<Integer> dezenas = new ArrayList<Integer>();
												dezenas.add(dezena1
														.getVrDezena());
												dezenas.add(dezena2
														.getVrDezena());
												dezenas.add(dezena3
														.getVrDezena());
												dezenas.add(dezena4
														.getVrDezena());

												// Ordena a lista
												Collections.sort(dezenas);

												// Obtem a frequencia na hash
												FrequenciaQuadraTO freqDupla = frequencias
														.get(generateQuadraKey(
																dezenas.get(0),
																dezenas.get(1),
																dezenas.get(2),
																dezenas.get(3)));

												conflictList.add(freqDupla);

												freqDupla
														.setAtrasoUltimo(freqDupla
																.getAtrasoAtual() + 1L);
												freqDupla.setAtrasoAtual(0L);

												if (freqDupla.getAtrasoMaior()
														.longValue() < freqDupla
														.getAtrasoUltimo()
														.longValue()) {
													freqDupla
															.setAtrasoMaior(freqDupla
																	.getAtrasoUltimo());
												}

												freqDupla
														.setQtdSorteada(freqDupla
																.getQtdSorteada() + 1L);

											}
										}

									}
								}
							}
						}
					}

				}

				// Atualiza atraso
				for (FrequenciaQuadraTO fd : frequencias.values()) {

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
		session.createQuery("delete FrequenciaQuadraTO").executeUpdate();

		// Atualiza atraso
		counter = 1;
		List<FrequenciaQuadraTO> ft = new ArrayList<FrequenciaQuadraTO>(
				frequencias.values());
		for (FrequenciaQuadraTO freqDupla : ft) {

			System.out.println("PROCESSANDO FREQUENCIA " + counter + " DE "
					+ ft.size());

			session.save(freqDupla);

			// Executa commite parcial
			if ((counter % 10000) == 0) {

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
	 * Processa a lista de concursos recriando as trincas.
	 * 
	 * @param concuros
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<ConcursoTO> processarFrequenciaQuina(List<ConcursoTO> concuros) {

		// Lista com os concursos que obtiveram erro de processamento
		List<ConcursoTO> concursosErro = new ArrayList<ConcursoTO>();

		// Obtem a sessão hibernate
		Session session = HibernateUtil.getSessionFactory().openSession();

		// Obtem os concursos
		if (concuros == null || concuros.isEmpty()) {
			concuros = session.createQuery("from ConcursoTO order by id")
					.list();
		}

		// Apaga todas as frequencias
		session.createQuery("delete FrequenciaQuinaTO").executeUpdate();

		int counter = 1;
		for (ConcursoTO concurso : concuros) {

			session.beginTransaction();
			System.out.println("PROCESSANDO CONCURSO " + counter + " DE "
					+ concuros.size());
			counter++;

			try {

				for (List<Integer> quina : concurso.obtemPossiveisQuinas()) {

					FrequenciaQuinaTO freqNew = new FrequenciaQuinaTO(quina);

					List<FrequenciaQuinaTO> freqDbList = session.createQuery(
							"from FrequenciaQuinaTO f where f.dezena1 = "
									+ freqNew.getDezena1()
									+ " and f.dezena2 = "
									+ freqNew.getDezena2()
									+ " and f.dezena3 = "
									+ freqNew.getDezena3()
									+ " and f.dezena4 = "
									+ freqNew.getDezena4()
									+ " and f.dezena5 = "
									+ freqNew.getDezena5()).list();

					// Caso a frequencia não exista no banco
					if (freqDbList.isEmpty()) {

						freqNew.setQtdSorteada(1L);
						session.save(freqNew);

					} else {

						// Obtem a frequencia a ser atualizada
						freqNew = freqDbList.get(0);
						freqNew.setAtrasoAtual(0L);
						freqNew.setQtdSorteada(freqNew.getQtdSorteada() + 1L);
						session.persist(freqNew);

					}

					// Atualiza as frequencia demais frequencias
					if (session
							.createQuery(
									"update FrequenciaQuinaTO f set f.atrasoUltimo = f.atrasoAtual, f.atrasoAtual = (f.atrasoAtual + 1L) where (f.dezena1 != "
											+ quina.get(0)
											+ " and f.dezena2 != "
											+ quina.get(1)
											+ " and f.dezena3 != "
											+ quina.get(2)
											+ " and f.dezena4 != "
											+ quina.get(3)
											+ " and f.dezena5 != "
											+ quina.get(4)
											+ " ) and f.atrasoUltimo <= f.atrasoMaior")
							.executeUpdate() > 0) {

						// Atualiza atraso maior
						session
								.createQuery(
										"update FrequenciaQuinaTO f set f.atrasoMaior = f.atrasoUltimo, f.atrasoUltimo = f.atrasoAtual, f.atrasoAtual = (f.atrasoAtual + 1L) where (f.dezena1 != "
												+ quina.get(0)
												+ " and f.dezena2 != "
												+ quina.get(1)
												+ " and f.dezena3 != "
												+ quina.get(2)
												+ " and f.dezena4 != "
												+ quina.get(3)
												+ " and f.dezena5 != "
												+ quina.get(4)
												+ " ) and f.atrasoUltimo > f.atrasoMaior")
								.executeUpdate();

					}
				}

				// comita a transação
				session.getTransaction().commit();

			} catch (Exception e) {
				e.printStackTrace();
				concursosErro.add(concurso);
			}

		}

		// Retorna a lista de erros
		return concursosErro;

	}
}
