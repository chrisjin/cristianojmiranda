package br.unicamp.ic.controle.patrimonial.domain;

import org.springframework.roo.addon.entity.RooEntity;
import org.springframework.roo.addon.javabean.RooJavaBean;
import org.springframework.roo.addon.tostring.RooToString;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;
import br.unicamp.ic.controle.patrimonial.reference.EnabledEnum;
import javax.persistence.Enumerated;

@RooJavaBean
@RooToString
@RooEntity
public class TipoNotificacao {

    @NotNull
    @Size(min = 1, max = 20)
    private String tipo;

    @NotNull
    @Size(min = 1, max = 1000)
    private String descricao;

    @NotNull
    @Enumerated
    private EnabledEnum ativo;
}
