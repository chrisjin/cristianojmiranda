package br.unicamp.ic.mc448.s12011.b.grafos.entidades;

import org.apache.commons.lang.builder.ToStringBuilder;
import org.apache.commons.lang.builder.ToStringStyle;

public class Aresta {

	public Aresta(Long peso, Vertice vertice1, Vertice vertice2) {
		super();
		this.peso = peso;
		this.vertice1 = vertice1;
		this.vertice2 = vertice2;
	}

	public Aresta(Long peso, Vertice vertice1, Vertice vertice2, String label) {
		super();
		this.peso = peso;
		this.vertice1 = vertice1;
		this.vertice2 = vertice2;
		this.label = label;
	}

	private String labelVertices;

	@Override
	public String toString() {
		return ToStringBuilder.reflectionToString(this,
				ToStringStyle.MULTI_LINE_STYLE);
	}

	public String getLabelVertices() {
		return labelVertices;
	}

	public void setLabelVertices(String labelVertices) {
		this.labelVertices = labelVertices;
	}

	private String label;
	private Long peso;
	private String descricao;

	private Vertice vertice1;
	private Vertice vertice2;

	public String getLabel() {
		return label;
	}

	public void setLabel(String label) {
		this.label = label;
	}

	public Long getPeso() {
		return peso;
	}

	public void setPeso(Long peso) {
		this.peso = peso;
	}

	public String getDescricao() {
		return descricao;
	}

	public void setDescricao(String descricao) {
		this.descricao = descricao;
	}

	public Vertice getVertice1() {
		return vertice1;
	}

	public void setVertice1(Vertice vertice1) {
		this.vertice1 = vertice1;
	}

	public Vertice getVertice2() {
		return vertice2;
	}

	public void setVertice2(Vertice vertice2) {
		this.vertice2 = vertice2;
	}

}
