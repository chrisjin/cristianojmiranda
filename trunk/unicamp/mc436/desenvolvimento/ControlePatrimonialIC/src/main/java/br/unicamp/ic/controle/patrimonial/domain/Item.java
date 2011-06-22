package br.unicamp.ic.controle.patrimonial.domain;

import org.springframework.roo.addon.entity.RooEntity;
import org.springframework.roo.addon.javabean.RooJavaBean;
import org.springframework.roo.addon.tostring.RooToString;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;
import br.unicamp.ic.controle.patrimonial.reference.StatusPatrimonioEnum;
import javax.persistence.Enumerated;
import br.unicamp.ic.controle.patrimonial.domain.Area;
import javax.persistence.ManyToOne;
import org.springframework.beans.factory.annotation.Value;
import java.util.Calendar;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import org.springframework.format.annotation.DateTimeFormat;
import br.unicamp.ic.controle.patrimonial.domain.Usuario;

@RooJavaBean
@RooToString
@RooEntity
public class Item {

    @NotNull
    @Size(min = 1, max = 20)
    private String pid;

    @Size(min = 1, max = 20)
    private String rfid;

    @NotNull
    @Size(min = 1, max = 200)
    private String nome;

    @NotNull
    @Size(min = 1, max = 100)
    private String categoria;

    @NotNull
    @Size(min = 1, max = 500)
    private String descricao;

    @NotNull
    @Enumerated
    private StatusPatrimonioEnum status;

    @ManyToOne
    private Area area;

    @NotNull
    @Value("N")
    @Size(min = 1, max = 1)
    private String flagFomento;

    @NotNull
    @Value("N")
    @Size(min = 1, max = 1)
    private String flagLiberarSaida;

    @Temporal(TemporalType.TIMESTAMP)
    @DateTimeFormat(style = "S-")
    private Calendar dtLiberacao;

    @NotNull
    @Temporal(TemporalType.TIMESTAMP)
    @DateTimeFormat(style = "S-")
    private Calendar dtCriacao;

    @NotNull
    @Temporal(TemporalType.TIMESTAMP)
    @DateTimeFormat(style = "S-")
    private Calendar dtAtualizacao;

    @ManyToOne
    private Usuario usuarioResponsavel;

    @ManyToOne
    private Usuario usuarioResponsavelAnterior;

    @NotNull
    @ManyToOne
    private Usuario usuarioAtualizacao;

    @Size(max = 1000)
    private String observacoes;
}
