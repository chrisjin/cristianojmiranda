package br.unicamp.ic.controle.patrimonial.web;

import br.unicamp.ic.controle.patrimonial.domain.LocalizacaoItem;
import org.springframework.roo.addon.web.mvc.controller.RooWebScaffold;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@RooWebScaffold(path = "localizacaoitems", formBackingObject = LocalizacaoItem.class)
@RequestMapping("/localizacaoitems")
@Controller
public class LocalizacaoItemController {
}
