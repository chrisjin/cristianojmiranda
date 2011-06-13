package br.unicamp.ic.mc448.s12011.b.grafos.entidades;

import java.awt.Color;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.swing.JFrame;

import org.apache.commons.lang.builder.ToStringBuilder;
import org.apache.commons.lang.builder.ToStringStyle;
import org.apache.log4j.Logger;

import prefuse.Constants;
import prefuse.Display;
import prefuse.Visualization;
import prefuse.action.ActionList;
import prefuse.action.RepaintAction;
import prefuse.action.assignment.ColorAction;
import prefuse.action.assignment.DataColorAction;
import prefuse.action.layout.graph.ForceDirectedLayout;
import prefuse.activity.Activity;
import prefuse.controls.DragControl;
import prefuse.controls.NeighborHighlightControl;
import prefuse.controls.PanControl;
import prefuse.controls.WheelZoomControl;
import prefuse.controls.ZoomControl;
import prefuse.controls.ZoomToFitControl;
import prefuse.data.Graph;
import prefuse.data.Node;
import prefuse.data.Table;
import prefuse.render.AbstractShapeRenderer;
import prefuse.render.DefaultRendererFactory;
import prefuse.render.LabelRenderer;
import prefuse.util.ColorLib;
import prefuse.visual.VisualItem;
import br.unicamp.ic.mc448.s12011.b.grafos.searchs.BreadthFirstSearch;

/**
 * Classe para representar um grafo.
 * 
 * 
 * @author Cristiano
 * 
 */
