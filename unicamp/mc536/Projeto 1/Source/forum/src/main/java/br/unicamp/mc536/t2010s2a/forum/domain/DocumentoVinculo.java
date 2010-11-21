package br.unicamp.mc536.t2010s2a.forum.domain;

import javax.persistence.Entity;
import org.springframework.roo.addon.javabean.RooJavaBean;
import org.springframework.roo.addon.tostring.RooToString;
import org.springframework.roo.addon.entity.RooEntity;
import br.unicamp.mc536.t2010s2a.forum.domain.Documento;
import javax.validation.constraints.NotNull;
import javax.persistence.ManyToOne;
import javax.persistence.JoinColumn;
import br.unicamp.mc536.t2010s2a.forum.domain.Usuario;
import java.util.Date;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import org.springframework.format.annotation.DateTimeFormat;
import br.unicamp.mc536.t2010s2a.forum.reference.ReferenciaDocumento;
import javax.persistence.Enumerated;

@Entity
@RooJavaBean
@RooToString
@RooEntity
public class DocumentoVinculo {

    @NotNull
    @ManyToOne(targetEntity = Documento.class)
    @JoinColumn
    private Documento idDocumento;
    
    @NotNull
    @ManyToOne(targetEntity = Documento.class)
    @JoinColumn
    private Documento idDocumentoVinculo;

    @NotNull
    @ManyToOne(targetEntity = Usuario.class)
    @JoinColumn
    private Usuario idUsuario;

    @NotNull
    @Temporal(TemporalType.TIMESTAMP)
    @DateTimeFormat(style = "S-")
    private Date dtInclusao;

    @NotNull
    @Enumerated
    private ReferenciaDocumento tpReferenciaDocumento;

    @NotNull
    private String dsVinculo;
}
