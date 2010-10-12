package br.unicamp.mc536.t2010s2a.forum.domain;

import javax.persistence.Entity;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;

import org.springframework.roo.addon.entity.RooEntity;
import org.springframework.roo.addon.javabean.RooJavaBean;
import org.springframework.roo.addon.tostring.RooToString;

@Entity
@RooJavaBean
@RooToString
@RooEntity
public class Pais {

	@NotNull
	@Size(max = 50)
	private String nmPais;

	@NotNull
	private String dsPais;
}
