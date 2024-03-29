// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package br.unicamp.mc536.t2010s2a.forum.domain;

import br.unicamp.mc536.t2010s2a.forum.domain.Programa;
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

privileged aspect Programa_Roo_Entity {
    
    @PersistenceContext
    transient EntityManager Programa.entityManager;
    
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name = "id")
    private Long Programa.id;
    
    @Version
    @Column(name = "version")
    private Integer Programa.version;
    
    public Long Programa.getId() {
        return this.id;
    }
    
    public void Programa.setId(Long id) {
        this.id = id;
    }
    
    public Integer Programa.getVersion() {
        return this.version;
    }
    
    public void Programa.setVersion(Integer version) {
        this.version = version;
    }
    
    @Transactional
    public void Programa.persist() {
        if (this.entityManager == null) this.entityManager = entityManager();
        this.entityManager.persist(this);
    }
    
    @Transactional
    public void Programa.remove() {
        if (this.entityManager == null) this.entityManager = entityManager();
        if (this.entityManager.contains(this)) {
            this.entityManager.remove(this);
        } else {
            Programa attached = this.entityManager.find(this.getClass(), this.id);
            this.entityManager.remove(attached);
        }
    }
    
    @Transactional
    public void Programa.flush() {
        if (this.entityManager == null) this.entityManager = entityManager();
        this.entityManager.flush();
    }
    
    @Transactional
    public Programa Programa.merge() {
        if (this.entityManager == null) this.entityManager = entityManager();
        Programa merged = this.entityManager.merge(this);
        this.entityManager.flush();
        return merged;
    }
    
    public static final EntityManager Programa.entityManager() {
        EntityManager em = new Programa().entityManager;
        if (em == null) throw new IllegalStateException("Entity manager has not been injected (is the Spring Aspects JAR configured as an AJC/AJDT aspects library?)");
        return em;
    }
    
    public static long Programa.countProgramas() {
        return ((Number) entityManager().createQuery("select count(o) from Programa o").getSingleResult()).longValue();
    }
    
    @SuppressWarnings("unchecked")
    public static List<Programa> Programa.findAllProgramas() {
        return entityManager().createQuery("select o from Programa o").getResultList();
    }
    
    public static Programa Programa.findPrograma(Long id) {
        if (id == null) return null;
        return entityManager().find(Programa.class, id);
    }
    
    @SuppressWarnings("unchecked")
    public static List<Programa> Programa.findProgramaEntries(int firstResult, int maxResults) {
        return entityManager().createQuery("select o from Programa o").setFirstResult(firstResult).setMaxResults(maxResults).getResultList();
    }
    
}
