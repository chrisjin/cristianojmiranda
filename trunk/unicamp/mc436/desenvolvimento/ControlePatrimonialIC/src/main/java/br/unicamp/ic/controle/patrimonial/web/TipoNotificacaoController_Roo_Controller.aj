// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package br.unicamp.ic.controle.patrimonial.web;

import br.unicamp.ic.controle.patrimonial.domain.TipoNotificacao;
import br.unicamp.ic.controle.patrimonial.reference.EnabledEnum;
import java.io.UnsupportedEncodingException;
import java.lang.Integer;
import java.lang.Long;
import java.lang.String;
import java.util.Arrays;
import java.util.Collection;
import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.util.UriUtils;
import org.springframework.web.util.WebUtils;

privileged aspect TipoNotificacaoController_Roo_Controller {
    
    @RequestMapping(method = RequestMethod.POST)
    public String TipoNotificacaoController.create(@Valid TipoNotificacao tipoNotificacao, BindingResult bindingResult, Model uiModel, HttpServletRequest httpServletRequest) {
        if (bindingResult.hasErrors()) {
            uiModel.addAttribute("tipoNotificacao", tipoNotificacao);
            return "tiponotificacaos/create";
        }
        uiModel.asMap().clear();
        tipoNotificacao.persist();
        return "redirect:/tiponotificacaos/" + encodeUrlPathSegment(tipoNotificacao.getId().toString(), httpServletRequest);
    }
    
    @RequestMapping(params = "form", method = RequestMethod.GET)
    public String TipoNotificacaoController.createForm(Model uiModel) {
        uiModel.addAttribute("tipoNotificacao", new TipoNotificacao());
        return "tiponotificacaos/create";
    }
    
    @RequestMapping(value = "/{id}", method = RequestMethod.GET)
    public String TipoNotificacaoController.show(@PathVariable("id") Long id, Model uiModel) {
        uiModel.addAttribute("tiponotificacao", TipoNotificacao.findTipoNotificacao(id));
        uiModel.addAttribute("itemId", id);
        return "tiponotificacaos/show";
    }
    
    @RequestMapping(method = RequestMethod.GET)
    public String TipoNotificacaoController.list(@RequestParam(value = "page", required = false) Integer page, @RequestParam(value = "size", required = false) Integer size, Model uiModel) {
        if (page != null || size != null) {
            int sizeNo = size == null ? 10 : size.intValue();
            uiModel.addAttribute("tiponotificacaos", TipoNotificacao.findTipoNotificacaoEntries(page == null ? 0 : (page.intValue() - 1) * sizeNo, sizeNo));
            float nrOfPages = (float) TipoNotificacao.countTipoNotificacaos() / sizeNo;
            uiModel.addAttribute("maxPages", (int) ((nrOfPages > (int) nrOfPages || nrOfPages == 0.0) ? nrOfPages + 1 : nrOfPages));
        } else {
            uiModel.addAttribute("tiponotificacaos", TipoNotificacao.findAllTipoNotificacaos());
        }
        return "tiponotificacaos/list";
    }
    
    @RequestMapping(method = RequestMethod.PUT)
    public String TipoNotificacaoController.update(@Valid TipoNotificacao tipoNotificacao, BindingResult bindingResult, Model uiModel, HttpServletRequest httpServletRequest) {
        if (bindingResult.hasErrors()) {
            uiModel.addAttribute("tipoNotificacao", tipoNotificacao);
            return "tiponotificacaos/update";
        }
        uiModel.asMap().clear();
        tipoNotificacao.merge();
        return "redirect:/tiponotificacaos/" + encodeUrlPathSegment(tipoNotificacao.getId().toString(), httpServletRequest);
    }
    
    @RequestMapping(value = "/{id}", params = "form", method = RequestMethod.GET)
    public String TipoNotificacaoController.updateForm(@PathVariable("id") Long id, Model uiModel) {
        uiModel.addAttribute("tipoNotificacao", TipoNotificacao.findTipoNotificacao(id));
        return "tiponotificacaos/update";
    }
    
    @RequestMapping(value = "/{id}", method = RequestMethod.DELETE)
    public String TipoNotificacaoController.delete(@PathVariable("id") Long id, @RequestParam(value = "page", required = false) Integer page, @RequestParam(value = "size", required = false) Integer size, Model uiModel) {
        TipoNotificacao.findTipoNotificacao(id).remove();
        uiModel.asMap().clear();
        uiModel.addAttribute("page", (page == null) ? "1" : page.toString());
        uiModel.addAttribute("size", (size == null) ? "10" : size.toString());
        return "redirect:/tiponotificacaos";
    }
    
    @ModelAttribute("tiponotificacaos")
    public Collection<TipoNotificacao> TipoNotificacaoController.populateTipoNotificacaos() {
        return TipoNotificacao.findAllTipoNotificacaos();
    }
    
    @ModelAttribute("enabledenums")
    public Collection<EnabledEnum> TipoNotificacaoController.populateEnabledEnums() {
        return Arrays.asList(EnabledEnum.class.getEnumConstants());
    }
    
    String TipoNotificacaoController.encodeUrlPathSegment(String pathSegment, HttpServletRequest httpServletRequest) {
        String enc = httpServletRequest.getCharacterEncoding();
        if (enc == null) {
            enc = WebUtils.DEFAULT_CHARACTER_ENCODING;
        }
        try {
            pathSegment = UriUtils.encodePathSegment(pathSegment, enc);
        }
        catch (UnsupportedEncodingException uee) {}
        return pathSegment;
    }
    
}