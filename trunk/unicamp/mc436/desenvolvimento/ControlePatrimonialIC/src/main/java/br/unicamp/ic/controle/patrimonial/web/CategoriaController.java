package br.unicamp.ic.controle.patrimonial.web;

import br.unicamp.ic.controle.patrimonial.domain.Categoria;
import org.springframework.roo.addon.web.mvc.controller.RooWebScaffold;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@RooWebScaffold(path = "categorias", formBackingObject = Categoria.class)
@RequestMapping("/categorias")
@Controller
public class CategoriaController {
}
