package br.unicamp.ic.controle.patrimonial.domain;

import org.springframework.roo.addon.entity.RooEntity;
import org.springframework.roo.addon.javabean.RooJavaBean;
import org.springframework.roo.addon.tostring.RooToString;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;

@RooJavaBean
@RooToString
@RooEntity
public class Categoria {

    @NotNull
    @Size(min = 1, max = 100)
    private String nome;

    @NotNull
    @Size(min = 1, max = 500)
    private String descricao;
}
