package br.unicamp.mc536.t2010s2a.forum.web;

import org.springframework.roo.addon.web.mvc.controller.RooWebScaffold;
import br.unicamp.mc536.t2010s2a.forum.domain.DescricaoDocumento;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.stereotype.Controller;

@RooWebScaffold(path = "descricaodocumentoes", formBackingObject = DescricaoDocumento.class)
@RequestMapping("/descricaodocumentoes")
@Controller
public class DescricaoDocumentoController {
}
