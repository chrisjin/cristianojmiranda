package br.unicamp.ic.controle.patrimonial.domain;

import org.springframework.roo.addon.entity.RooEntity;
import org.springframework.roo.addon.javabean.RooJavaBean;
import org.springframework.roo.addon.tostring.RooToString;
import br.unicamp.ic.controle.patrimonial.domain.TipoNotificacao;
import javax.validation.constraints.NotNull;
import javax.persistence.ManyToOne;
import java.util.Calendar;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import org.springframework.format.annotation.DateTimeFormat;
import br.unicamp.ic.controle.patrimonial.domain.Usuario;
import javax.validation.constraints.Size;
import br.unicamp.ic.controle.patrimonial.reference.StatusNotificacaoEnum;
import javax.persistence.Enumerated;

@RooJavaBean
@RooToString
@RooEntity
public class Notificacao {

    @NotNull
    @ManyToOne
    private TipoNotificacao tipoNotificacao;

    @NotNull
    @Temporal(TemporalType.TIMESTAMP)
    @DateTimeFormat(style = "S-")
    private Calendar dtCriacao;

    @NotNull
    @Temporal(TemporalType.TIMESTAMP)
    @DateTimeFormat(style = "S-")
    private Calendar dtAtualizacao;

    @NotNull
    @ManyToOne
    private Usuario usuarioResponsavel;

    @NotNull
    @ManyToOne
    private Usuario usuarioAnalise;

    @NotNull
    @Size(min = 1, max = 1000)
    private String descricao;

    @Size(max = 1000)
    private String observacao;

    @NotNull
    @Enumerated
    private StatusNotificacaoEnum ativo;
}
