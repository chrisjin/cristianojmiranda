package br.unicamp.mc536.t2010s2a.forum.domain;

import javax.persistence.Entity;
import org.springframework.roo.addon.javabean.RooJavaBean;
import org.springframework.roo.addon.tostring.RooToString;
import org.springframework.roo.addon.entity.RooEntity;
import br.unicamp.mc536.t2010s2a.forum.domain.Usuario;
import javax.persistence.ManyToOne;
import javax.persistence.JoinColumn;
import javax.persistence.Transient;

import br.unicamp.mc536.t2010s2a.forum.domain.Documento;
import javax.validation.constraints.NotNull;
import java.util.Date;
import java.util.List;

import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import org.springframework.format.annotation.DateTimeFormat;
import br.unicamp.mc536.t2010s2a.forum.reference.ReferenciaDocumento;
import javax.persistence.Enumerated;

@Entity
@RooJavaBean
@RooToString
@RooEntity
public class ComentarioDocumento {

	@ManyToOne(targetEntity = Usuario.class)
	@JoinColumn
	private Usuario idUsuario;

	@NotNull
	@ManyToOne(targetEntity = Documento.class)
	@JoinColumn
	private Documento idDocumento;

	@NotNull
	private String dsComentario;

	@NotNull
	@Temporal(TemporalType.TIMESTAMP)
	@DateTimeFormat(style = "S-")
	private Date dtInclusao;

	@ManyToOne(targetEntity = br.unicamp.mc536.t2010s2a.forum.domain.ComentarioDocumento.class)
	@JoinColumn
	private br.unicamp.mc536.t2010s2a.forum.domain.ComentarioDocumento idComentario;

	@NotNull
	@Enumerated
	private ReferenciaDocumento tpReferenciaDocumento;

	@Transient
	private Long idComentarioPai;

	@Transient
	private List<ComentarioDocumento> comentariosFilhos;
}
