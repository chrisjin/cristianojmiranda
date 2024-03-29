// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package br.unicamp.mc536.t2010s2a.forum.domain;

import br.unicamp.mc536.t2010s2a.forum.domain.RedeTrabalhoUsuario;
import java.lang.Integer;
import java.lang.Long;
import java.lang.SuppressWarnings;
import java.util.List;
import javax.persistence.Column;
import javax.persistence.EntityManager;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.PersistenceContext;
import javax.persistence.Version;
import org.springframework.transaction.annotation.Transactional;

privileged aspect RedeTrabalhoUsuario_Roo_Entity {
    
    @PersistenceContext
    transient EntityManager RedeTrabalhoUsuario.entityManager;
    
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name = "id")
    private Long RedeTrabalhoUsuario.id;
    
    @Version
    @Column(name = "version")
    private Integer RedeTrabalhoUsuario.version;
    
    public Long RedeTrabalhoUsuario.getId() {
        return this.id;
    }
    
    public void RedeTrabalhoUsuario.setId(Long id) {
        this.id = id;
    }
    
    public Integer RedeTrabalhoUsuario.getVersion() {
        return this.version;
    }
    
    public void RedeTrabalhoUsuario.setVersion(Integer version) {
        this.version = version;
    }
    
    @Transactional
    public void RedeTrabalhoUsuario.persist() {
        if (this.entityManager == null) this.entityManager = entityManager();
        this.entityManager.persist(this);
    }
    
    @Transactional
    public void RedeTrabalhoUsuario.remove() {
        if (this.entityManager == null) this.entityManager = entityManager();
        if (this.entityManager.contains(this)) {
            this.entityManager.remove(this);
        } else {
            RedeTrabalhoUsuario attached = this.entityManager.find(this.getClass(), this.id);
            this.entityManager.remove(attached);
        }
    }
    
    @Transactional
    public void RedeTrabalhoUsuario.flush() {
        if (this.entityManager == null) this.entityManager = entityManager();
        this.entityManager.flush();
    }
    
    @Transactional
    public RedeTrabalhoUsuario RedeTrabalhoUsuario.merge() {
        if (this.entityManager == null) this.entityManager = entityManager();
        RedeTrabalhoUsuario merged = this.entityManager.merge(this);
        this.entityManager.flush();
        return merged;
    }
    
    public static final EntityManager RedeTrabalhoUsuario.entityManager() {
        EntityManager em = new RedeTrabalhoUsuario().entityManager;
        if (em == null) throw new IllegalStateException("Entity manager has not been injected (is the Spring Aspects JAR configured as an AJC/AJDT aspects library?)");
        return em;
    }
    
    public static long RedeTrabalhoUsuario.countRedeTrabalhoUsuarios() {
        return ((Number) entityManager().createQuery("select count(o) from RedeTrabalhoUsuario o").getSingleResult()).longValue();
    }
    
    @SuppressWarnings("unchecked")
    public static List<RedeTrabalhoUsuario> RedeTrabalhoUsuario.findAllRedeTrabalhoUsuarios() {
        return entityManager().createQuery("select o from RedeTrabalhoUsuario o").getResultList();
    }
    
    public static RedeTrabalhoUsuario RedeTrabalhoUsuario.findRedeTrabalhoUsuario(Long id) {
        if (id == null) return null;
        return entityManager().find(RedeTrabalhoUsuario.class, id);
    }
    
    @SuppressWarnings("unchecked")
    public static List<RedeTrabalhoUsuario> RedeTrabalhoUsuario.findRedeTrabalhoUsuarioEntries(int firstResult, int maxResults) {
        return entityManager().createQuery("select o from RedeTrabalhoUsuario o").setFirstResult(firstResult).setMaxResults(maxResults).getResultList();
    }
    
}
