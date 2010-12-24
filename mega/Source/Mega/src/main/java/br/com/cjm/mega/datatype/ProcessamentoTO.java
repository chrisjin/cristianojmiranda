package br.com.cjm.mega.datatype;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;
import javax.persistence.Table;

/**
 * Concurso Transfer Object.
 * 
 * @author Cristiano
 * 
 */
@Entity
@Table(name = "TbProcessamento")
public class ProcessamentoTO implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 706388470893233831L;

	@Id
	@Column(name = "id")
	private Long id;

	@Column(name = "dtInicioProcessamento")
	private Date dtInicioProcessamento;

	@Column(name = "dtFimProcessamento")
	private Date dtFimProcessamento;

	@Column(name = "flStatus")
	private String flStatus;

	@Column(name = "flProcessamentoDezena")
	private String flProcessamentoDezena;

	@Column(name = "flProcessamentoDupla")
	private String flProcessamentoDupla;

	@Column(name = "flProcessamentoTrinca")
	private String flProcessamentoTrinca;

	@Column(name = "flProcessamentoQuadra")
	private String flProcessamentoQuadra;

	@Column(name = "flProcessamentoQuina")
	private String flProcessamentoQuina;

	@OneToOne(cascade = CascadeType.ALL, fetch = FetchType.EAGER)
	@JoinColumn(name = "id")
	private ConcursoTO concurso;

}
