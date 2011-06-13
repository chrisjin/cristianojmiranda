package br.unicamp.ic.mc448.b.grafos;

import java.util.List;

import junit.framework.Test;
import junit.framework.TestCase;
import junit.framework.TestSuite;
import br.unicamp.ic.mc448.s12011.b.grafos.entidades.Grafo;
import br.unicamp.ic.mc448.s12011.b.grafos.entidades.Vertice;
import br.unicamp.ic.mc448.s12011.b.grafos.searchs.BreadthFirstSearch;
import br.unicamp.ic.mc448.s12011.b.grafos.searchs.DepthFirstSearch;

/**
 * Unit test for simple App.
 */
public class GrafosTest extends TestCase {
	/**
	 * Create the test case
	 * 
	 * @param testName
	 *            name of the test case
	 */
	public GrafosTest(String testName) {
		super(testName);
	}

	/**
	 * @return the suite of tests being tested
	 */
	public static Test suite() {
		return new TestSuite(GrafosTest.class);
	}

	/**
	 * Monta a estrutura de um grafo e valida suas principais estruturas.
	 * 
	 */
	public void testCreateGrafo() {

		Grafo g = new Grafo();
		g.setLabel("G1");
		g.setDescricao("Grafo de teste 1");

		Vertice va = new Vertice("A");
		Vertice vb = new Vertice("B");
		Vertice vc = new Vertice("C");
		Vertice vd = new Vertice("D");
		Vertice ve = new Vertice("E");

		g.adicionarVertice(va);
		g.adicionarVertice(vb);
		g.adicionarVertice(vc);
		g.adicionarVertice(vd);
		g.adicionarVertice(ve);

		g.adicionarAresta(va, vb, 1L, "ab");
		g.adicionarAresta(va, vc, 1L, "ac");
		g.adicionarAresta(vb, vc, 1L, "bc");
		g.adicionarAresta(vb, vd, 1L, "bd");
		g.adicionarAresta(vd, vc, 1L, "dc");
		g.adicionarAresta(vd, ve, 1L, "de");
		g.adicionarAresta(ve, vc, 1L, "ec");
		g.adicionarLaco(va, 1L, "aa");

		g.printGrafo();

		g.obterSubGrafoGerador().printGrafo();

		System.out.println("Grau dos vertices");
		for (Vertice v : g.getVerticeList()) {

			System.out.println(v.getLabel() + ", grau=" + v.getGrau()
					+ ", adj=" + v.obterVerticesAdjacentes());

		}

		System.out.println("Nr de arestas: " + g.getArestas().size());

		assertTrue(
				"Lemma de Handshaking não satisfeito, grafico tem algum erro.",
				g.verifyHandshakingLemma());

		assertTrue("Deveria existir uma aresta entre os vertices A e C", g
				.existsArestasBetween(va, vc));

		assertFalse("Não deveria existir uma aresta entre os vertices A e E", g
				.existsArestasBetween(va, ve));

		assertTrue("O grau do vertice E deveria ser 2.", ve.getGrau() == 2);
		assertTrue("O grau do vertice A deveria ser 4.", va.getGrau() == 4);

	}

