// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package br.unicamp.mc536.t2010s2a.forum.domain;

import java.lang.String;

privileged aspect ComentarioDocumento_Roo_ToString {
    
    public String ComentarioDocumento.toString() {
        StringBuilder sb = new StringBuilder();
        sb.append("Id: ").append(getId()).append(", ");
        sb.append("Version: ").append(getVersion()).append(", ");
        sb.append("IdUsuario: ").append(getIdUsuario()).append(", ");
        sb.append("IdDocumento: ").append(getIdDocumento()).append(", ");
        sb.append("DsComentario: ").append(getDsComentario()).append(", ");
        sb.append("DtInclusao: ").append(getDtInclusao()).append(", ");
        sb.append("IdComentario: ").append(getIdComentario()).append(", ");
        sb.append("TpReferenciaDocumento: ").append(getTpReferenciaDocumento());
        return sb.toString();
    }
    
}