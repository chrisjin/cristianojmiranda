// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package br.unicamp.mc536.t2010s2a.forum.domain;

import br.unicamp.mc536.t2010s2a.forum.domain.Idioma;
import br.unicamp.mc536.t2010s2a.forum.domain.Usuario;

privileged aspect UsuarioIdioma_Roo_JavaBean {
    
    public Usuario UsuarioIdioma.getIdUsuario() {
        return this.idUsuario;
    }
    
    public void UsuarioIdioma.setIdUsuario(Usuario idUsuario) {
        this.idUsuario = idUsuario;
    }
    
    public Idioma UsuarioIdioma.getIdIdioma() {
        return this.idIdioma;
    }
    
    public void UsuarioIdioma.setIdIdioma(Idioma idIdioma) {
        this.idIdioma = idIdioma;
    }
    
}