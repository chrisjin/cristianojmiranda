// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package br.unicamp.ic.controle.patrimonial.web;

import br.unicamp.ic.controle.patrimonial.domain.Notificacao;
import br.unicamp.ic.controle.patrimonial.domain.TipoNotificacao;
import br.unicamp.ic.controle.patrimonial.domain.Usuario;
import br.unicamp.ic.controle.patrimonial.reference.StatusNotificacaoEnum;
import java.io.UnsupportedEncodingException;
import java.lang.Integer;
import java.lang.Long;
import java.lang.String;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import org.joda.time.format.DateTimeFormat;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.util.UriUtils;
import org.springframework.web.util.WebUtils;

privileged aspect NotificacaoController_Roo_Controller {
    
    @RequestMapping(method = RequestMethod.POST)
    public String NotificacaoController.create(@Valid Notificacao notificacao, BindingResult bindingResult, Model uiModel, HttpServletRequest httpServletRequest) {
        if (bindingResult.hasErrors()) {
            uiModel.addAttribute("notificacao", notificacao);
            addDateTimeFormatPatterns(uiModel);
            return "notificacaos/create";
        }
        uiModel.asMap().clear();
        notificacao.persist();
        return "redirect:/notificacaos/" + encodeUrlPathSegment(notificacao.getId().toString(), httpServletRequest);
    }
    
    @RequestMapping(params = "form", method = RequestMethod.GET)
    public String NotificacaoController.createForm(Model uiModel) {
        uiModel.addAttribute("notificacao", new Notificacao());
        addDateTimeFormatPatterns(uiModel);
        List dependencies = new ArrayList();
        if (TipoNotificacao.countTipoNotificacaos() == 0) {
            dependencies.add(new String[]{"tiponotificacao", "tiponotificacaos"});
        }
        if (Usuario.countUsuarios() == 0) {
            dependencies.add(new String[]{"usuario", "usuarios"});
        }
        if (Usuario.countUsuarios() == 0) {
            dependencies.add(new String[]{"usuario", "usuarios"});
        }
        uiModel.addAttribute("dependencies", dependencies);
        return "notificacaos/create";
    }
    
    @RequestMapping(value = "/{id}", method = RequestMethod.GET)
    public String NotificacaoController.show(@PathVariable("id") Long id, Model uiModel) {
        addDateTimeFormatPatterns(uiModel);
        uiModel.addAttribute("notificacao", Notificacao.findNotificacao(id));
        uiModel.addAttribute("itemId", id);
        return "notificacaos/show";
    }
    
    @RequestMapping(method = RequestMethod.GET)
    public String NotificacaoController.list(@RequestParam(value = "page", required = false) Integer page, @RequestParam(value = "size", required = false) Integer size, Model uiModel) {
        if (page != null || size != null) {
            int sizeNo = size == null ? 10 : size.intValue();
            uiModel.addAttribute("notificacaos", Notificacao.findNotificacaoEntries(page == null ? 0 : (page.intValue() - 1) * sizeNo, sizeNo));
            float nrOfPages = (float) Notificacao.countNotificacaos() / sizeNo;
            uiModel.addAttribute("maxPages", (int) ((nrOfPages > (int) nrOfPages || nrOfPages == 0.0) ? nrOfPages + 1 : nrOfPages));
        } else {
            uiModel.addAttribute("notificacaos", Notificacao.findAllNotificacaos());
        }
        addDateTimeFormatPatterns(uiModel);
        return "notificacaos/list";
    }
    
    @RequestMapping(method = RequestMethod.PUT)
    public String NotificacaoController.update(@Valid Notificacao notificacao, BindingResult bindingResult, Model uiModel, HttpServletRequest httpServletRequest) {
        if (bindingResult.hasErrors()) {
            uiModel.addAttribute("notificacao", notificacao);
            addDateTimeFormatPatterns(uiModel);
            return "notificacaos/update";
        }
        uiModel.asMap().clear();
        notificacao.merge();
        return "redirect:/notificacaos/" + encodeUrlPathSegment(notificacao.getId().toString(), httpServletRequest);
    }
    
    @RequestMapping(value = "/{id}", params = "form", method = RequestMethod.GET)
    public String NotificacaoController.updateForm(@PathVariable("id") Long id, Model uiModel) {
        uiModel.addAttribute("notificacao", Notificacao.findNotificacao(id));
        addDateTimeFormatPatterns(uiModel);
        return "notificacaos/update";
    }
    
    @RequestMapping(value = "/{id}", method = RequestMethod.DELETE)
    public String NotificacaoController.delete(@PathVariable("id") Long id, @RequestParam(value = "page", required = false) Integer page, @RequestParam(value = "size", required = false) Integer size, Model uiModel) {
        Notificacao.findNotificacao(id).remove();
        uiModel.asMap().clear();
        uiModel.addAttribute("page", (page == null) ? "1" : page.toString());
        uiModel.addAttribute("size", (size == null) ? "10" : size.toString());
        return "redirect:/notificacaos";
    }
    
    @ModelAttribute("notificacaos")
    public Collection<Notificacao> NotificacaoController.populateNotificacaos() {
        return Notificacao.findAllNotificacaos();
    }
    
    @ModelAttribute("tiponotificacaos")
    public Collection<TipoNotificacao> NotificacaoController.populateTipoNotificacaos() {
        return TipoNotificacao.findAllTipoNotificacaos();
    }
    
    @ModelAttribute("usuarios")
    public Collection<Usuario> NotificacaoController.populateUsuarios() {
        return Usuario.findAllUsuarios();
    }
    
    @ModelAttribute("statusnotificacaoenums")
    public Collection<StatusNotificacaoEnum> NotificacaoController.populateStatusNotificacaoEnums() {
        return Arrays.asList(StatusNotificacaoEnum.class.getEnumConstants());
    }
    
    void NotificacaoController.addDateTimeFormatPatterns(Model uiModel) {
        uiModel.addAttribute("notificacao_dtcriacao_date_format", DateTimeFormat.patternForStyle("S-", LocaleContextHolder.getLocale()));
        uiModel.addAttribute("notificacao_dtatualizacao_date_format", DateTimeFormat.patternForStyle("S-", LocaleContextHolder.getLocale()));
    }
    
    String NotificacaoController.encodeUrlPathSegment(String pathSegment, HttpServletRequest httpServletRequest) {
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
