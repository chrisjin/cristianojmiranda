package br.unicamp.ic.controle.patrimonial.domain;

import org.springframework.roo.addon.entity.RooEntity;
import org.springframework.roo.addon.javabean.RooJavaBean;
import org.springframework.roo.addon.tostring.RooToString;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;
import br.unicamp.ic.controle.patrimonial.domain.Perfil;
import javax.persistence.ManyToOne;
import br.unicamp.ic.controle.patrimonial.domain.Area;
import br.unicamp.ic.controle.patrimonial.reference.EnabledEnum;
import javax.persistence.Enumerated;
import java.util.Calendar;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import org.springframework.format.annotation.DateTimeFormat;

@RooJavaBean
@RooToString
@RooEntity
public class Usuario {

    @NotNull
    @Size(min = 1, max = 100)
    private String nome;

    @NotNull
    @Size(min = 1, max = 200)
    private String email;

    @NotNull
    @Size(min = 1, max = 10)
    private String senha;

    @NotNull
    @Size(min = 1, max = 10)
    private String ramal;

    @NotNull
    @Size(min = 1, max = 50)
    private String sala;

    @NotNull
    @Size(min = 1, max = 1000)
    private String observacoes;

    @NotNull
    @ManyToOne
    private Perfil perfil;

    @NotNull
    @ManyToOne
    private Area area;

    @NotNull
    @Enumerated
    private EnabledEnum ativo;

    @NotNull
    @Temporal(TemporalType.TIMESTAMP)
    @DateTimeFormat(style = "S-")
    private Calendar dtCriacao;

    @NotNull
    @Temporal(TemporalType.TIMESTAMP)
    @DateTimeFormat(style = "S-")
    private Calendar dtAtualizacao;
}
