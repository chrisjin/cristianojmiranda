package br.unicamp.mc536.t2010s2a.forum.domain;

import javax.persistence.Entity;
import org.springframework.roo.addon.javabean.RooJavaBean;
import org.springframework.roo.addon.tostring.RooToString;
import org.springframework.roo.addon.entity.RooEntity;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;
import br.unicamp.mc536.t2010s2a.forum.domain.Usuario;
import javax.persistence.ManyToOne;
import javax.persistence.JoinColumn;

@Entity
@RooJavaBean
@RooToString
@RooEntity
public class Programa {

    @NotNull
    @Size(max = 255)
    private String nmPrograma;

    @NotNull
    @Size(max = 255)
    private String dsPrograma;

    private String dsDetalhadaPrograma;

    @NotNull
    @ManyToOne(targetEntity = Usuario.class)
    @JoinColumn
    private Usuario idUsuario;
}
