package br.unicamp.ic.controle.patrimonial.domain;

import org.springframework.roo.addon.entity.RooEntity;
import org.springframework.roo.addon.javabean.RooJavaBean;
import org.springframework.roo.addon.tostring.RooToString;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;
import br.unicamp.ic.controle.patrimonial.domain.Departamento;
import javax.persistence.ManyToOne;
import br.unicamp.ic.controle.patrimonial.reference.EnabledEnum;
import javax.persistence.Enumerated;
import java.util.Calendar;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import org.springframework.format.annotation.DateTimeFormat;

@RooJavaBean
@RooToString
@RooEntity
public class Area {

    @NotNull
    @Size(min = 1, max = 20)
    private String nome;

    @NotNull
    @Size(min = 1, max = 200)
    private String descricao;

    @NotNull
    @Size(min = 1, max = 200)
    private String endereco;

    @NotNull
    @Size(min = 1, max = 100)
    private String responsavel;

    @NotNull
    @ManyToOne
    private Departamento departamento;

    @NotNull
    @Enumerated
    private EnabledEnum ativo;

    @NotNull
    @Temporal(TemporalType.TIMESTAMP)
    @DateTimeFormat(style = "S-")
    private Calendar dtCriacao;
}