public class Grafo implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -2990929407062653707L;

	// Grafo
	private static final Logger logger = Logger.getLogger(Grafo.class);

	public Grafo() {
		super();
	}

	/**
	 * @param label
	 * @param descricao
	 * @param orientado
	 */
	public Grafo(String label, String descricao, Boolean orientado) {
		super();
		this.label = label;
		this.descricao = descricao;
		this.orientado = orientado;
	}

	/**
	 * @param label
	 * @param orientado
	 */
	public Grafo(String label, Boolean orientado) {
		super();
		this.label = label;
		this.orientado = orientado;
	}

	private String label;
	private String descricao;

	public String getLabel() {
		return label;
	}

	@Override
	public String toString() {
		return ToStringBuilder.reflectionToString(this,
				ToStringStyle.MULTI_LINE_STYLE);
	}

	public void setLabel(String label) {
		this.label = label;
	}

	public String getDescricao() {
		return descricao;
	}

	public void setDescricao(String descricao) {
		this.descricao = descricao;
	}

	private Boolean orientado = Boolean.FALSE;

	private Map<String, Aresta> arestas = new HashMap<String, Aresta>();

	public Map<String, Aresta> getArestas() {
		return arestas;
	}

	public void setArestas(Map<String, Aresta> arestas) {
		this.arestas = arestas;
	}

	public Boolean isOrientado() {
		return orientado;
	}

	public void setOrientado(Boolean orientado) {
		this.orientado = orientado;
	}

	public Map<String, Vertice> getVertices() {
		return vertices;
	}

	public void setVertices(Map<String, Vertice> vertices) {
		this.vertices = vertices;
	}

	private Map<String, Vertice> vertices = new HashMap<String, Vertice>();

	/**
	 * Adiciona um vertice ao grafo.
	 * 
	 * @param v
	 */
	public void adicionarVertice(Vertice v) {

		// Seta o grafo
		v.setGrafo(this);

		// Adiciona o vertice ao grafo
		this.vertices.put(v.getLabel(), v);
	}

	/**
	 * Adiciona uma aresta a um grafo.
	 * 
	 * @param v1
	 *            - Vertice de origem
	 * @param v2
	 *            - Vertice de destino
	 * @param peso
	 *            - Peso da aresta
	 * @param label
	 *            - Rotulo da aresta
	 */
	public void adicionarAresta(Vertice v1, Vertice v2, Long peso, String label) {

		if (this.vertices.get(v1.getLabel()) == null) {
			adicionarVertice(v1);
		}

		if (this.vertices.get(v2.getLabel()) == null) {
			adicionarVertice(v2);
		}

		Aresta aresta = new Aresta(peso, v1, v2, label);

		this.arestas.put(generateVerticesLabel(v1, v2), aresta);

		// Seta a aresta incidente
		v1.getArestasIncidentes().add(aresta);
		v2.getArestasIncidentes().add(aresta);

		if (this.orientado) {

			v1.getArestaSaida().add(aresta);
			v2.getArestaEntrada().add(aresta);
		}

	}

	/**
	 * Cria uma aresta entre os vertices.
	 * 
	 * @param v1
	 * @param v2
	 */
	public void adicionarAresta(Vertice v1, Vertice v2) {
		adicionarAresta(v1, v2, 0L, generateVerticesLabel(v1, v2));
	}

	public void removerAresta(Aresta aresta) {

		if (aresta != null) {

			// Remove a aresta do grafo
			aresta = this.arestas.remove(generateVerticesLabel(aresta
					.getVertice1(), aresta.getVertice2()));

			// Caso a aresta exista no grafo, remove dos vertices
			if (aresta != null) {

				aresta.getVertice1().getArestasIncidentes().remove(aresta);
				aresta.getVertice2().getArestasIncidentes().remove(aresta);

				if (this.orientado) {
					aresta.getVertice1().getArestaSaida().remove(aresta);
					aresta.getVertice2().getArestaEntrada().remove(aresta);
				}
			}

		}

	}

	public void adicionarAresta(Aresta aresta) {

		adicionarAresta(aresta.getVertice1(), aresta.getVertice2(), aresta
				.getPeso(), aresta.getLabel());

	}

	public String generateVerticesLabel(Vertice v1, Vertice v2) {
		return "(" + v1.getLabel() + "," + v2.getLabel() + ")";
	}

	public void adicionarLaco(Vertice v, Long peso, String label) {
		adicionarAresta(v, v, peso, label);
	}

	public int getTamanhoGrafo() {
		return this.getArestas().size() + this.getVertices().size();
	}

	public Boolean isCiclico() {

		Boolean result = false;

		for (Vertice v : getVerticeList()) {

			for (Vertice u : v.obterVerticesAdjacentes()) {

				Aresta aresta = obterAresta(v, u);
				if (aresta != null) {

					// Remove a aresta
					this.removerAresta(aresta);

					try {

						// Apos remover a aresta caso ainda exista um caminho
						// entre tais vertices, existe um ciclo no grafo.
						if (BreadthFirstSearch.existeUmCaminhoEntreVertices(
								this, v, u)) {

							result = true;
						}

					} catch (Exception e) {

						logger.error(e);

					}

					// Adiciona a aresta novamente
					this.adicionarAresta(aresta);

					if (result) {
						return true;
					}

				}

			}

		}

		return result;
	}

	public Aresta obterAresta(Vertice v1, Vertice v2) {

		Aresta aresta = this.arestas.get(generateVerticesLabel(v1, v2));

		if (aresta == null) {

			aresta = this.arestas.get(generateVerticesLabel(v2, v1));

		}

		return aresta;

	}

	public List<Vertice> getVerticeList() {

		List<Vertice> vertices = new ArrayList<Vertice>();

		for (String label : this.vertices.keySet()) {
			vertices.add(this.vertices.get(label));
		}

		return vertices;

	}

	public Boolean verifyHandshakingLemma() {

		int grauVertices = 0;
		for (String label : this.vertices.keySet()) {
			Vertice v = this.vertices.get(label);
			grauVertices += v.getGrau();
		}

		if (grauVertices == (2 * this.arestas.size())) {
			return Boolean.TRUE;
		}

		return Boolean.FALSE;

	}

	/**
	 * Verifica se existe uma aresta entre 2 Vertices.
	 * 
	 * @param v1
	 *            - Vertice de origem
	 * @param v2
	 *            - Vertice de destino
	 * @return
	 */
	public Boolean existsArestasBetween(Vertice v1, Vertice v2) {

		return this.arestas.containsKey(generateVerticesLabel(v1, v2));

	}

	public Aresta getAresta(Vertice v1, Vertice v2) {

		if (existsArestasBetween(v1, v2)) {

			if (this.arestas.containsKey(generateVerticesLabel(v1, v2))) {
				return this.arestas.get(generateVerticesLabel(v1, v2));
			}

			if (this.arestas.containsKey(generateVerticesLabel(v2, v1))) {
				return this.arestas.get(generateVerticesLabel(v2, v1));
			}

		}

		return null;
	}

	public Grafo obterSubGrafoGerador() {

		Grafo sub = new Grafo();
		sub.setLabel("Subgrafo " + this.getLabel());
		sub.setDescricao("subgrafo");

		List<Vertice> vertices = getVerticeList();
		for (Vertice v : vertices) {
			sub.adicionarVertice(new Vertice(v, sub));
		}

		int aresta = 0;
		for (Vertice v1 : vertices) {

			Vertice origem = sub.getVertices().get(v1.getLabel());

			for (Vertice v2 : vertices) {

				if (v1 != v2 && origem.getArestasIncidentes().isEmpty()) {

					if (this.existsArestasBetween(v1, v2)) {

						Aresta arsta = getAresta(v1, v2);

						sub.adicionarAresta(v1, v2, arsta.getPeso(), Integer
								.toString(aresta++));
					}

				}

			}
		}

		return sub;

	}

	public void printGrafo() {

		StringBuffer buff = new StringBuffer();
		buff.append("Grafo: {");
		buff.append("label: '");
		buff.append(label);
		buff.append("', vertices: {'");

		int count = 0;
		for (Vertice v : getVerticeList()) {

			if (count++ != 0) {
				buff.append(", '");
			}

			buff.append(v.getLabel());
			buff.append("'");
		}

		buff.append("}, arestas: {'");

		count = 0;
		for (String label : this.arestas.keySet()) {
			if (count++ != 0) {
				buff.append(", '");
			}

			buff.append(label);
			buff.append("'");
		}

		buff.append("}}");

		System.out.println(buff.toString());
	}

	public void showGrafo() {

		Table vertices = new Table();
		vertices.addColumn("id", int.class);
		vertices.addColumn("label", String.class);
		vertices.addColumn("d", Long.class);
		vertices.addColumn("hasDefinition", int.class);

		Table arestas = new Table();
		arestas.addColumn("id1", int.class);
		arestas.addColumn("id2", int.class);

		Graph grafo = new Graph(vertices, arestas, true, "id1", "id2");

		HashMap<String, Node> nodeList = new HashMap<String, Node>();

		for (Vertice w : getVerticeList()) {

			Node t = nodeList.get(w.getLabel());

			if (t == null) {
				t = createNode(grafo, w);
				nodeList.put(w.getLabel(), t);
			}

			for (Vertice related : w.obterVerticesAdjacentes()) {

				Node s = nodeList.get(related.getLabel());

				if (s == null) {
					s = createNode(grafo, related);
					nodeList.put(related.getLabel(), s);
				}

				grafo.addEdge(s, t);
			}
		}

		Visualization vis = new Visualization();
		vis.add("graph", grafo);

		// **** Trocar o keyword por name se for usar o arquivo xml ***
		LabelRenderer r = new LabelRenderer("id");
		r.setRoundedCorner(8, 8); // round the corners
		r
				.setRenderType(AbstractShapeRenderer.RENDER_TYPE_DRAW_AND_FILL/* RENDER_TYPE_FILL */);
		r.setHorizontalAlignment(Constants.CENTER);

		// create a new default renderer factory
		// return our name label renderer as the default for all non-EdgeItems
		// includes straight line edges for EdgeItems by default
		vis.setRendererFactory(new DefaultRendererFactory(r));

		int[] palette = new int[] { ColorLib.rgb(255, 180, 180),
				ColorLib.rgb(190, 190, 255) };

		// map nominal data values to colors using our provided palette
		// **** Trocar o hasDefinition por gender se for usar o arquivo xml ***
		DataColorAction fill = new DataColorAction("graph.nodes",
				"hasDefinition", Constants.NOMINAL, VisualItem.FILLCOLOR,
				palette);

		// use black for node text
		ColorAction text = new ColorAction("graph.nodes", VisualItem.TEXTCOLOR,
				ColorLib.gray(50));
		// use light grey for edges
		ColorAction edges = new ColorAction("graph.edges",
				VisualItem.STROKECOLOR, ColorLib.gray(100));

		ActionList color = new ActionList();
		color.add(fill);
		color.add(text);
		color.add(edges);

		// add the actions to the visualization
		vis.putAction("color", color);

		ActionList layout = new ActionList(Activity.INFINITY);
		layout.add(new ForceDirectedLayout("graph", true));
		layout.add(new RepaintAction());
		vis.putAction("layout", layout);

		Display display = new Display(vis);
		display.setSize(700, 700); // Tamanho do display
		display.pan(350, 350); // Configura o centro do Display.
		display.setForeground(Color.GRAY);
		display.setBackground(Color.WHITE);
		display.addControlListener(new DragControl()); // drag items around
		display.addControlListener(new PanControl()); // pan with background
		// left-drag
		display.addControlListener(new ZoomControl()); // zoom with vertical
		// right-drag
		display.addControlListener(new WheelZoomControl());
		display.addControlListener(new ZoomToFitControl());
		display.addControlListener(new NeighborHighlightControl());

		JFrame frame = new JFrame("prefuse example");
		// ensure application exits when window is closed
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		frame.add(display);
		frame.pack(); // layout components in window
		frame.setVisible(true); // show the window

		vis.run("color"); // assign the colors
		vis.run("layout"); // start up the animated layout

	}

	private Node createNode(Graph g, Vertice w) {
		Node n = g.addNode();
		n.set("id", w.hashCode());
		n.set("label", w.getLabel());
		n.set("d", w.getD());
		n.set("hasDefinition", 1);
		return n;
	}
}