	/**
	 * Testa a bus em largura no grafico.
	 * 
	 * @throws Exception
	 */
	public void testBuscaEmLarguraCenario1() throws Exception {

		Grafo g = new Grafo();
		g.setLabel("G1");
		g.setDescricao("Grafo de teste 1");

		Vertice va = new Vertice("A");
		Vertice vb = new Vertice("B");
		Vertice vc = new Vertice("C");
		Vertice vd = new Vertice("D");
		Vertice ve = new Vertice("E");
		Vertice vf = new Vertice("F");

		g.adicionarVertice(va);
		g.adicionarVertice(vb);
		g.adicionarVertice(vc);
		g.adicionarVertice(vd);
		g.adicionarVertice(ve);
		g.adicionarVertice(vf);

		g.adicionarAresta(va, vb, 1L, "ab");
		g.adicionarAresta(va, vc, 1L, "ac");
		g.adicionarAresta(vb, vc, 1L, "bc");
		g.adicionarAresta(vb, vd, 1L, "bd");
		g.adicionarAresta(vd, vc, 1L, "dc");
		g.adicionarAresta(vd, ve, 1L, "de");
		g.adicionarAresta(ve, vc, 1L, "ec");
		g.adicionarLaco(va, 1L, "aa");

		assertTrue(
				"Deveria retornar true, pois de fato existe um caminho de E para E.",
				BreadthFirstSearch.existeUmCaminhoEntreVertices(g, ve, ve));

		assertTrue(
				"Deveria retornar true, pois de fato existe um caminho de A para B.",
				BreadthFirstSearch.existeUmCaminhoEntreVertices(g, va, vb));

		assertTrue(
				"Deveria retornar true, pois de fato existe um caminho de A para E.",
				BreadthFirstSearch.existeUmCaminhoEntreVertices(g, va, ve));

		System.out.println("Caminho de A para E:");
		List<Vertice> caminho = BreadthFirstSearch.obterCaminhoEntreVertices(g,
				va, ve);

		for (Vertice v : caminho) {
			System.out.print(v.getLabel() + " -> ");
		}
		System.out.println(" //");

		System.out.println("Caminho de C para C:");
		caminho = BreadthFirstSearch.obterCaminhoEntreVertices(g, vc, vc);

		for (Vertice v : caminho) {
			System.out.print(v.getLabel() + " -> ");
		}
		System.out.println(" //");

		assertFalse(
				"Deveria retornar false, pois nao existe um caminho de A para F.",
				BreadthFirstSearch.existeUmCaminhoEntreVertices(g, va, vf));

		assertTrue(
				"O custo de F deveria ser infinito visto que ele não é alcavel pelo demais vertices.",
				vf.getD().equals(Long.MAX_VALUE));

		System.out.println("Custo A:" + va.getD());
		System.out.println("Custo B:" + vb.getD());
		System.out.println("Custo C:" + vc.getD());
		System.out.println("Custo D:" + vd.getD());
		System.out.println("Custo E:" + ve.getD());
		System.out.println("Custo F:" + vf.getD());

		System.out.println("\npi A:" + va.getPi());
		System.out.println("pi B:" + vb.getPi());
		System.out.println("pi C:" + vc.getPi());
		System.out.println("pi D:" + vd.getPi());
		System.out.println("pi E:" + ve.getPi());
		System.out.println("pi F:" + vf.getPi());

	}

	/**
	 * Testa a bus em largura no grafico.
	 * 
	 * @throws Exception
	 */
	public void testBuscaEmLarguraCenario2() throws Exception {

		Grafo g = new Grafo();
		g.setLabel("G1");
		g.setDescricao("Grafo de teste 1");

		Vertice vr = new Vertice("R");
		Vertice vs = new Vertice("S");
		Vertice vt = new Vertice("T");
		Vertice vu = new Vertice("U");
		Vertice vv = new Vertice("V");
		Vertice vx = new Vertice("X");
		Vertice vw = new Vertice("W");
		Vertice vy = new Vertice("Y");

		g.adicionarVertice(vr);
		g.adicionarVertice(vs);
		g.adicionarVertice(vt);
		g.adicionarVertice(vu);
		g.adicionarVertice(vv);
		g.adicionarVertice(vx);
		g.adicionarVertice(vw);
		g.adicionarVertice(vy);

		g.adicionarAresta(vv, vr, 1L, "vr");
		g.adicionarAresta(vr, vs, 1L, "rs");
		g.adicionarAresta(vs, vw, 1L, "sw");
		g.adicionarAresta(vw, vt, 1L, "wt");
		g.adicionarAresta(vw, vx, 1L, "wx");
		g.adicionarAresta(vt, vx, 1L, "tx");
		g.adicionarAresta(vt, vu, 1L, "tu");
		g.adicionarAresta(vx, vu, 1L, "xu");
		g.adicionarAresta(vx, vy, 1L, "xy");
		g.adicionarAresta(vu, vy, 1L, "uy");

		assertTrue(
				"Deveria retornar true, pois de fato existe um caminho de X para X.",
				BreadthFirstSearch.existeUmCaminhoEntreVertices(g, vx, vx));

		assertTrue(
				"Deveria retornar true, pois de fato existe um caminho de V para S.",
				BreadthFirstSearch.existeUmCaminhoEntreVertices(g, vv, vs));

		assertTrue(
				"Deveria retornar true, pois de fato existe um caminho de V para Y.",
				BreadthFirstSearch.existeUmCaminhoEntreVertices(g, vv, vy));

		System.out.println("Caminho de V para Y:");
		List<Vertice> caminho = BreadthFirstSearch.obterCaminhoEntreVertices(g,
				vv, vy);

		for (Vertice v : caminho) {
			System.out.print(v.getLabel() + " -> ");
		}
		System.out.println(" //");

		System.out.println("Caminho de U para U:");
		caminho = BreadthFirstSearch.obterCaminhoEntreVertices(g, vu, vu);

		for (Vertice v : caminho) {
			System.out.print(v.getLabel() + " -> ");
		}
		System.out.println(" //");

		BreadthFirstSearch.executarBusca(g, vs);

		System.out.println("Custo v:" + vv.getD());
		System.out.println("Custo r:" + vr.getD());
		System.out.println("Custo s:" + vs.getD());
		System.out.println("Custo t:" + vt.getD());
		System.out.println("Custo u:" + vu.getD());
		System.out.println("Custo x:" + vx.getD());
		System.out.println("Custo w:" + vw.getD());
		System.out.println("Custo y:" + vy.getD());

		System.out.println("\npi V:" + vv.getPi());
		System.out.println("pi R:" + vr.getPi());
		System.out.println("pi S:" + vs.getPi());
		System.out.println("pi T:" + vt.getPi());
		System.out.println("pi U:" + vu.getPi());
		System.out.println("pi X:" + vx.getPi());
		System.out.println("pi W:" + vw.getPi());
		System.out.println("pi Y:" + vy.getPi());

	}

