// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package br.unicamp.ic.controle.patrimonial.web;

import br.unicamp.ic.controle.patrimonial.domain.Area;
import br.unicamp.ic.controle.patrimonial.domain.Perfil;
import br.unicamp.ic.controle.patrimonial.domain.Usuario;
import br.unicamp.ic.controle.patrimonial.reference.EnabledEnum;
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

privileged aspect UsuarioController_Roo_Controller {
    
    @RequestMapping(method = RequestMethod.POST)
    public String UsuarioController.create(@Valid Usuario usuario, BindingResult bindingResult, Model uiModel, HttpServletRequest httpServletRequest) {
        if (bindingResult.hasErrors()) {
            uiModel.addAttribute("usuario", usuario);
            addDateTimeFormatPatterns(uiModel);
            return "usuarios/create";
        }
        uiModel.asMap().clear();
        usuario.persist();
        return "redirect:/usuarios/" + encodeUrlPathSegment(usuario.getId().toString(), httpServletRequest);
    }
    
    @RequestMapping(params = "form", method = RequestMethod.GET)
    public String UsuarioController.createForm(Model uiModel) {
        uiModel.addAttribute("usuario", new Usuario());
        addDateTimeFormatPatterns(uiModel);
        List dependencies = new ArrayList();
        if (Perfil.countPerfils() == 0) {
            dependencies.add(new String[]{"perfil", "perfils"});
        }
        if (Area.countAreas() == 0) {
            dependencies.add(new String[]{"area", "areas"});
        }
        uiModel.addAttribute("dependencies", dependencies);
        return "usuarios/create";
    }
    
    @RequestMapping(value = "/{id}", method = RequestMethod.GET)
    public String UsuarioController.show(@PathVariable("id") Long id, Model uiModel) {
        addDateTimeFormatPatterns(uiModel);
        uiModel.addAttribute("usuario", Usuario.findUsuario(id));
        uiModel.addAttribute("itemId", id);
        return "usuarios/show";
    }
    
    @RequestMapping(method = RequestMethod.GET)
    public String UsuarioController.list(@RequestParam(value = "page", required = false) Integer page, @RequestParam(value = "size", required = false) Integer size, Model uiModel) {
        if (page != null || size != null) {
            int sizeNo = size == null ? 10 : size.intValue();
            uiModel.addAttribute("usuarios", Usuario.findUsuarioEntries(page == null ? 0 : (page.intValue() - 1) * sizeNo, sizeNo));
            float nrOfPages = (float) Usuario.countUsuarios() / sizeNo;
            uiModel.addAttribute("maxPages", (int) ((nrOfPages > (int) nrOfPages || nrOfPages == 0.0) ? nrOfPages + 1 : nrOfPages));
        } else {
            uiModel.addAttribute("usuarios", Usuario.findAllUsuarios());
        }
        addDateTimeFormatPatterns(uiModel);
        return "usuarios/list";
    }
    
    @RequestMapping(method = RequestMethod.PUT)
    public String UsuarioController.update(@Valid Usuario usuario, BindingResult bindingResult, Model uiModel, HttpServletRequest httpServletRequest) {
        if (bindingResult.hasErrors()) {
            uiModel.addAttribute("usuario", usuario);
            addDateTimeFormatPatterns(uiModel);
            return "usuarios/update";
        }
        uiModel.asMap().clear();
        usuario.merge();
        return "redirect:/usuarios/" + encodeUrlPathSegment(usuario.getId().toString(), httpServletRequest);
    }
    
    @RequestMapping(value = "/{id}", params = "form", method = RequestMethod.GET)
    public String UsuarioController.updateForm(@PathVariable("id") Long id, Model uiModel) {
        uiModel.addAttribute("usuario", Usuario.findUsuario(id));
        addDateTimeFormatPatterns(uiModel);
        return "usuarios/update";
    }
    
    @RequestMapping(value = "/{id}", method = RequestMethod.DELETE)
    public String UsuarioController.delete(@PathVariable("id") Long id, @RequestParam(value = "page", required = false) Integer page, @RequestParam(value = "size", required = false) Integer size, Model uiModel) {
        Usuario.findUsuario(id).remove();
        uiModel.asMap().clear();
        uiModel.addAttribute("page", (page == null) ? "1" : page.toString());
        uiModel.addAttribute("size", (size == null) ? "10" : size.toString());
        return "redirect:/usuarios";
    }
    
    @ModelAttribute("areas")
    public Collection<Area> UsuarioController.populateAreas() {
        return Area.findAllAreas();
    }
    
    @ModelAttribute("perfils")
    public Collection<Perfil> UsuarioController.populatePerfils() {
        return Perfil.findAllPerfils();
    }
    
    @ModelAttribute("usuarios")
    public Collection<Usuario> UsuarioController.populateUsuarios() {
        return Usuario.findAllUsuarios();
    }
    
    @ModelAttribute("enabledenums")
    public Collection<EnabledEnum> UsuarioController.populateEnabledEnums() {
        return Arrays.asList(EnabledEnum.class.getEnumConstants());
    }
    
    void UsuarioController.addDateTimeFormatPatterns(Model uiModel) {
        uiModel.addAttribute("usuario_dtcriacao_date_format", DateTimeFormat.patternForStyle("S-", LocaleContextHolder.getLocale()));
        uiModel.addAttribute("usuario_dtatualizacao_date_format", DateTimeFormat.patternForStyle("S-", LocaleContextHolder.getLocale()));
    }
    
    String UsuarioController.encodeUrlPathSegment(String pathSegment, HttpServletRequest httpServletRequest) {
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