// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package br.unicamp.mc536.t2010s2a.forum.domain;

import br.unicamp.mc536.t2010s2a.forum.domain.Documento;
import br.unicamp.mc536.t2010s2a.forum.domain.Usuario;
import java.util.Date;

privileged aspect UsuarioDocumento_Roo_JavaBean {
    
    public Usuario UsuarioDocumento.getIdUsuario() {
        return this.idUsuario;
    }
    
    public void UsuarioDocumento.setIdUsuario(Usuario idUsuario) {
        this.idUsuario = idUsuario;
    }
    
    public Documento UsuarioDocumento.getIdDocumento() {
        return this.idDocumento;
    }
    
    public void UsuarioDocumento.setIdDocumento(Documento idDocumento) {
        this.idDocumento = idDocumento;
    }
    
    public Date UsuarioDocumento.getDtInclusao() {
        return this.dtInclusao;
    }
    
    public void UsuarioDocumento.setDtInclusao(Date dtInclusao) {
        this.dtInclusao = dtInclusao;
    }
    
}
