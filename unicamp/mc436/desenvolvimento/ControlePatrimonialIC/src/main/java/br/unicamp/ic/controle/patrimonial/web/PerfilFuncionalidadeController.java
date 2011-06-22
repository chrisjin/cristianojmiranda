package br.unicamp.ic.controle.patrimonial.web;

import br.unicamp.ic.controle.patrimonial.domain.PerfilFuncionalidade;
import org.springframework.roo.addon.web.mvc.controller.RooWebScaffold;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@RooWebScaffold(path = "perfilfuncionalidades", formBackingObject = PerfilFuncionalidade.class)
@RequestMapping("/perfilfuncionalidades")
@Controller
public class PerfilFuncionalidadeController {
}
