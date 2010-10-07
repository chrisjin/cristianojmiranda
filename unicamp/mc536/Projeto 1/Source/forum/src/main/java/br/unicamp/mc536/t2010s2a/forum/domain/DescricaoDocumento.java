package br.unicamp.mc536.t2010s2a.forum.domain;

import javax.persistence.Entity;
import org.springframework.roo.addon.javabean.RooJavaBean;
import org.springframework.roo.addon.tostring.RooToString;
import org.springframework.roo.addon.entity.RooEntity;
import br.unicamp.mc536.t2010s2a.forum.domain.Documento;
import javax.validation.constraints.NotNull;
import javax.persistence.ManyToOne;
import javax.persistence.JoinColumn;
import br.unicamp.mc536.t2010s2a.forum.domain.Idioma;

@Entity
@RooJavaBean
@RooToString
@RooEntity
public class DescricaoDocumento {

    @NotNull
    @ManyToOne(targetEntity = Documento.class)
    @JoinColumn
    private Documento idDocumento;

    @NotNull
    private String dsDocumento;

    @NotNull
    @ManyToOne(targetEntity = Idioma.class)
    @JoinColumn
    private Idioma idIdiomaDocumento;
}
