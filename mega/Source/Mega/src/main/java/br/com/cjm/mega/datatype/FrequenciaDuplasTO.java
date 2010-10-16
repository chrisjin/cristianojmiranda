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
@Table(name = "TbFrequenciaDuplas")
public class FrequenciaDuplasTO implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 7063548933330233831L;

	@Id
	@Column(name = "id")
	@GeneratedValue(strategy = GenerationType.AUTO)
	private Long id;

	@Column(name = "dezena1")
	private Integer dezena1;

	@Column(name = "dezena2")
	private Integer dezena2;

	@Column(name = "qtdSorteada")
	private Long qtdSorteada = 0L;

	@Column(name = "atrasoAtual")
	private Long atrasoAtual = 0L;

	@Column(name = "atrasoUltimo")
	private Long atrasoUltimo = 0L;

	@Column(name = "atrasoMaior")
	private Long atrasoMaior = 0L;

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
	 * @return the qtdSorteada
	 */
	public Long getQtdSorteada() {
		return qtdSorteada;
	}

	/**
	 * @return the dezena1
	 */
	public Integer getDezena1() {
		return dezena1;
	}

	/**
	 * @param dezena1
	 *            the dezena1 to set
	 */
	public void setDezena1(Integer dezena1) {
		this.dezena1 = dezena1;
	}

	/**
	 * @return the dezena2
	 */
	public Integer getDezena2() {
		return dezena2;
	}

	/**
	 * @param dezena2
	 *            the dezena2 to set
	 */
	public void setDezena2(Integer dezena2) {
		this.dezena2 = dezena2;
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
