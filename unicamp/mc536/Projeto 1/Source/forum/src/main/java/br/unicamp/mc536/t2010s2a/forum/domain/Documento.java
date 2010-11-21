package br.unicamp.mc536.t2010s2a.forum.domain;

import java.sql.Blob;
import java.util.Date;
import java.util.List;

import javax.persistence.Entity;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.persistence.Transient;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;

import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.roo.addon.entity.RooEntity;
import org.springframework.roo.addon.javabean.RooJavaBean;
import org.springframework.roo.addon.tostring.RooToString;

import br.unicamp.mc536.t2010s2a.forum.web.dto.FileUploadBean;

@Entity
@RooJavaBean
@RooToString
@RooEntity
public class Documento {

	@NotNull
	@Size(max = 255)
	private String nmDocumento;

	@NotNull
	@Size(max = 2000)
	private String dsDocumento;

	@NotNull
	@Size(max = 255)
	private String nmArquivo;

	private String dsInfoMaquina;

	@NotNull
	@ManyToOne(targetEntity = TipoDocumento.class)
	@JoinColumn
	private TipoDocumento tipoDocumento;

	@NotNull
	@Temporal(TemporalType.TIMESTAMP)
	@DateTimeFormat(style = "S-")
	private Date dtCriacao;

	@NotNull
	@Temporal(TemporalType.TIMESTAMP)
	@DateTimeFormat(style = "S-")
	private Date dtInclusao;

	private String nmAutor;

	@Size(max = 100)
	private String dsEmailAutor;

	@NotNull
	@ManyToOne(targetEntity = Idioma.class)
	@JoinColumn
	private Idioma idIdiomaDocumento;

	@ManyToOne(targetEntity = Usuario.class)
	@JoinColumn
	private Usuario idUsuarioResponsavel;

	@ManyToOne(targetEntity = Usuario.class)
	@JoinColumn
	private Usuario idUsuarioAutor;

	@NotNull
	private Long qtdVisualizacao;

	@ManyToOne(targetEntity = Programa.class)
	@JoinColumn
	private Programa idPrograma;

	@ManyToOne(targetEntity = RedeTrabalho.class)
	@JoinColumn
	private RedeTrabalho idRedeTrabalho;

	@NotNull
	@ManyToOne(targetEntity = Pais.class)
	@JoinColumn
	private Pais idPais;

	@Transient
	private FileUploadBean fileUploadBean;

	private Blob documento;

	@Transient
	private List<PalavraDocumento> palavrasAssociadas;

	@Transient
	private List<ComentarioDocumento> comentarios;

	@Transient
	private List<UsuarioDocumento> usuariosVinculados;

	@Transient
	private List<DescricaoDocumento> descricaoDocumentos;

	@Transient
	private List<DocumentoVinculo> vinculos;

	@Transient
	private List<DocumentoReferenciaPais> referenciaPaises;

	@Transient
	private String aux1;

	@Transient
	private String aux2;

	@Transient
	private String aux3;

}
