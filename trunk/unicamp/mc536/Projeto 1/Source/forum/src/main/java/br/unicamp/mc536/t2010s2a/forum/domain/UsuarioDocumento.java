package br.unicamp.mc536.t2010s2a.forum.domain;

import javax.persistence.Entity;
import org.springframework.roo.addon.javabean.RooJavaBean;
import org.springframework.roo.addon.tostring.RooToString;
import org.springframework.roo.addon.entity.RooEntity;
import br.unicamp.mc536.t2010s2a.forum.domain.Usuario;
import javax.validation.constraints.NotNull;
import javax.persistence.ManyToOne;
import javax.persistence.JoinColumn;
import br.unicamp.mc536.t2010s2a.forum.domain.Documento;
import java.util.Date;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import org.springframework.format.annotation.DateTimeFormat;

@Entity
@RooJavaBean
@RooToString
@RooEntity
public class UsuarioDocumento {

    @NotNull
    @ManyToOne(targetEntity = Usuario.class)
    @JoinColumn
    private Usuario idUsuario;

    @NotNull
    @ManyToOne(targetEntity = Documento.class)
    @JoinColumn
    private Documento idDocumento;

    @NotNull
    @Temporal(TemporalType.TIMESTAMP)
    @DateTimeFormat(style = "S-")
    private Date dtInclusao;
}
