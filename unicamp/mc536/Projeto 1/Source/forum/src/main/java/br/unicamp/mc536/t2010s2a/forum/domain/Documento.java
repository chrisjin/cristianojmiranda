package br.unicamp.mc536.t2010s2a.forum.domain;

import javax.persistence.Entity;
import org.springframework.roo.addon.javabean.RooJavaBean;
import org.springframework.roo.addon.tostring.RooToString;
import org.springframework.roo.addon.entity.RooEntity;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;
import br.unicamp.mc536.t2010s2a.forum.domain.TipoDocumento;
import javax.persistence.ManyToOne;
import javax.persistence.JoinColumn;
import java.util.Date;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import org.springframework.format.annotation.DateTimeFormat;
import br.unicamp.mc536.t2010s2a.forum.domain.Idioma;
import br.unicamp.mc536.t2010s2a.forum.domain.Usuario;
import br.unicamp.mc536.t2010s2a.forum.domain.Programa;
import br.unicamp.mc536.t2010s2a.forum.domain.RedeTrabalho;
import br.unicamp.mc536.t2010s2a.forum.domain.Pais;

@Entity
@RooJavaBean
@RooToString
@RooEntity
public class Documento {

    @NotNull
    @Size(max = 255)
    private String nmDocumento;

    @NotNull
    @Size(max = 2000)
    private String dsDocumento;

    @NotNull
    @Size(max = 255)
    private String nmArquivo;

    private String dsInfoMaquina;

    @NotNull
    @ManyToOne(targetEntity = TipoDocumento.class)
    @JoinColumn
    private TipoDocumento tipoDocumento;

    @NotNull
    private String documento;

    @NotNull
    @Temporal(TemporalType.TIMESTAMP)
    @DateTimeFormat(style = "S-")
    private Date dtCriacao;

    @NotNull
    @Temporal(TemporalType.TIMESTAMP)
    @DateTimeFormat(style = "S-")
    private Date dtInclusao;

    private String nmAutor;

    @Size(max = 100)
    private String dsEmailAutor;

    @NotNull
    @ManyToOne(targetEntity = Idioma.class)
    @JoinColumn
    private Idioma idIdiomaDocumento;

    @ManyToOne(targetEntity = Usuario.class)
    @JoinColumn
    private Usuario idUsuarioResponsavel;

    @ManyToOne(targetEntity = Usuario.class)
    @JoinColumn
    private Usuario idUsuarioAutor;

    @NotNull
    private Long qtdVisualizacao;

    @ManyToOne(targetEntity = Programa.class)
    @JoinColumn
    private Programa idPrograma;

    @ManyToOne(targetEntity = RedeTrabalho.class)
    @JoinColumn
    private RedeTrabalho idRedeTrabalho;

    @NotNull
    @ManyToOne(targetEntity = Pais.class)
    @JoinColumn
    private Pais idPais;
}
