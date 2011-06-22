package br.unicamp.ic.controle.patrimonial.domain;

import org.springframework.roo.addon.entity.RooEntity;
import org.springframework.roo.addon.javabean.RooJavaBean;
import org.springframework.roo.addon.tostring.RooToString;
import br.unicamp.ic.controle.patrimonial.domain.Area;
import javax.validation.constraints.NotNull;
import javax.persistence.ManyToOne;
import javax.validation.constraints.Size;
import java.util.Calendar;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import org.springframework.format.annotation.DateTimeFormat;
import br.unicamp.ic.controle.patrimonial.domain.Item;
import br.unicamp.ic.controle.patrimonial.domain.Usuario;

@RooJavaBean
@RooToString
@RooEntity
public class LocalizacaoItem {

    @NotNull
    @ManyToOne
    private Area area;

    @NotNull
    @Size(min = 1, max = 1000)
    private String descricao;

    @NotNull
    @Temporal(TemporalType.TIMESTAMP)
    @DateTimeFormat(style = "S-")
    private Calendar dtAtualizacao;

    @NotNull
    @ManyToOne
    private Item item;

    @NotNull
    @ManyToOne
    private Usuario usuarioAtualizacao;

    @Size(max = 1000)
    private String observacoes;
}
