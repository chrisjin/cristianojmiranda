package br.unicamp.ic.mc448.s12011.b.grafos.searchs;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import org.apache.log4j.Logger;

import br.unicamp.ic.mc448.s12011.b.grafos.entidades.Grafo;
import br.unicamp.ic.mc448.s12011.b.grafos.entidades.Vertice;
import br.unicamp.ic.mc448.s12011.b.grafos.entidades.enums.SEARCH_STATUS;

/**
 * 
 * Busca em profundidade.
 * 
 * @author Cristiano
 * 
 */
public class DepthFirstSearch {

	// Logger
	private static final Logger logger = Logger
			.getLogger(DepthFirstSearch.class);

	// Tempo de finalização dos grafos
	private static Long tempo = new Long("0");

	// Vertor para armazenar a ordem topologica do grafo
	private static List<Vertice> ordemTopologica = new ArrayList<Vertice>();

	/**
	 * Executa a busca em profundidade no grafo.(DFS)
	 * 
	 * @param g
	 * @throws Exception
	 */
	public static void executarBusca(Grafo g, Vertice origem) throws Exception {

		Long timer = System.currentTimeMillis();
		logger.info("Inicializando busca");

		if (g == null) {
			throw new Exception("Grafo deve ser fornecido.");
		}

		logger.debug("Obtem a lista de vertices");
		List<Vertice> vertices = g.getVerticeList();

		if (!vertices.contains(origem)) {
			throw new Exception("O vertice de origem não faz parte do grafo.");
		}

		logger.debug("Inicializa os vertices");
		for (Vertice u : vertices) {

			u.setStatus(SEARCH_STATUS.NAO_VISITADO);
			u.setPi(null);

		}

		// Posiciona a origem no inicio do vetor
		int index = vertices.indexOf(origem);
		if (index > -1 && index != 0) {

			Vertice v0 = vertices.get(0);
			vertices.remove(index);
			vertices.add(index, v0);
			vertices.add(0, origem);

		}

		// Reincia o tempo
		tempo = new Long("0");

		// Inicializa a lista de ordem topologica
		ordemTopologica = new ArrayList<Vertice>();

		logger.debug("Processa os vertices do grafo");
		for (Vertice u : vertices) {

			logger.debug("Verificando o vertice: " + u.getLabel());

			if (u.getStatus().compareTo(SEARCH_STATUS.NAO_VISITADO) == 0) {

				dfsVisit(u);

			} else {
				logger.debug("Vertice " + u.getLabel() + " no status: "
						+ u.getStatus());
			}

		}

		logger.info("Finalizando a busca. Tempo de execução: "
				+ (System.currentTimeMillis() - timer) / 1000d + " ms.");

	}

	/**
	 * Visita o vertice na busca em profundidade.
	 * 
	 * @param u
	 */
	private static void dfsVisit(Vertice u) {

		u.setStatus(SEARCH_STATUS.VISITADO_PRIMEIRA_VEZ);
		tempo = new Long(tempo + 1);
		u.setD(tempo);

		logger.debug("Percorrendo todos os vertices adjacentes ao vertice "
				+ u.getLabel());
		// for (Vertice v : u.getVerticesIncidentes()) {
		for (Vertice v : u.obterVerticesAdjacentes()) {

			logger.debug("Verificando o vertice adjacente " + v.getLabel());

			if (v.getStatus().compareTo(SEARCH_STATUS.NAO_VISITADO) == 0) {

				v.setPi(u);
				// Visita o vertice v
				dfsVisit(v);
			} else {
				logger.debug("Vertice " + v.getLabel() + " no status: "
						+ v.getStatus());
			}

		}

		logger.info("Finaliza o vertice " + u.getLabel());
		u.setStatus(SEARCH_STATUS.TODOS_VIZINHOS_VISITADOS);
		tempo = new Long(tempo + 1);
		u.setF(tempo);

		// Adiciona o vertice a lista de ordem topologica
		ordemTopologica.add(u);

	}

	/**
	 * Verifica se a busca em profunidade executada é valida.
	 * 
	 * @param g
	 * @return
	 */
	public static Boolean buscaValida(Grafo g) {

		for (Vertice v : g.getVerticeList()) {

			// Caso haja algum vertice cujo visinhos não tenham sido
			// processados, ou algum vertice cujo D >= F a busca não é valida.
			if (v.getStatus().compareTo(SEARCH_STATUS.TODOS_VIZINHOS_VISITADOS) != 0
					|| v.getD().compareTo(v.getF()) >= 0) {

				return false;
			}

		}

		return true;

	}

	/**
	 * Obtem a ordenção topologica para o grafo.
	 * 
	 * @param g
	 * @return
	 * @throws Exception
	 */
	public static List<Vertice> obterOrdemTopologica(Grafo g) throws Exception {

		// Caso o grafo seja ciclico não existe ordem topologica
		if (g.isCiclico()) {
			return new ArrayList<Vertice>();
		}

		// Caso a busca em profundidade não tenha sido executado para o grafo em
		// questão
		if ((!ordemTopologica.isEmpty()
				&& ordemTopologica.get(0).getGrafo() != null && ordemTopologica
				.get(0).getGrafo() != g)
				|| ordemTopologica == null || ordemTopologica.isEmpty()) {

			// Executa a busca em profundidade
			executarBusca(g, g.getVerticeList().get(0));

		}

		// Inverte a lista de ordenação
		Collections.reverse(ordemTopologica);

		// Retorna a lista de ordem topologica
		return ordemTopologica;

	}
}
