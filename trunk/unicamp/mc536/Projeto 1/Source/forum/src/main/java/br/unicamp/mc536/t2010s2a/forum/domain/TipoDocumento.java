package br.unicamp.mc536.t2010s2a.forum.domain;

import javax.persistence.Entity;

import org.hibernate.validator.constraints.NotBlank;
import org.springframework.roo.addon.javabean.RooJavaBean;
import org.springframework.roo.addon.tostring.RooToString;
import org.springframework.roo.addon.entity.RooEntity;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;

@Entity
@RooJavaBean
@RooToString
@RooEntity
public class TipoDocumento {

	@NotNull
	@NotBlank
	@Size(max = 50)
	private String nmTipoDocumento;

	@NotNull
	@NotBlank
	@Size(max = 255)
	private String dsTipoDocumento;

	private String dsDetalhadoTipoDocumento;
}
