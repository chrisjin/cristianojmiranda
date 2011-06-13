package br.unicamp.ic.mc448.s12011.b.grafos.searchs;

import java.util.ArrayList;
import java.util.Collections;
import java.util.LinkedList;
import java.util.List;
import java.util.Queue;

import org.apache.log4j.Logger;

import br.unicamp.ic.mc448.s12011.b.grafos.entidades.Grafo;
import br.unicamp.ic.mc448.s12011.b.grafos.entidades.Vertice;
import br.unicamp.ic.mc448.s12011.b.grafos.entidades.enums.SEARCH_STATUS;

/**
 * Busca em larguma no grafo.
 * 
 * @author Cristiano
 * 
 */
public class BreadthFirstSearch {

	private static final Logger logger = Logger
			.getLogger(BreadthFirstSearch.class);

	/**
	 * Obtem o caminho entre o vertice origem e destino no grafo g.
	 * 
	 * @param g
	 * @param origem
	 * @param destino
	 * @return
	 * @throws Exception
	 */
	public static List<Vertice> obterCaminhoEntreVertices(Grafo g,
			Vertice origem, Vertice destino) throws Exception {

		// Lista com o caminho entre os verties
		List<Vertice> caminho = new ArrayList<Vertice>();

		// Caso exista um caminho entre tais vertices
		if (existeUmCaminhoEntreVertices(g, origem, destino)) {

			// Percorre o caminho do destino ate a origem
			while (destino != origem) {
				caminho.add(destino);
				destino = destino.getPi();
			}

			// Adiciona a origem no caminho
			caminho.add(origem);

			// Inverte a lista de caminhos
			Collections.reverse(caminho);

		}

		return caminho;

	}

	/**
	 * 
	 * Verifica se existe um caminho entre os vertices origem e destino, no
	 * grafo g.
	 * 
	 * @param g
	 * @param origem
	 * @param destino
	 * @return
	 * @throws Exception
	 */
	public static Boolean existeUmCaminhoEntreVertices(Grafo g, Vertice origem,
			Vertice destino) throws Exception {

		// Realiza a busca em largura no grafo.
		executarBusca(g, origem);

		// Caso não exista o caminho
		if (destino.getD().equals(Long.MAX_VALUE)) {
			return false;
		}

		return true;

	}

	/**
	 * Executa a busca em largura no grafo, setando o custo dos caminhos em D e
	 * o no pai em pi.
	 * 
	 * @param g
	 * @param origem
	 * @throws Exception
	 */
	public static void executarBusca(Grafo g, Vertice origem) throws Exception {

		Long timer = System.currentTimeMillis();
		logger.info("Inicializando busca");

		if (g == null || origem == null) {
			throw new Exception("Parametros de busca invalidos.");
		}

		if (g.getVertices().isEmpty() || !g.getVertices().containsValue(origem)) {

			throw new Exception("Os vertices não fazem parte do grafo.");

		}

		// Obtem todos os vertices do grafo
		List<Vertice> vertices = g.getVerticeList();

		// Inicializa os vertices
		for (Vertice u : vertices) {

			if (u != origem) {

				u.setStatus(SEARCH_STATUS.NAO_VISITADO);
				u.setD(Long.MAX_VALUE);
				u.setPi(null);

			}

		}

		// Inicializa a origem
		origem.setStatus(SEARCH_STATUS.VISITADO_PRIMEIRA_VEZ);
		origem.setD(0L);
		origem.setPi(null);

		// Monta a fila de vertices
		Queue<Vertice> qList = new LinkedList<Vertice>();
		qList.add(origem);

		while (!qList.isEmpty()) {

			logger.debug("QList size: " + qList.size());

			Vertice u = qList.remove();

			logger.debug("Processando vertice: " + u.getLabel() + ", Custo: "
					+ u.getD());

			// for (Vertice v : u.getVerticesIncidentes()) {
			for (Vertice v : u.obterVerticesAdjacentes()) {

				logger.debug("Verificando vertice " + v.getLabel()
						+ " adjascente a " + u.getLabel() + ", Custo: "
						+ v.getD());

				if (v.getStatus().compareTo(SEARCH_STATUS.NAO_VISITADO) == 0) {
					v.setStatus(SEARCH_STATUS.VISITADO_PRIMEIRA_VEZ);
					v.setD(u.getD() + 1);
					v.setPi(u);
					qList.add(v);
				} else {
					logger.debug("Status do vertice " + v.getLabel() + ": "
							+ v.getStatus());
				}

			}

			u.setStatus(SEARCH_STATUS.TODOS_VIZINHOS_VISITADOS);

		}

		logger.info("Finalizando a busca. Tempo de execução: "
				+ (System.currentTimeMillis() - timer) / 1000d + " ms.");

	}

}
