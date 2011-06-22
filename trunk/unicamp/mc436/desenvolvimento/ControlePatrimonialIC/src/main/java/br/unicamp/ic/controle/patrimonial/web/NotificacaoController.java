package br.unicamp.ic.controle.patrimonial.web;

import br.unicamp.ic.controle.patrimonial.domain.Notificacao;
import org.springframework.roo.addon.web.mvc.controller.RooWebScaffold;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@RooWebScaffold(path = "notificacaos", formBackingObject = Notificacao.class)
@RequestMapping("/notificacaos")
@Controller
public class NotificacaoController {
}
