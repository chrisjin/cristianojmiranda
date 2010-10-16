package br.com.cjm.mega.datatype;

import java.io.Serializable;

/**
 * Dezena TO
 * 
 * @author Cristiano
 * 
 */
public class DezenaKey implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -1525904842958539L;

	private Integer nuOrdem;

	private Long idConcurso;

	/**
	 * @return the nuOrdem
	 */
	public Integer getNuOrdem() {
		return nuOrdem;
	}

	/**
	 * @param nuOrdem
	 *            the nuOrdem to set
	 */
	public void setNuOrdem(Integer nuOrdem) {
		this.nuOrdem = nuOrdem;
	}

	/**
	 * @return the idConcurso
	 */
	public Long getIdConcurso() {
		return idConcurso;
	}

	/**
	 * @param idConcurso
	 *            the idConcurso to set
	 */
	public void setIdConcurso(Long idConcurso) {
		this.idConcurso = idConcurso;
	}

}
