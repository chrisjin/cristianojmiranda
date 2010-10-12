package br.unicamp.mc536.t2010s2a.forum.web;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.ReloadableResourceBundleMessageSource;
import org.springframework.roo.addon.web.mvc.controller.RooWebScaffold;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import br.unicamp.mc536.t2010s2a.forum.domain.TipoDocumento;

@RooWebScaffold(path = "tipodocumentoes", formBackingObject = TipoDocumento.class)
@RequestMapping("/tipodocumentoes")
@Controller
public class TipoDocumentoController {

	@Autowired
	private ReloadableResourceBundleMessageSource bundle;

	public ReloadableResourceBundleMessageSource getBundle() {
		return bundle;
	}

	public void setBundle(ReloadableResourceBundleMessageSource bundle) {
		this.bundle = bundle;
	}

}
