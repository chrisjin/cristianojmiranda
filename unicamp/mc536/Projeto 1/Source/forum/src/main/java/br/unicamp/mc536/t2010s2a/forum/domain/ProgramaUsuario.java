package br.unicamp.mc536.t2010s2a.forum.domain;

import javax.persistence.Entity;
import org.springframework.roo.addon.javabean.RooJavaBean;
import org.springframework.roo.addon.tostring.RooToString;
import org.springframework.roo.addon.entity.RooEntity;
import br.unicamp.mc536.t2010s2a.forum.domain.Programa;
import javax.validation.constraints.NotNull;
import javax.persistence.ManyToOne;
import javax.persistence.JoinColumn;
import br.unicamp.mc536.t2010s2a.forum.domain.Usuario;

@Entity
@RooJavaBean
@RooToString
@RooEntity
public class ProgramaUsuario {

    @NotNull
    @ManyToOne(targetEntity = Programa.class)
    @JoinColumn
    private Programa idRedeTrabalho;

    @NotNull
    @ManyToOne(targetEntity = Usuario.class)
    @JoinColumn
    private Usuario idUsuario;
}
