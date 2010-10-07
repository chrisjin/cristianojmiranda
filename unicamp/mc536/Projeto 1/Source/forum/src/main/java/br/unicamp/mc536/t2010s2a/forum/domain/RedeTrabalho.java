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
import java.util.Date;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import org.springframework.format.annotation.DateTimeFormat;

@Entity
@RooJavaBean
@RooToString
@RooEntity
public class RedeTrabalho {

    @NotNull
    @Size(max = 255)
    private String nmRedetrabalho;

    @NotNull
    @Size(max = 255)
    private String dsRedetrabalho;

    private String dsDetalhadoRedetrabalho;

    @NotNull
    @ManyToOne(targetEntity = Usuario.class)
    @JoinColumn
    private Usuario idUsuario;

    @NotNull
    @Temporal(TemporalType.TIMESTAMP)
    @DateTimeFormat(style = "S-")
    private Date dtInclusao;
}
