package br.com.cjm.mega.datatype;

import java.io.Serializable;
import java.util.List;

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
@Table(name = "TbFrequenciaQuinas")
public class FrequenciaQuinaTO implements Serializable {

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

	@Column(name = "dezena3")
	private Integer dezena3;

	@Column(name = "dezena4")
	private Integer dezena4;

	@Column(name = "dezena5")
	private Integer dezena5;

	@Column(name = "qtdSorteada")
	private Long qtdSorteada = 0L;

	@Column(name = "atrasoAtual")
	private Long atrasoAtual = 0L;

	@Column(name = "atrasoUltimo")
	private Long atrasoUltimo = 0L;

	@Column(name = "atrasoMaior")
	private Long atrasoMaior = 0L;

	public FrequenciaQuinaTO() {

	}

	/**
	 * Cria uma frequencia a partir da lista de quinas.
	 * 
	 * @param quina
	 */
	public FrequenciaQuinaTO(List<Integer> quina) {

		if (quina != null && quina.size() >= 5) {
			this.dezena1 = quina.get(0);
			this.dezena2 = quina.get(1);
			this.dezena3 = quina.get(2);
			this.dezena4 = quina.get(3);
			this.dezena5 = quina.get(4);
		}

	}

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

	/**
	 * @return the dezena3
	 */
	public Integer getDezena3() {
		return dezena3;
	}

	/**
	 * @param dezena3
	 *            the dezena3 to set
	 */
	public void setDezena3(Integer dezena3) {
		this.dezena3 = dezena3;
	}

	/**
	 * @return the dezena4
	 */
	public Integer getDezena4() {
		return dezena4;
	}

	/**
	 * @param dezena4
	 *            the dezena4 to set
	 */
	public void setDezena4(Integer dezena4) {
		this.dezena4 = dezena4;
	}

	/**
	 * @return the dezena5
	 */
	public Integer getDezena5() {
		return dezena5;
	}

	/**
	 * @param dezena5
	 *            the dezena5 to set
	 */
	public void setDezena5(Integer dezena5) {
		this.dezena5 = dezena5;
	}

	public String getInsertSQL() {

		StringBuffer bf = new StringBuffer();

		bf
				.append("INSERT INTO tbfrequenciaquinas(id, dezena1, dezena2, dezena3, dezena4, dezena5, qtdSorteada, atrasoAtual, atrasoUltimo, atrasoMaior) ");
		bf.append(" VALUES ( ");
		bf.append(this.id);
		bf.append(", ");
		bf.append(this.dezena1);
		bf.append(", ");
		bf.append(this.dezena2);
		bf.append(", ");
		bf.append(this.dezena3);
		bf.append(", ");
		bf.append(this.dezena4);
		bf.append(", ");
		bf.append(this.dezena5);
		bf.append(", ");
		bf.append(this.qtdSorteada);
		bf.append(", ");
		bf.append(this.atrasoAtual);
		bf.append(", ");
		bf.append(this.atrasoUltimo);
		bf.append(", ");
		bf.append(this.atrasoMaior);
		bf.append(")");

		return bf.toString();

	}
}
