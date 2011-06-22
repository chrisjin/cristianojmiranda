// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package br.unicamp.ic.controle.patrimonial.domain;

import br.unicamp.ic.controle.patrimonial.domain.Area;
import br.unicamp.ic.controle.patrimonial.domain.Usuario;
import br.unicamp.ic.controle.patrimonial.reference.StatusPatrimonioEnum;
import java.lang.String;
import java.util.Calendar;

privileged aspect Item_Roo_JavaBean {
    
    public String Item.getPid() {
        return this.pid;
    }
    
    public void Item.setPid(String pid) {
        this.pid = pid;
    }
    
    public String Item.getRfid() {
        return this.rfid;
    }
    
    public void Item.setRfid(String rfid) {
        this.rfid = rfid;
    }
    
    public String Item.getNome() {
        return this.nome;
    }
    
    public void Item.setNome(String nome) {
        this.nome = nome;
    }
    
    public String Item.getCategoria() {
        return this.categoria;
    }
    
    public void Item.setCategoria(String categoria) {
        this.categoria = categoria;
    }
    
    public String Item.getDescricao() {
        return this.descricao;
    }
    
    public void Item.setDescricao(String descricao) {
        this.descricao = descricao;
    }
    
    public StatusPatrimonioEnum Item.getStatus() {
        return this.status;
    }
    
    public void Item.setStatus(StatusPatrimonioEnum status) {
        this.status = status;
    }
    
    public Area Item.getArea() {
        return this.area;
    }
    
    public void Item.setArea(Area area) {
        this.area = area;
    }
    
    public String Item.getFlagFomento() {
        return this.flagFomento;
    }
    
    public void Item.setFlagFomento(String flagFomento) {
        this.flagFomento = flagFomento;
    }
    
    public String Item.getFlagLiberarSaida() {
        return this.flagLiberarSaida;
    }
    
    public void Item.setFlagLiberarSaida(String flagLiberarSaida) {
        this.flagLiberarSaida = flagLiberarSaida;
    }
    
    public Calendar Item.getDtLiberacao() {
        return this.dtLiberacao;
    }
    
    public void Item.setDtLiberacao(Calendar dtLiberacao) {
        this.dtLiberacao = dtLiberacao;
    }
    
    public Calendar Item.getDtCriacao() {
        return this.dtCriacao;
    }
    
    public void Item.setDtCriacao(Calendar dtCriacao) {
        this.dtCriacao = dtCriacao;
    }
    
    public Calendar Item.getDtAtualizacao() {
        return this.dtAtualizacao;
    }
    
    public void Item.setDtAtualizacao(Calendar dtAtualizacao) {
        this.dtAtualizacao = dtAtualizacao;
    }
    
    public Usuario Item.getUsuarioResponsavel() {
        return this.usuarioResponsavel;
    }
    
    public void Item.setUsuarioResponsavel(Usuario usuarioResponsavel) {
        this.usuarioResponsavel = usuarioResponsavel;
    }
    
    public Usuario Item.getUsuarioResponsavelAnterior() {
        return this.usuarioResponsavelAnterior;
    }
    
    public void Item.setUsuarioResponsavelAnterior(Usuario usuarioResponsavelAnterior) {
        this.usuarioResponsavelAnterior = usuarioResponsavelAnterior;
    }
    
    public Usuario Item.getUsuarioAtualizacao() {
        return this.usuarioAtualizacao;
    }
    
    public void Item.setUsuarioAtualizacao(Usuario usuarioAtualizacao) {
        this.usuarioAtualizacao = usuarioAtualizacao;
    }
    
    public String Item.getObservacoes() {
        return this.observacoes;
    }
    
    public void Item.setObservacoes(String observacoes) {
        this.observacoes = observacoes;
    }
    
}
