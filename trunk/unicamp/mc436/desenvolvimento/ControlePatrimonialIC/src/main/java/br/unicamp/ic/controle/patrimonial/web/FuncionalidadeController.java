package br.unicamp.ic.controle.patrimonial.web;

import br.unicamp.ic.controle.patrimonial.domain.Funcionalidade;
import org.springframework.roo.addon.web.mvc.controller.RooWebScaffold;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@RooWebScaffold(path = "funcionalidades", formBackingObject = Funcionalidade.class)
@RequestMapping("/funcionalidades")
@Controller
public class FuncionalidadeController {
}
