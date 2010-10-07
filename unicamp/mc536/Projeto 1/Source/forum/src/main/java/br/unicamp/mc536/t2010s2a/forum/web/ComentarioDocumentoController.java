package br.unicamp.mc536.t2010s2a.forum.web;

import org.springframework.roo.addon.web.mvc.controller.RooWebScaffold;
import br.unicamp.mc536.t2010s2a.forum.domain.ComentarioDocumento;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.stereotype.Controller;

@RooWebScaffold(path = "comentariodocumentoes", formBackingObject = ComentarioDocumento.class)
@RequestMapping("/comentariodocumentoes")
@Controller
public class ComentarioDocumentoController {
}
