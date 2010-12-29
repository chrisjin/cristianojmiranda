package br.com.cjm.mega.datatype;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 * Frequencia Dezena Transfer Object.
 * 
 * @author Cristiano
 * 
 */
@Entity
@Table(name = "TbFrequenciaDezenas")
public class FrequenciaDezenasTO implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 70635489330233831L;

	@Id
	@Column(name = "id")
	@GeneratedValue(strategy = GenerationType.AUTO)
	private Long id;

	@Column(name = "dezena")
	private Integer dezena;

	@Column(name = "qtdSorteada")
	private Long qtdSorteada = 0L;

	@Column(name = "atrasoAtual")
	private Long atrasoAtual = 0L;

	@Column(name = "atrasoUltimo")
	private Long atrasoUltimo = 0L;

	@Column(name = "atrasoMaior")
	private Long atrasoMaior = 0L;

	/**
	 * 
	 * O seguinte gráfico 'ÍNDICE DE FORÇA RELATIVA DAS DEZENAS' é muito
	 * importante, pois é a base do IFRAP, abreviatura de 'Índice de Força
	 * Relativa da Aposta', cujo conceito foi copiado das bolsas de valores. O
	 * índice das dezenas (do gráfico abaixo) usa os valores vistos
	 * anteriormente de 'Frequencia acumulada' e 'Quanto tempo a dezena não sai'
	 * para aplica-los numa fórmula que produz um único número para cada dezena.
	 * Este número é um indicativo de quanto a dezena 'deseja ser sorteada' para
	 * ficar emparelhada com as outras.
	 * 
	 */
	@Column(name = "ifrap")
	private Float ifrap = 0f;

	/**
	 * @return the id
	 */
	public Long getId() {
		return id;
	}

	/**
	 * @param id
	 *            the id to set
	 */
	public void setId(Long id) {
		this.id = id;
	}

	/**
	 * @return the dezena
	 */
	public Integer getDezena() {
		return dezena;
	}

	/**
	 * @param dezena
	 *            the dezena to set
	 */
	public void setDezena(Integer dezena) {
		this.dezena = dezena;
	}

	/**
	 * @return the qtdSorteada
	 */
	public Long getQtdSorteada() {
		return qtdSorteada;
	}

	/**
	 * @param qtdSorteada
	 *            the qtdSorteada to set
	 */
	public void setQtdSorteada(Long qtdSorteada) {
		this.qtdSorteada = qtdSorteada;
	}

	/**
	 * @return the atrasoAtual
	 */
	public Long getAtrasoAtual() {
		return atrasoAtual;
	}

	/**
	 * @param atrasoAtual
	 *            the atrasoAtual to set
	 */
	public void setAtrasoAtual(Long atrasoAtual) {
		this.atrasoAtual = atrasoAtual;
	}

	/**
	 * @return the atrasoUltimo
	 */
	public Long getAtrasoUltimo() {
		return atrasoUltimo;
	}

	/**
	 * @param atrasoUltimo
	 *            the atrasoUltimo to set
	 */
	public void setAtrasoUltimo(Long atrasoUltimo) {
		this.atrasoUltimo = atrasoUltimo;
	}

	/**
	 * @return the atrasoMaior
	 */
	public Long getAtrasoMaior() {
		return atrasoMaior;
	}

	/**
	 * @param atrasoMaior
	 *            the atrasoMaior to set
	 */
	public void setAtrasoMaior(Long atrasoMaior) {
		this.atrasoMaior = atrasoMaior;
	}

	/**
	 * @return the ifrap
	 */
	public Float getIfrap() {
		return ifrap;
	}

	/**
	 * @param ifrap
	 *            the ifrap to set
	 */
	public void setIfrap(Float ifrap) {
		this.ifrap = ifrap;
	}

	public void processarIfrap() {

		if (this.atrasoAtual != null && this.qtdSorteada != null) {
			Float f1 = new Float((this.atrasoAtual + 20));
			Float f2 = new Float(Math.pow((this.qtdSorteada / 10F), 2));
			this.ifrap = f1 / f2;
		}

	}
}
