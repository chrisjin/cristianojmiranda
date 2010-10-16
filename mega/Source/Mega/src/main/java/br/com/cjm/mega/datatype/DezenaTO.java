package br.com.cjm.mega.datatype;

import java.io.Serializable;

import javax.persistence.AttributeOverride;
import javax.persistence.AttributeOverrides;
import javax.persistence.Column;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import javax.persistence.Table;

/**
 * Dezena TO
 * 
 * @author Cristiano
 * 
 */
@Entity
@Table(name = "TbDezenas")
public class DezenaTO implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -152590484221958539L;

	@EmbeddedId
	@AttributeOverrides( {
			@AttributeOverride(name = "idConcurso", column = @Column(name = "idConcurso")),
			@AttributeOverride(name = "nuOrdem", column = @Column(name = "nuOrdem")) })
	private DezenaKey id;

	/**
	 * @return the vrDezena
	 */
	@Column(name = "vrDezena")
	public Integer getVrDezena() {
		return vrDezena;
	}

	/**
	 * @return the id
	 */
	public DezenaKey getId() {
		return id;
	}

	/**
	 * @param id
	 *            the id to set
	 */
	public void setId(DezenaKey id) {
		this.id = id;
	}

	/**
	 * @param vrDezena
	 *            the vrDezena to set
	 */
	public void setVrDezena(Integer vrDezena) {
		this.vrDezena = vrDezena;
	}

	private Integer vrDezena;

}
