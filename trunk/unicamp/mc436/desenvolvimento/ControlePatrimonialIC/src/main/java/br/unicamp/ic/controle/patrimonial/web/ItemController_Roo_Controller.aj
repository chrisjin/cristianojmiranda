// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package br.unicamp.ic.controle.patrimonial.web;

import br.unicamp.ic.controle.patrimonial.domain.Area;
import br.unicamp.ic.controle.patrimonial.domain.Item;
import br.unicamp.ic.controle.patrimonial.domain.Usuario;
import br.unicamp.ic.controle.patrimonial.reference.StatusPatrimonioEnum;
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

privileged aspect ItemController_Roo_Controller {
    
    @RequestMapping(method = RequestMethod.POST)
    public String ItemController.create(@Valid Item item, BindingResult bindingResult, Model uiModel, HttpServletRequest httpServletRequest) {
        if (bindingResult.hasErrors()) {
            uiModel.addAttribute("item", item);
            addDateTimeFormatPatterns(uiModel);
            return "items/create";
        }
        uiModel.asMap().clear();
        item.persist();
        return "redirect:/items/" + encodeUrlPathSegment(item.getId().toString(), httpServletRequest);
    }
    
    @RequestMapping(params = "form", method = RequestMethod.GET)
    public String ItemController.createForm(Model uiModel) {
        uiModel.addAttribute("item", new Item());
        addDateTimeFormatPatterns(uiModel);
        List dependencies = new ArrayList();
        if (Usuario.countUsuarios() == 0) {
            dependencies.add(new String[]{"usuario", "usuarios"});
        }
        uiModel.addAttribute("dependencies", dependencies);
        return "items/create";
    }
    
    @RequestMapping(value = "/{id}", method = RequestMethod.GET)
    public String ItemController.show(@PathVariable("id") Long id, Model uiModel) {
        addDateTimeFormatPatterns(uiModel);
        uiModel.addAttribute("item", Item.findItem(id));
        uiModel.addAttribute("itemId", id);
        return "items/show";
    }
    
    @RequestMapping(method = RequestMethod.GET)
    public String ItemController.list(@RequestParam(value = "page", required = false) Integer page, @RequestParam(value = "size", required = false) Integer size, Model uiModel) {
        if (page != null || size != null) {
            int sizeNo = size == null ? 10 : size.intValue();
            uiModel.addAttribute("items", Item.findItemEntries(page == null ? 0 : (page.intValue() - 1) * sizeNo, sizeNo));
            float nrOfPages = (float) Item.countItems() / sizeNo;
            uiModel.addAttribute("maxPages", (int) ((nrOfPages > (int) nrOfPages || nrOfPages == 0.0) ? nrOfPages + 1 : nrOfPages));
        } else {
            uiModel.addAttribute("items", Item.findAllItems());
        }
        addDateTimeFormatPatterns(uiModel);
        return "items/list";
    }
    
    @RequestMapping(method = RequestMethod.PUT)
    public String ItemController.update(@Valid Item item, BindingResult bindingResult, Model uiModel, HttpServletRequest httpServletRequest) {
        if (bindingResult.hasErrors()) {
            uiModel.addAttribute("item", item);
            addDateTimeFormatPatterns(uiModel);
            return "items/update";
        }
        uiModel.asMap().clear();
        item.merge();
        return "redirect:/items/" + encodeUrlPathSegment(item.getId().toString(), httpServletRequest);
    }
    
    @RequestMapping(value = "/{id}", params = "form", method = RequestMethod.GET)
    public String ItemController.updateForm(@PathVariable("id") Long id, Model uiModel) {
        uiModel.addAttribute("item", Item.findItem(id));
        addDateTimeFormatPatterns(uiModel);
        return "items/update";
    }
    
    @RequestMapping(value = "/{id}", method = RequestMethod.DELETE)
    public String ItemController.delete(@PathVariable("id") Long id, @RequestParam(value = "page", required = false) Integer page, @RequestParam(value = "size", required = false) Integer size, Model uiModel) {
        Item.findItem(id).remove();
        uiModel.asMap().clear();
        uiModel.addAttribute("page", (page == null) ? "1" : page.toString());
        uiModel.addAttribute("size", (size == null) ? "10" : size.toString());
        return "redirect:/items";
    }
    
    @ModelAttribute("areas")
    public Collection<Area> ItemController.populateAreas() {
        return Area.findAllAreas();
    }
    
    @ModelAttribute("items")
    public Collection<Item> ItemController.populateItems() {
        return Item.findAllItems();
    }
    
    @ModelAttribute("usuarios")
    public Collection<Usuario> ItemController.populateUsuarios() {
        return Usuario.findAllUsuarios();
    }
    
    @ModelAttribute("statuspatrimonioenums")
    public Collection<StatusPatrimonioEnum> ItemController.populateStatusPatrimonioEnums() {
        return Arrays.asList(StatusPatrimonioEnum.class.getEnumConstants());
    }
    
    void ItemController.addDateTimeFormatPatterns(Model uiModel) {
        uiModel.addAttribute("item_dtliberacao_date_format", DateTimeFormat.patternForStyle("S-", LocaleContextHolder.getLocale()));
        uiModel.addAttribute("item_dtcriacao_date_format", DateTimeFormat.patternForStyle("S-", LocaleContextHolder.getLocale()));
        uiModel.addAttribute("item_dtatualizacao_date_format", DateTimeFormat.patternForStyle("S-", LocaleContextHolder.getLocale()));
    }
    
    String ItemController.encodeUrlPathSegment(String pathSegment, HttpServletRequest httpServletRequest) {
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