// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package br.unicamp.ic.controle.patrimonial.domain;

import java.lang.String;

privileged aspect LocalizacaoItem_Roo_ToString {
    
    public String LocalizacaoItem.toString() {
        StringBuilder sb = new StringBuilder();
        sb.append("Area: ").append(getArea()).append(", ");
        sb.append("Descricao: ").append(getDescricao()).append(", ");
        sb.append("DtAtualizacao: ").append(getDtAtualizacao() == null ? "null" : getDtAtualizacao().getTime()).append(", ");
        sb.append("Id: ").append(getId()).append(", ");
        sb.append("Item: ").append(getItem()).append(", ");
        sb.append("Observacoes: ").append(getObservacoes()).append(", ");
        sb.append("UsuarioAtualizacao: ").append(getUsuarioAtualizacao()).append(", ");
        sb.append("Version: ").append(getVersion());
        return sb.toString();
    }
    
}
