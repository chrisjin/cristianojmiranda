// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package br.unicamp.ic.controle.patrimonial.domain;

import br.unicamp.ic.controle.patrimonial.domain.Funcionalidade;
import br.unicamp.ic.controle.patrimonial.domain.Perfil;

privileged aspect PerfilFuncionalidade_Roo_JavaBean {
    
    public Perfil PerfilFuncionalidade.getPerfil() {
        return this.perfil;
    }
    
    public void PerfilFuncionalidade.setPerfil(Perfil perfil) {
        this.perfil = perfil;
    }
    
    public Funcionalidade PerfilFuncionalidade.getFuncionalidade() {
        return this.funcionalidade;
    }
    
    public void PerfilFuncionalidade.setFuncionalidade(Funcionalidade funcionalidade) {
        this.funcionalidade = funcionalidade;
    }
    
}
