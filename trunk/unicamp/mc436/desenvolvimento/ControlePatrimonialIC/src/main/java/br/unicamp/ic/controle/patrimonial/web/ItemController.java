package br.unicamp.ic.controle.patrimonial.web;

import br.unicamp.ic.controle.patrimonial.domain.Item;
import org.springframework.roo.addon.web.mvc.controller.RooWebScaffold;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@RooWebScaffold(path = "items", formBackingObject = Item.class)
@RequestMapping("/items")
@Controller
public class ItemController {
}
