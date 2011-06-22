// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package br.unicamp.ic.controle.patrimonial.web;

import br.unicamp.ic.controle.patrimonial.domain.Funcionalidade;
import br.unicamp.ic.controle.patrimonial.domain.Perfil;
import br.unicamp.ic.controle.patrimonial.domain.PerfilFuncionalidade;
import java.io.UnsupportedEncodingException;
import java.lang.Integer;
import java.lang.Long;
import java.lang.String;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
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

privileged aspect PerfilFuncionalidadeController_Roo_Controller {
    
    @RequestMapping(method = RequestMethod.POST)
    public String PerfilFuncionalidadeController.create(@Valid PerfilFuncionalidade perfilFuncionalidade, BindingResult bindingResult, Model uiModel, HttpServletRequest httpServletRequest) {
        if (bindingResult.hasErrors()) {
            uiModel.addAttribute("perfilFuncionalidade", perfilFuncionalidade);
            return "perfilfuncionalidades/create";
        }
        uiModel.asMap().clear();
        perfilFuncionalidade.persist();
        return "redirect:/perfilfuncionalidades/" + encodeUrlPathSegment(perfilFuncionalidade.getId().toString(), httpServletRequest);
    }
    
    @RequestMapping(params = "form", method = RequestMethod.GET)
    public String PerfilFuncionalidadeController.createForm(Model uiModel) {
        uiModel.addAttribute("perfilFuncionalidade", new PerfilFuncionalidade());
        List dependencies = new ArrayList();
        if (Perfil.countPerfils() == 0) {
            dependencies.add(new String[]{"perfil", "perfils"});
        }
        if (Funcionalidade.countFuncionalidades() == 0) {
            dependencies.add(new String[]{"funcionalidade", "funcionalidades"});
        }
        uiModel.addAttribute("dependencies", dependencies);
        return "perfilfuncionalidades/create";
    }
    
    @RequestMapping(value = "/{id}", method = RequestMethod.GET)
    public String PerfilFuncionalidadeController.show(@PathVariable("id") Long id, Model uiModel) {
        uiModel.addAttribute("perfilfuncionalidade", PerfilFuncionalidade.findPerfilFuncionalidade(id));
        uiModel.addAttribute("itemId", id);
        return "perfilfuncionalidades/show";
    }
    
    @RequestMapping(method = RequestMethod.GET)
    public String PerfilFuncionalidadeController.list(@RequestParam(value = "page", required = false) Integer page, @RequestParam(value = "size", required = false) Integer size, Model uiModel) {
        if (page != null || size != null) {
            int sizeNo = size == null ? 10 : size.intValue();
            uiModel.addAttribute("perfilfuncionalidades", PerfilFuncionalidade.findPerfilFuncionalidadeEntries(page == null ? 0 : (page.intValue() - 1) * sizeNo, sizeNo));
            float nrOfPages = (float) PerfilFuncionalidade.countPerfilFuncionalidades() / sizeNo;
            uiModel.addAttribute("maxPages", (int) ((nrOfPages > (int) nrOfPages || nrOfPages == 0.0) ? nrOfPages + 1 : nrOfPages));
        } else {
            uiModel.addAttribute("perfilfuncionalidades", PerfilFuncionalidade.findAllPerfilFuncionalidades());
        }
        return "perfilfuncionalidades/list";
    }
    
    @RequestMapping(method = RequestMethod.PUT)
    public String PerfilFuncionalidadeController.update(@Valid PerfilFuncionalidade perfilFuncionalidade, BindingResult bindingResult, Model uiModel, HttpServletRequest httpServletRequest) {
        if (bindingResult.hasErrors()) {
            uiModel.addAttribute("perfilFuncionalidade", perfilFuncionalidade);
            return "perfilfuncionalidades/update";
        }
        uiModel.asMap().clear();
        perfilFuncionalidade.merge();
        return "redirect:/perfilfuncionalidades/" + encodeUrlPathSegment(perfilFuncionalidade.getId().toString(), httpServletRequest);
    }
    
    @RequestMapping(value = "/{id}", params = "form", method = RequestMethod.GET)
    public String PerfilFuncionalidadeController.updateForm(@PathVariable("id") Long id, Model uiModel) {
        uiModel.addAttribute("perfilFuncionalidade", PerfilFuncionalidade.findPerfilFuncionalidade(id));
        return "perfilfuncionalidades/update";
    }
    
    @RequestMapping(value = "/{id}", method = RequestMethod.DELETE)
    public String PerfilFuncionalidadeController.delete(@PathVariable("id") Long id, @RequestParam(value = "page", required = false) Integer page, @RequestParam(value = "size", required = false) Integer size, Model uiModel) {
        PerfilFuncionalidade.findPerfilFuncionalidade(id).remove();
        uiModel.asMap().clear();
        uiModel.addAttribute("page", (page == null) ? "1" : page.toString());
        uiModel.addAttribute("size", (size == null) ? "10" : size.toString());
        return "redirect:/perfilfuncionalidades";
    }
    
    @ModelAttribute("funcionalidades")
    public Collection<Funcionalidade> PerfilFuncionalidadeController.populateFuncionalidades() {
        return Funcionalidade.findAllFuncionalidades();
    }
    
    @ModelAttribute("perfils")
    public Collection<Perfil> PerfilFuncionalidadeController.populatePerfils() {
        return Perfil.findAllPerfils();
    }
    
    @ModelAttribute("perfilfuncionalidades")
    public Collection<PerfilFuncionalidade> PerfilFuncionalidadeController.populatePerfilFuncionalidades() {
        return PerfilFuncionalidade.findAllPerfilFuncionalidades();
    }
    
    String PerfilFuncionalidadeController.encodeUrlPathSegment(String pathSegment, HttpServletRequest httpServletRequest) {
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
