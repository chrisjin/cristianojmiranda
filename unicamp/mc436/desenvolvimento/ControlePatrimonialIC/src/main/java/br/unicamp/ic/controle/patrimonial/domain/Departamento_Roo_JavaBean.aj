// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package br.unicamp.ic.controle.patrimonial.domain;

import br.unicamp.ic.controle.patrimonial.reference.EnabledEnum;
import java.lang.String;
import java.util.Calendar;

privileged aspect Departamento_Roo_JavaBean {
    
    public String Departamento.getNome() {
        return this.nome;
    }
    
    public void Departamento.setNome(String nome) {
        this.nome = nome;
    }
    
    public String Departamento.getDescricao() {
        return this.descricao;
    }
    
    public void Departamento.setDescricao(String descricao) {
        this.descricao = descricao;
    }
    
    public EnabledEnum Departamento.getAtivo() {
        return this.ativo;
    }
    
    public void Departamento.setAtivo(EnabledEnum ativo) {
        this.ativo = ativo;
    }
    
    public Calendar Departamento.getDtCriacao() {
        return this.dtCriacao;
    }
    
    public void Departamento.setDtCriacao(Calendar dtCriacao) {
        this.dtCriacao = dtCriacao;
    }
    
    public String Departamento.getResponsavel() {
        return this.responsavel;
    }
    
    public void Departamento.setResponsavel(String responsavel) {
        this.responsavel = responsavel;
    }
    
}
