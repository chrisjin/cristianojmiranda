package br.com.cjm.mega.datatype;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.List;
import java.util.Set;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToMany;
import javax.persistence.Table;

/**
 * Concurso Transfer Object.
 * 
 * @author Cristiano
 * 
 */
@Entity
@Table(name = "TbConcurso")
public class ConcursoTO implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 7063547089330233831L;

	@Id
	@Column(name = "id")
	private Long id;

	@Column(name = "dtSorteio")
	private Date dtSorteio;

	@Column(name = "vrArrecadacao")
	private Float vrArrecadacao = new Float(0);

	@Column(name = "qtGanhadoresSena")
	private Integer qtGanhadoresSena = new Integer(0);

	@Column(name = "vrRateioSena")
	private Float vrRateioSena = new Float(0);

	@Column(name = "qtGanhadoresQuina")
	private Integer qtGanhadoresQuina = new Integer(0);

	@Column(name = "vrRateioQuina")
	private Float vrRateioQuina = new Float(0);

	@Column(name = "qtGanhadoresQuadra")
	private Integer qtGanhadoresQuadra = new Integer(0);

	@Column(name = "vrRateioQuadra")
	private Float vrRateioQuadra = new Float(0);

	@Column(name = "flAcumulado")
	private Boolean flAcumulado = Boolean.FALSE;

	@Column(name = "vrEstimativaPremio")
	private Float vrEstimativaPremio = new Float(0);

	@Column(name = "vrAcumuladoNatal")
	private Float vrAcumuladoNatal = new Float(0);

	@OneToMany(cascade = CascadeType.ALL, fetch = FetchType.EAGER)
	@JoinColumn(name = "idConcurso")
	private List<DezenaTO> dezenas = new ArrayList<DezenaTO>();

	/**
	 * @return the dezenas
	 */
	public List<DezenaTO> getDezenas() {
		return dezenas;
	}

	/**
	 * @param dezenas
	 *            the dezenas to set
	 */
	public void setDezenas(List<DezenaTO> dezenas) {
		this.dezenas = dezenas;
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
	 * @return the dtSorteio
	 */
	public Date getDtSorteio() {
		return dtSorteio;
	}

	/**
	 * @param dtSorteio
	 *            the dtSorteio to set
	 */
	public void setDtSorteio(Date dtSorteio) {
		this.dtSorteio = dtSorteio;
	}

	/**
	 * @return the vrArrecadacao
	 */
	public Float getVrArrecadacao() {
		return vrArrecadacao;
	}

	/**
	 * @param vrArrecadacao
	 *            the vrArrecadacao to set
	 */
	public void setVrArrecadacao(Float vrArrecadacao) {
		this.vrArrecadacao = vrArrecadacao;
	}

	/**
	 * @return the qtGanhadoresSena
	 */
	public Integer getQtGanhadoresSena() {
		return qtGanhadoresSena;
	}

	/**
	 * @param qtGanhadoresSena
	 *            the qtGanhadoresSena to set
	 */
	public void setQtGanhadoresSena(Integer qtGanhadoresSena) {
		this.qtGanhadoresSena = qtGanhadoresSena;
	}

	/**
	 * @return the vrRateioSena
	 */
	public Float getVrRateioSena() {
		return vrRateioSena;
	}

	/**
	 * @param vrRateioSena
	 *            the vrRateioSena to set
	 */
	public void setVrRateioSena(Float vrRateioSena) {
		this.vrRateioSena = vrRateioSena;
	}

	/**
	 * @return the qtGanhadoresQuina
	 */
	public Integer getQtGanhadoresQuina() {
		return qtGanhadoresQuina;
	}

	/**
	 * @param qtGanhadoresQuina
	 *            the qtGanhadoresQuina to set
	 */
	public void setQtGanhadoresQuina(Integer qtGanhadoresQuina) {
		this.qtGanhadoresQuina = qtGanhadoresQuina;
	}

	/**
	 * @return the vrRateioQuina
	 */
	public Float getVrRateioQuina() {
		return vrRateioQuina;
	}

	/**
	 * @param vrRateioQuina
	 *            the vrRateioQuina to set
	 */
	public void setVrRateioQuina(Float vrRateioQuina) {
		this.vrRateioQuina = vrRateioQuina;
	}

	/**
	 * @return the qtGanhadoresQuadra
	 */
	public Integer getQtGanhadoresQuadra() {
		return qtGanhadoresQuadra;
	}

	/**
	 * @param qtGanhadoresQuadra
	 *            the qtGanhadoresQuadra to set
	 */
	public void setQtGanhadoresQuadra(Integer qtGanhadoresQuadra) {
		this.qtGanhadoresQuadra = qtGanhadoresQuadra;
	}

	/**
	 * @return the vrRateioQuadra
	 */
	public Float getVrRateioQuadra() {
		return vrRateioQuadra;
	}

	/**
	 * @param vrRateioQuadra
	 *            the vrRateioQuadra to set
	 */
	public void setVrRateioQuadra(Float vrRateioQuadra) {
		this.vrRateioQuadra = vrRateioQuadra;
	}

	/**
	 * @return the flAcumulado
	 */
	public Boolean getFlAcumulado() {
		return flAcumulado;
	}

	/**
	 * @param flAcumulado
	 *            the flAcumulado to set
	 */
	public void setFlAcumulado(Boolean flAcumulado) {
		this.flAcumulado = flAcumulado;
	}

	/**
	 * @return the vrEstimativaPremio
	 */
	public Float getVrEstimativaPremio() {
		return vrEstimativaPremio;
	}

	/**
	 * @param vrEstimativaPremio
	 *            the vrEstimativaPremio to set
	 */
	public void setVrEstimativaPremio(Float vrEstimativaPremio) {
		this.vrEstimativaPremio = vrEstimativaPremio;
	}

	/**
	 * @return the vrAcumuladoNatal
	 */
	public Float getVrAcumuladoNatal() {
		return vrAcumuladoNatal;
	}

	/**
	 * @param vrAcumuladoNatal
	 *            the vrAcumuladoNatal to set
	 */
	public void setVrAcumuladoNatal(Float vrAcumuladoNatal) {
		this.vrAcumuladoNatal = vrAcumuladoNatal;
	}

	/**
	 * Obtem uma lista ordenada com as dezenas do concurso
	 * 
	 * @return
	 */
	public List<Integer> obtemDezenasOrdenada() {

		List<Integer> dezenas = new ArrayList<Integer>();

		if (this.dezenas != null) {

			for (DezenaTO d : this.dezenas) {

				dezenas.add(d.getVrDezena());
			}

			Collections.sort(dezenas);
		}

		return dezenas;

	}

	/**
	 * Obtem uma relação com as possiveis quinas para o concurso
	 * 
	 * @return
	 */
	public List<List<Integer>> obtemPossiveisQuinas() {

		List<List<Integer>> result = new ArrayList<List<Integer>>();

		List<Integer> dezenas = obtemDezenasOrdenada();

		if (!dezenas.isEmpty()) {

			for (int i = 0; i < dezenas.size(); i++) {

				List<Integer> q = new ArrayList<Integer>(5);
				for (int j = 0; j < dezenas.size(); j++) {

					if (j != i) {

						q.add(dezenas.get(j));

					}

				}

				result.add(q);

			}

		}

		return result;

	}

	/**
	 * Verifica a pontuação de uma aposta no concurso
	 * 
	 * @param aposta
	 * @return
	 */
	public Integer verificarPontuacaoConcurso(Set<Integer> aposta) {

		Integer pontos = new Integer(0);

		if (this.dezenas != null && aposta != null) {

			for (DezenaTO dezena : this.dezenas) {

				if (aposta.contains(dezena.getVrDezena())) {

					pontos++;

				}

			}

		}

		return pontos;

	}
}
