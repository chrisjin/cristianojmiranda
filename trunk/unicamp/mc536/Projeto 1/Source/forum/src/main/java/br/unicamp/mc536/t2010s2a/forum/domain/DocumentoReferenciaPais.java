package br.unicamp.mc536.t2010s2a.forum.domain;

import javax.persistence.Entity;
import org.springframework.roo.addon.javabean.RooJavaBean;
import org.springframework.roo.addon.tostring.RooToString;
import org.springframework.roo.addon.entity.RooEntity;
import br.unicamp.mc536.t2010s2a.forum.domain.Pais;
import javax.validation.constraints.NotNull;
import javax.persistence.ManyToOne;
import javax.persistence.JoinColumn;
import br.unicamp.mc536.t2010s2a.forum.domain.Documento;

@Entity
@RooJavaBean
@RooToString
@RooEntity
public class DocumentoReferenciaPais {

    @NotNull
    @ManyToOne(targetEntity = Pais.class)
    @JoinColumn
    private Pais idPais;

    @NotNull
    @ManyToOne(targetEntity = Documento.class)
    @JoinColumn
    private Documento idDocumento;
}
