// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package br.unicamp.mc536.t2010s2a.forum.domain;

import br.unicamp.mc536.t2010s2a.forum.domain.Documento;
import br.unicamp.mc536.t2010s2a.forum.domain.Idioma;
import java.lang.String;

privileged aspect PalavraDocumento_Roo_JavaBean {
    
    public Documento PalavraDocumento.getIdDocumento() {
        return this.idDocumento;
    }
    
    public void PalavraDocumento.setIdDocumento(Documento idDocumento) {
        this.idDocumento = idDocumento;
    }
    
    public Idioma PalavraDocumento.getIdIdioma() {
        return this.idIdioma;
    }
    
    public void PalavraDocumento.setIdIdioma(Idioma idIdioma) {
        this.idIdioma = idIdioma;
    }
    
    public String PalavraDocumento.getDsPalavrasChaves() {
        return this.dsPalavrasChaves;
    }
    
    public void PalavraDocumento.setDsPalavrasChaves(String dsPalavrasChaves) {
        this.dsPalavrasChaves = dsPalavrasChaves;
    }
    
}
