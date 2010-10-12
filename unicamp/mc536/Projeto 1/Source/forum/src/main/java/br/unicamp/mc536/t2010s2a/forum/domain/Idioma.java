package br.unicamp.mc536.t2010s2a.forum.domain;

import javax.persistence.Entity;
import org.springframework.roo.addon.javabean.RooJavaBean;
import org.springframework.roo.addon.tostring.RooToString;
import org.springframework.roo.addon.entity.RooEntity;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;
import br.unicamp.mc536.t2010s2a.forum.domain.Pais;
import javax.persistence.ManyToOne;
import javax.persistence.JoinColumn;

@Entity
@RooJavaBean
@RooToString
@RooEntity
public class Idioma {

	@NotNull
	@Size(max = 50)
	private String nmIdioma;

	@NotNull
	@Size(min = 2, max = 4)
	private String sgIdioma;

	@NotNull
	@Size(max = 255)
	private String dsIdioma;

	private String dsDetalhadaIdioma;

	@Size(max = 255)
	private String nmRegiao;

	@NotNull
	@ManyToOne(targetEntity = Pais.class)
	@JoinColumn
	private Pais idPais;
}
