// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package br.unicamp.mc536.t2010s2a.forum.web;

import br.unicamp.mc536.t2010s2a.forum.domain.Documento;
import br.unicamp.mc536.t2010s2a.forum.domain.Idioma;
import br.unicamp.mc536.t2010s2a.forum.domain.Pais;
import br.unicamp.mc536.t2010s2a.forum.domain.Programa;
import br.unicamp.mc536.t2010s2a.forum.domain.RedeTrabalho;
import br.unicamp.mc536.t2010s2a.forum.domain.TipoDocumento;
import br.unicamp.mc536.t2010s2a.forum.domain.Usuario;
import java.lang.Long;
import java.lang.String;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import javax.validation.Valid;
import org.joda.time.format.DateTimeFormat;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.core.convert.converter.Converter;
import org.springframework.core.convert.support.GenericConversionService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

privileged aspect DocumentoController_Roo_Controller {
    
    @RequestMapping(method = RequestMethod.POST)
    public String DocumentoController.create(@Valid Documento documento, BindingResult result, Model model) {
        if (result.hasErrors()) {
            model.addAttribute("documento", documento);
            addDateTimeFormatPatterns(model);
            return "documentoes/create";
        }
        documento.persist();
        return "redirect:/documentoes/" + documento.getId();
    }
    
    @RequestMapping(params = "form", method = RequestMethod.GET)
    public String DocumentoController.createForm(Model model) {
        model.addAttribute("documento", new Documento());
        addDateTimeFormatPatterns(model);
        List dependencies = new ArrayList();
        if (Idioma.countIdiomas() == 0) {
            dependencies.add(new String[]{"idIdiomaDocumento", "idiomas"});
        }
        if (Pais.countPaises() == 0) {
            dependencies.add(new String[]{"idPais", "paises"});
        }
        if (TipoDocumento.countTipoDocumentoes() == 0) {
            dependencies.add(new String[]{"tipoDocumento", "tipodocumentoes"});
        }
        model.addAttribute("dependencies", dependencies);
        return "documentoes/create";
    }
    
    @RequestMapping(value = "/{id}", method = RequestMethod.GET)
    public String DocumentoController.show(@PathVariable("id") Long id, Model model) {
        addDateTimeFormatPatterns(model);
        model.addAttribute("documento", Documento.findDocumento(id));
        model.addAttribute("itemId", id);
        return "documentoes/show";
    }
    
    @RequestMapping(method = RequestMethod.GET)
    public String DocumentoController.list(@RequestParam(value = "page", required = false) Integer page, @RequestParam(value = "size", required = false) Integer size, Model model) {
        if (page != null || size != null) {
            int sizeNo = size == null ? 10 : size.intValue();
            model.addAttribute("documentoes", Documento.findDocumentoEntries(page == null ? 0 : (page.intValue() - 1) * sizeNo, sizeNo));
            float nrOfPages = (float) Documento.countDocumentoes() / sizeNo;
            model.addAttribute("maxPages", (int) ((nrOfPages > (int) nrOfPages || nrOfPages == 0.0) ? nrOfPages + 1 : nrOfPages));
        } else {
            model.addAttribute("documentoes", Documento.findAllDocumentoes());
        }
        addDateTimeFormatPatterns(model);
        return "documentoes/list";
    }
    
    @RequestMapping(method = RequestMethod.PUT)
    public String DocumentoController.update(@Valid Documento documento, BindingResult result, Model model) {
        if (result.hasErrors()) {
            model.addAttribute("documento", documento);
            addDateTimeFormatPatterns(model);
            return "documentoes/update";
        }
        documento.merge();
        return "redirect:/documentoes/" + documento.getId();
    }
    
    @RequestMapping(value = "/{id}", params = "form", method = RequestMethod.GET)
    public String DocumentoController.updateForm(@PathVariable("id") Long id, Model model) {
        model.addAttribute("documento", Documento.findDocumento(id));
        addDateTimeFormatPatterns(model);
        return "documentoes/update";
    }
    
    @RequestMapping(value = "/{id}", method = RequestMethod.DELETE)
    public String DocumentoController.delete(@PathVariable("id") Long id, @RequestParam(value = "page", required = false) Integer page, @RequestParam(value = "size", required = false) Integer size, Model model) {
        Documento.findDocumento(id).remove();
        model.addAttribute("page", (page == null) ? "1" : page.toString());
        model.addAttribute("size", (size == null) ? "10" : size.toString());
        return "redirect:/documentoes?page=" + ((page == null) ? "1" : page.toString()) + "&size=" + ((size == null) ? "10" : size.toString());
    }
    
    @ModelAttribute("idiomas")
    public Collection<Idioma> DocumentoController.populateIdiomas() {
        return Idioma.findAllIdiomas();
    }
    
    @ModelAttribute("paises")
    public Collection<Pais> DocumentoController.populatePaises() {
        return Pais.findAllPaises();
    }
    
    @ModelAttribute("programas")
    public Collection<Programa> DocumentoController.populateProgramas() {
        return Programa.findAllProgramas();
    }
    
    @ModelAttribute("redetrabalhoes")
    public Collection<RedeTrabalho> DocumentoController.populateRedeTrabalhoes() {
        return RedeTrabalho.findAllRedeTrabalhoes();
    }
    
    @ModelAttribute("tipodocumentoes")
    public Collection<TipoDocumento> DocumentoController.populateTipoDocumentoes() {
        return TipoDocumento.findAllTipoDocumentoes();
    }
    
    @ModelAttribute("usuarios")
    public Collection<Usuario> DocumentoController.populateUsuarios() {
        return Usuario.findAllUsuarios();
    }
    
    Converter<Documento, String> DocumentoController.getDocumentoConverter() {
        return new Converter<Documento, String>() {
            public String convert(Documento documento) {
                return new StringBuilder().append(documento.getNmDocumento()).append(" ").append(documento.getDsDocumento()).append(" ").append(documento.getNmArquivo()).toString();
            }
        };
    }
    
    Converter<Idioma, String> DocumentoController.getIdiomaConverter() {
        return new Converter<Idioma, String>() {
            public String convert(Idioma idioma) {
                return new StringBuilder().append(idioma.getNmIdioma()).append(" ").append(idioma.getSgIdioma()).append(" ").append(idioma.getDsIdioma()).toString();
            }
        };
    }
    
    Converter<Pais, String> DocumentoController.getPaisConverter() {
        return new Converter<Pais, String>() {
            public String convert(Pais pais) {
                return new StringBuilder().append(pais.getNmPais()).append(" ").append(pais.getDsPais()).toString();
            }
        };
    }
    
    Converter<Programa, String> DocumentoController.getProgramaConverter() {
        return new Converter<Programa, String>() {
            public String convert(Programa programa) {
                return new StringBuilder().append(programa.getNmPrograma()).append(" ").append(programa.getDsPrograma()).append(" ").append(programa.getDsDetalhadaPrograma()).toString();
            }
        };
    }
    
    Converter<RedeTrabalho, String> DocumentoController.getRedeTrabalhoConverter() {
        return new Converter<RedeTrabalho, String>() {
            public String convert(RedeTrabalho redeTrabalho) {
                return new StringBuilder().append(redeTrabalho.getNmRedetrabalho()).append(" ").append(redeTrabalho.getDsRedetrabalho()).append(" ").append(redeTrabalho.getDsDetalhadoRedetrabalho()).toString();
            }
        };
    }
    
    Converter<TipoDocumento, String> DocumentoController.getTipoDocumentoConverter() {
        return new Converter<TipoDocumento, String>() {
            public String convert(TipoDocumento tipoDocumento) {
                return new StringBuilder().append(tipoDocumento.getNmTipoDocumento()).append(" ").append(tipoDocumento.getDsTipoDocumento()).append(" ").append(tipoDocumento.getDsDetalhadoTipoDocumento()).toString();
            }
        };
    }
    
    Converter<Usuario, String> DocumentoController.getUsuarioConverter() {
        return new Converter<Usuario, String>() {
            public String convert(Usuario usuario) {
                return new StringBuilder().append(usuario.getNmUsuario()).append(" ").append(usuario.getDsLogin()).append(" ").append(usuario.getDsSenha()).toString();
            }
        };
    }
    
    @InitBinder
    void DocumentoController.registerConverters(WebDataBinder binder) {
        if (binder.getConversionService() instanceof GenericConversionService) {
            GenericConversionService conversionService = (GenericConversionService) binder.getConversionService();
            conversionService.addConverter(getDocumentoConverter());
            conversionService.addConverter(getIdiomaConverter());
            conversionService.addConverter(getPaisConverter());
            conversionService.addConverter(getProgramaConverter());
            conversionService.addConverter(getRedeTrabalhoConverter());
            conversionService.addConverter(getTipoDocumentoConverter());
            conversionService.addConverter(getUsuarioConverter());
        }
    }
    
    void DocumentoController.addDateTimeFormatPatterns(Model model) {
        model.addAttribute("documento_dtinclusao_date_format", DateTimeFormat.patternForStyle("S-", LocaleContextHolder.getLocale()));
        model.addAttribute("documento_dtcriacao_date_format", DateTimeFormat.patternForStyle("S-", LocaleContextHolder.getLocale()));
    }
    
    @RequestMapping(value = "/{id}", method = RequestMethod.GET, headers = "Accept=application/json")
    @ResponseBody
    public String DocumentoController.showJson(@PathVariable("id") Long id) {
        return Documento.findDocumento(id).toJson();
    }
    
    @RequestMapping(method = RequestMethod.POST, headers = "Accept=application/json")
    public ResponseEntity<String> DocumentoController.createFromJson(@RequestBody String json) {
        Documento.fromJsonToDocumento(json).persist();
        return new ResponseEntity<String>("Documento created", HttpStatus.CREATED);
    }
    
    @RequestMapping(headers = "Accept=application/json")
    @ResponseBody
    public String DocumentoController.listJson() {
        return Documento.toJsonArray(Documento.findAllDocumentoes());
    }
    
    @RequestMapping(value = "/jsonArray", method = RequestMethod.POST, headers = "Accept=application/json")
    public ResponseEntity<String> DocumentoController.createFromJsonArray(@RequestBody String json) {
        for (Documento documento: Documento.fromJsonArrayToDocumentoes(json)) {
            documento.persist();
        }
        return new ResponseEntity<String>("Documento created", HttpStatus.CREATED);
    }
    
}