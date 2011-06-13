package br.unicamp.ic.mc448.s12011.b.grafos.entidades;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import br.unicamp.ic.mc448.s12011.b.grafos.entidades.enums.SEARCH_STATUS;

/**
 * Representação de um vertice no grafo.
 * 
 * @author Cristiano
 * 
 */
public class Vertice implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private String label;

	/** Atributos utilizados nos metodos de busca */
	private SEARCH_STATUS status = SEARCH_STATUS.NAO_VISITADO;
	private Long d;
	private Long f;
	private Vertice pi;
	private String descricao;

	private List<Aresta> arestasIncidentes = new ArrayList<Aresta>();
	private List<Aresta> arestaEntrada = new ArrayList<Aresta>();
	private List<Aresta> arestaSaida = new ArrayList<Aresta>();
	private Grafo grafo;

	public Long getD() {
		return d;
	}

	public void setD(Long d) {
		this.d = d;
	}

	public Vertice getPi() {
		return pi;
	}

	public void setPi(Vertice pi) {
		this.pi = pi;
	}

	public SEARCH_STATUS getStatus() {
		return status;
	}

	public void setStatus(SEARCH_STATUS status) {
		this.status = status;
	}

	public Vertice(String label, String descricao, Grafo g) {
		super();
		this.label = label;
		this.descricao = descricao;
		this.grafo = g;
	}

	public Vertice(Vertice v, Grafo g) {
		super();
		this.label = v.getLabel();
		this.descricao = v.getDescricao();
		this.grafo = g;
	}

	@Override
	public String toString() {

		StringBuffer buff = new StringBuffer();

		buff.append(super.toString());
		buff.append("[");

		buff.append("label=");
		buff.append(this.label);
		buff.append(",");

		buff.append("descricao=");
		buff.append(this.descricao);
		buff.append(",");

		buff.append("d=");
		buff.append(this.d);
		buff.append(",");

		buff.append("pi=");
		buff.append(this.pi);
		buff.append(",");

		buff.append("status=");
		buff.append(this.status);

		buff.append("]");

		return buff.toString();

	}

	public Vertice() {
		super();
	}

	public Vertice(String label) {
		super();
		this.label = label;
	}

	public String getDescricao() {
		return descricao;
	}

	public void setDescricao(String descricao) {
		this.descricao = descricao;
	}

	public String getLabel() {
		return label;
	}

	public void setLabel(String label) {
		this.label = label;
	}

	public int getGrau() {

		return this.obterVerticesAdjacentes().size();

	}

	public int getGrauEntrada() {
		return this.getArestaEntrada().size();
	}

	public int getGrauSaida() {
		return this.getArestaSaida().size();
	}

	/**
	 * @return the arestasIncidentes
	 */
	public List<Aresta> getArestasIncidentes() {
		return arestasIncidentes;
	}

	/**
	 * @param arestasIncidentes
	 *            the arestasIncidentes to set
	 */
	public void setArestasIncidentes(List<Aresta> arestasIncidentes) {
		this.arestasIncidentes = arestasIncidentes;
	}

	/**
	 * @return the arestaEntrada
	 */
	public List<Aresta> getArestaEntrada() {
		return arestaEntrada;
	}

	/**
	 * @param arestaEntrada
	 *            the arestaEntrada to set
	 */
	public void setArestaEntrada(List<Aresta> arestaEntrada) {
		this.arestaEntrada = arestaEntrada;
	}

	/**
	 * @return the arestaSaida
	 */
	public List<Aresta> getArestaSaida() {
		return arestaSaida;
	}

	/**
	 * @param arestaSaida
	 *            the arestaSaida to set
	 */
	public void setArestaSaida(List<Aresta> arestaSaida) {
		this.arestaSaida = arestaSaida;
	}

	/**
	 * @return the grafo
	 */
	public Grafo getGrafo() {
		return grafo;
	}

	/**
	 * @param grafo
	 *            the grafo to set
	 */
	public void setGrafo(Grafo grafo) {
		this.grafo = grafo;
	}

	/**
	 * Obtem os vertices adjacentes ao vertice atual. Caso o grafo seja
	 * orientado, retorna os vertices ao qual o vertice atual tem acesso.
	 * 
	 * @return
	 */
	public List<Vertice> obterVerticesAdjacentes() {

		List<Vertice> adjList = new ArrayList<Vertice>();

		// Caso o grafo seja orientado
		if (this.grafo.isOrientado()) {

			for (Aresta aresta : this.arestaSaida) {

				if (aresta.getVertice1() == this) {
					adjList.add(aresta.getVertice2());
				} else {
					adjList.add(aresta.getVertice1());
				}

			}

		} else {

			for (Aresta aresta : this.arestasIncidentes) {

				if (aresta.getVertice1() == this) {
					adjList.add(aresta.getVertice2());
				} else {
					adjList.add(aresta.getVertice1());

				}

			}

		}

		return adjList;
	}

	/**
	 * @return the f
	 */
	public Long getF() {
		return f;
	}

	/**
	 * @param f
	 *            the f to set
	 */
	public void setF(Long f) {
		this.f = f;
	}
}