	public void testBuscaProfundidadeCenario1() throws Exception {
		Grafo g = new Grafo();
		g.setLabel("G1");
		g.setDescricao("Grafo de teste 1");
		g.setOrientado(true);

		Vertice vs = new Vertice("S");
		Vertice vt = new Vertice("T");
		Vertice vu = new Vertice("U");
		Vertice vv = new Vertice("V");
		Vertice vx = new Vertice("X");
		Vertice vw = new Vertice("W");
		Vertice vy = new Vertice("Y");
		Vertice vz = new Vertice("Z");

		g.adicionarVertice(vs);
		g.adicionarVertice(vt);
		g.adicionarVertice(vu);
		g.adicionarVertice(vv);
		g.adicionarVertice(vx);
		g.adicionarVertice(vw);
		g.adicionarVertice(vy);
		g.adicionarVertice(vz);

		g.adicionarAresta(vs, vz, 1L, "SZ");
		g.adicionarAresta(vs, vw, 1L, "SW");

		g.adicionarAresta(vt, vv, 1L, "TV");
		g.adicionarAresta(vt, vu, 1L, "TU");

		g.adicionarAresta(vu, vv, 1L, "UV");
		g.adicionarAresta(vu, vt, 1L, "UT");

		g.adicionarAresta(vv, vs, 1L, "VS");
		g.adicionarAresta(vv, vw, 1L, "VW");

		g.adicionarAresta(vx, vz, 1L, "XZ");

		g.adicionarAresta(vy, vx, 1L, "YX");

		g.adicionarAresta(vw, vx, 1L, "WX");

		g.adicionarAresta(vz, vy, 1L, "ZY");
		g.adicionarAresta(vz, vw, 1L, "ZW");

		// Executa a busca em profundidade
		DepthFirstSearch.executarBusca(g, vs);

		System.out.println("\n\n\nMapeamento final:");
		for (Vertice v : g.getVerticeList()) {

			System.out.println(v.getLabel() + ": d=" + v.getD() + ", f="
					+ v.getF() + ", pi=" + v.getPi());

		}

		assertTrue("O peso de S deveria ser 1.", vs.getD()
				.equals(new Long("1")));

		List<Vertice> ordemTopologica = DepthFirstSearch
				.obterOrdemTopologica(g);

		System.out.println("\n\nOrdem Topologica:");
		for (Vertice v : ordemTopologica) {
			System.out.println(v.getLabel());
		}
	}

	public void testBuscaEmLarguraCenario3() throws Exception {

		Grafo g = new Grafo("G1 - Orientado", true);

		Vertice va = new Vertice("A");
		Vertice vb = new Vertice("B");
		Vertice vc = new Vertice("C");

		g.adicionarVertice(va);
		g.adicionarVertice(vb);
		g.adicionarVertice(vc);

		g.adicionarAresta(va, vb, 0L, "AB");
		g.adicionarAresta(vc, vb, 0L, "CB");

		// Executa busca em largura no grafo
		BreadthFirstSearch.executarBusca(g, va);

		assertTrue("A.d deveria ser 0.", va.getD().equals(new Long("0")));
		assertTrue("B.d deveria ser 1.", vb.getD().equals(new Long("1")));
		assertTrue(
				"C.d deveria ser infinito, visto que C não é alcançavel a partir de A.",
				vc.getD().equals(Long.MAX_VALUE));

		// Verifica se existe um caminho de A para C.
		assertFalse("Não deveria haver um caminho de A para C.",
				BreadthFirstSearch.existeUmCaminhoEntreVertices(g, va, vc));

	}

