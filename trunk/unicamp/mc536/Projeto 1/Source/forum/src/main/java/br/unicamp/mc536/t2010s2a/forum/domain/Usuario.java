package br.unicamp.mc536.t2010s2a.forum.domain;

import javax.persistence.Entity;
import org.springframework.roo.addon.javabean.RooJavaBean;
import org.springframework.roo.addon.tostring.RooToString;
import org.springframework.roo.addon.entity.RooEntity;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;
import br.unicamp.mc536.t2010s2a.forum.reference.UsuarioType;
import javax.persistence.Enumerated;
import br.unicamp.mc536.t2010s2a.forum.domain.Idioma;
import javax.persistence.ManyToOne;
import javax.persistence.JoinColumn;
import java.util.Date;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import org.springframework.format.annotation.DateTimeFormat;

@Entity
@RooJavaBean
@RooToString
@RooEntity
public class Usuario {

	@NotNull
	@Size(max = 255)
	private String nmUsuario;

	@NotNull
	@Size(min = 5, max = 10)
	private String dsLogin;

	@NotNull
	@Size(max = 10)
	private String dsSenha;

	@NotNull
	@Enumerated
	private UsuarioType tpUsuario;

	@NotNull
	private boolean flAtivo;

	@NotNull
	@ManyToOne(targetEntity = Idioma.class)
	@JoinColumn
	private Idioma idIdiomaNativo;

	@NotNull
	@Size(max = 255)
	private String email;

	@NotNull
	private boolean flInstitucional;

	@Size(max = 255)
	private String nmInstituicao;

	private String dsInstituicao;

	@NotNull
	@Temporal(TemporalType.TIMESTAMP)
	@DateTimeFormat(style = "S-")
	private Date dtInclusao;

}
