// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package br.unicamp.ic.controle.patrimonial.domain;

import java.lang.String;

privileged aspect Perfil_Roo_ToString {
    
    public String Perfil.toString() {
        StringBuilder sb = new StringBuilder();
        sb.append("Ativo: ").append(getAtivo()).append(", ");
        sb.append("Id: ").append(getId()).append(", ");
        sb.append("Tipo: ").append(getTipo()).append(", ");
        sb.append("Version: ").append(getVersion());
        return sb.toString();
    }
    
}