	public void testGrafoCiclicoCenario1() {

		Grafo g = new Grafo("G", false);

		Vertice va = new Vertice("A");
		Vertice vb = new Vertice("B");
		Vertice vc = new Vertice("C");

		g.adicionarVertice(va);
		g.adicionarVertice(vb);
		g.adicionarVertice(vc);

		g.adicionarAresta(va, vb, 0L, "AB");
		g.adicionarAresta(vb, vc, 0L, "BC");

		assertFalse("Não existe ciclo no grafo deveria retornar falso.", g
				.isCiclico());

	}

	public void testGrafoCiclicoCenario2() {

		Grafo g = new Grafo("G", false);

		Vertice va = new Vertice("A");
		Vertice vb = new Vertice("B");
		Vertice vc = new Vertice("C");

		g.adicionarVertice(va);
		g.adicionarVertice(vb);
		g.adicionarVertice(vc);

		g.adicionarAresta(va, vb, 0L, "AB");
		g.adicionarAresta(vb, vc, 0L, "BC");
		g.adicionarAresta(vc, va, 0L, "CA");

		assertTrue("Existe ciclo no grafo.", g.isCiclico());

	}

	public void testGrafoCiclicoCenario3() {

		Grafo g = new Grafo("G", false);

		Vertice va = new Vertice("A");
		Vertice vb = new Vertice("B");
		Vertice vc = new Vertice("C");
		Vertice vd = new Vertice("D");

		g.adicionarVertice(va);
		g.adicionarVertice(vb);
		g.adicionarVertice(vc);
		g.adicionarVertice(vd);

		g.adicionarAresta(va, vb, 0L, "AB");
		g.adicionarAresta(vb, vc, 0L, "BC");
		g.adicionarAresta(vc, vd, 0L, "CD");
		g.adicionarAresta(vd, vb, 0L, "DB");

		assertTrue("Existe ciclo no grafo.", g.isCiclico());

	}

	public void testeOrdemTopologicaCenario1() throws Exception {

		Grafo g = new Grafo("G", true);

		Vertice va = new Vertice("A");
		Vertice vb = new Vertice("B");
		Vertice vc = new Vertice("C");
		Vertice vd = new Vertice("D");

		g.adicionarAresta(va, vb);
		g.adicionarAresta(vb, vc);
		g.adicionarAresta(va, vd);

		System.out.println("Ordem topologica do grafo D <- A -> B -> C.");
		// Obtem a ordenação topologica
		for (Vertice v : DepthFirstSearch.obterOrdemTopologica(g)) {
			System.out.println(v.getLabel());
		}

		assertFalse(g.isCiclico());

	}

	public void testeOrdemTopologicaCenario2() throws Exception {

		Grafo g = new Grafo("G", true);

		Vertice va = new Vertice("A");
		Vertice vb = new Vertice("B");
		Vertice vc = new Vertice("C");
		Vertice vd = new Vertice("D");

		g.adicionarAresta(va, vb);
		g.adicionarAresta(vb, vc);
		g.adicionarAresta(va, vd);
		g.adicionarAresta(vd, vc);

		System.out.println("Ordem topologica do grafo C <- D <- A -> B -> C.");
		// Obtem a ordenação topologica
		for (Vertice v : DepthFirstSearch.obterOrdemTopologica(g)) {
			System.out.println(v.getLabel());
		}

		assertFalse(g.isCiclico());

	}

	public void testeOrdemTopologicaCenario3() throws Exception {

		Grafo g = new Grafo("G", true);

		Vertice va = new Vertice("A");
		Vertice vb = new Vertice("B");
		Vertice vc = new Vertice("C");
		Vertice vd = new Vertice("D");

		g.adicionarAresta(va, vb);
		g.adicionarAresta(vb, vc);
		g.adicionarAresta(va, vd);
		g.adicionarAresta(vd, vc);
		g.adicionarAresta(vd, vc);

		System.out
				.println("Ordem topologica do grafo A <- C <- D <- A -> B -> C.");
		// Obtem a ordenação topologica
		for (Vertice v : DepthFirstSearch.obterOrdemTopologica(g)) {
			System.out.println(v.getLabel());
		}

		assertTrue(g.isCiclico());

	}
}
