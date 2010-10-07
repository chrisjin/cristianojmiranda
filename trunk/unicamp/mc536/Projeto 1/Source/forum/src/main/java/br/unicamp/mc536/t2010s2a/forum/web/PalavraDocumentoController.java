package br.unicamp.mc536.t2010s2a.forum.web;

import org.springframework.roo.addon.web.mvc.controller.RooWebScaffold;
import br.unicamp.mc536.t2010s2a.forum.domain.PalavraDocumento;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.stereotype.Controller;

@RooWebScaffold(path = "palavradocumentoes", formBackingObject = PalavraDocumento.class)
@RequestMapping("/palavradocumentoes")
@Controller
public class PalavraDocumentoController {
}
