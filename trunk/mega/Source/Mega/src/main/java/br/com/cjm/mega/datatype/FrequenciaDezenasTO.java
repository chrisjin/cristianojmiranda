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
	private Long qtdSorteada;

	@Column(name = "atrasoAtual")
	private Long atrasoAtual;

	@Column(name = "atrasoUltimo")
	private Long atrasoUltimo;

	@Column(name = "atrasoMaior")
	private Long atrasoMaior;

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

}
