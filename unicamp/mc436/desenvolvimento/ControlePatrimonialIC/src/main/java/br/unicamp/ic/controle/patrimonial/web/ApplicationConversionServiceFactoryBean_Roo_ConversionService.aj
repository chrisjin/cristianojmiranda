// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package br.unicamp.ic.controle.patrimonial.web;

import br.unicamp.ic.controle.patrimonial.domain.Area;
import br.unicamp.ic.controle.patrimonial.domain.Categoria;
import br.unicamp.ic.controle.patrimonial.domain.Departamento;
import br.unicamp.ic.controle.patrimonial.domain.Funcionalidade;
import br.unicamp.ic.controle.patrimonial.domain.Item;
import br.unicamp.ic.controle.patrimonial.domain.LocalizacaoItem;
import br.unicamp.ic.controle.patrimonial.domain.Notificacao;
import br.unicamp.ic.controle.patrimonial.domain.Perfil;
import br.unicamp.ic.controle.patrimonial.domain.TipoNotificacao;
import br.unicamp.ic.controle.patrimonial.domain.Usuario;
import java.lang.String;
import org.springframework.core.convert.converter.Converter;
import org.springframework.format.FormatterRegistry;

privileged aspect ApplicationConversionServiceFactoryBean_Roo_ConversionService {
    
    public void ApplicationConversionServiceFactoryBean.installLabelConverters(FormatterRegistry registry) {
        registry.addConverter(new AreaConverter());
        registry.addConverter(new CategoriaConverter());
        registry.addConverter(new DepartamentoConverter());
        registry.addConverter(new FuncionalidadeConverter());
        registry.addConverter(new ItemConverter());
        registry.addConverter(new LocalizacaoItemConverter());
        registry.addConverter(new NotificacaoConverter());
        registry.addConverter(new PerfilConverter());
        registry.addConverter(new TipoNotificacaoConverter());
        registry.addConverter(new UsuarioConverter());
    }
    
    public void ApplicationConversionServiceFactoryBean.afterPropertiesSet() {
        super.afterPropertiesSet();
        installLabelConverters(getObject());
    }
    
    static class br.unicamp.ic.controle.patrimonial.web.ApplicationConversionServiceFactoryBean.AreaConverter implements Converter<Area, String>  {
        public String convert(Area area) {
            return new StringBuilder().append(area.getNome()).append(" ").append(area.getDescricao()).append(" ").append(area.getEndereco()).append(" ").append(area.getResponsavel()).toString();
        }
        
    }
    
    static class br.unicamp.ic.controle.patrimonial.web.ApplicationConversionServiceFactoryBean.CategoriaConverter implements Converter<Categoria, String>  {
        public String convert(Categoria categoria) {
            return new StringBuilder().append(categoria.getNome()).append(" ").append(categoria.getDescricao()).toString();
        }
        
    }
    
    static class br.unicamp.ic.controle.patrimonial.web.ApplicationConversionServiceFactoryBean.DepartamentoConverter implements Converter<Departamento, String>  {
        public String convert(Departamento departamento) {
            return new StringBuilder().append(departamento.getNome()).append(" ").append(departamento.getDescricao()).append(" ").append(departamento.getDtCriacao()).append(" ").append(departamento.getResponsavel()).toString();
        }
        
    }
    
    static class br.unicamp.ic.controle.patrimonial.web.ApplicationConversionServiceFactoryBean.FuncionalidadeConverter implements Converter<Funcionalidade, String>  {
        public String convert(Funcionalidade funcionalidade) {
            return new StringBuilder().append(funcionalidade.getDescricao()).toString();
        }
        
    }
    
    static class br.unicamp.ic.controle.patrimonial.web.ApplicationConversionServiceFactoryBean.ItemConverter implements Converter<Item, String>  {
        public String convert(Item item) {
            return new StringBuilder().append(item.getPid()).append(" ").append(item.getRfid()).append(" ").append(item.getNome()).append(" ").append(item.getCategoria()).toString();
        }
        
    }
    
    static class br.unicamp.ic.controle.patrimonial.web.ApplicationConversionServiceFactoryBean.LocalizacaoItemConverter implements Converter<LocalizacaoItem, String>  {
        public String convert(LocalizacaoItem localizacaoItem) {
            return new StringBuilder().append(localizacaoItem.getDescricao()).append(" ").append(localizacaoItem.getDtAtualizacao()).append(" ").append(localizacaoItem.getObservacoes()).toString();
        }
        
    }
    
    static class br.unicamp.ic.controle.patrimonial.web.ApplicationConversionServiceFactoryBean.NotificacaoConverter implements Converter<Notificacao, String>  {
        public String convert(Notificacao notificacao) {
            return new StringBuilder().append(notificacao.getDtCriacao()).append(" ").append(notificacao.getDtAtualizacao()).append(" ").append(notificacao.getDescricao()).append(" ").append(notificacao.getObservacao()).toString();
        }
        
    }
    
    static class br.unicamp.ic.controle.patrimonial.web.ApplicationConversionServiceFactoryBean.PerfilConverter implements Converter<Perfil, String>  {
        public String convert(Perfil perfil) {
            return new StringBuilder().append(perfil.getTipo()).toString();
        }
        
    }
    
    static class br.unicamp.ic.controle.patrimonial.web.ApplicationConversionServiceFactoryBean.TipoNotificacaoConverter implements Converter<TipoNotificacao, String>  {
        public String convert(TipoNotificacao tipoNotificacao) {
            return new StringBuilder().append(tipoNotificacao.getTipo()).append(" ").append(tipoNotificacao.getDescricao()).toString();
        }
        
    }
    
    static class br.unicamp.ic.controle.patrimonial.web.ApplicationConversionServiceFactoryBean.UsuarioConverter implements Converter<Usuario, String>  {
        public String convert(Usuario usuario) {
            return new StringBuilder().append(usuario.getNome()).append(" ").append(usuario.getEmail()).append(" ").append(usuario.getSenha()).append(" ").append(usuario.getRamal()).toString();
        }
        
    }
    
}
