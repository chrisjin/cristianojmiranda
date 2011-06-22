package br.unicamp.ic.controle.patrimonial.domain;

import org.springframework.roo.addon.entity.RooEntity;
import org.springframework.roo.addon.javabean.RooJavaBean;
import org.springframework.roo.addon.tostring.RooToString;
import br.unicamp.ic.controle.patrimonial.domain.Perfil;
import javax.validation.constraints.NotNull;
import javax.persistence.ManyToOne;
import br.unicamp.ic.controle.patrimonial.domain.Funcionalidade;

@RooJavaBean
@RooToString
@RooEntity
public class PerfilFuncionalidade {

    @NotNull
    @ManyToOne
    private Perfil perfil;

    @NotNull
    @ManyToOne
    private Funcionalidade funcionalidade;
}
