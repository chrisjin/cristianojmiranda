package br.unicamp.ic.controle.patrimonial.web;

import br.unicamp.ic.controle.patrimonial.domain.TipoNotificacao;
import org.springframework.roo.addon.web.mvc.controller.RooWebScaffold;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@RooWebScaffold(path = "tiponotificacaos", formBackingObject = TipoNotificacao.class)
@RequestMapping("/tiponotificacaos")
@Controller
public class TipoNotificacaoController {
}
