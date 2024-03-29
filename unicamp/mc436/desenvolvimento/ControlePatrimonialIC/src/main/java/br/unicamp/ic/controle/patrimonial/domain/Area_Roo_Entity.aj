// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package br.unicamp.ic.controle.patrimonial.domain;

import br.unicamp.ic.controle.patrimonial.domain.Area;
import java.lang.Integer;
import java.lang.Long;
import java.util.List;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.EntityManager;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.PersistenceContext;
import javax.persistence.Version;
import org.springframework.transaction.annotation.Transactional;

privileged aspect Area_Roo_Entity {
    
    declare @type: Area: @Entity;
    
    @PersistenceContext
    transient EntityManager Area.entityManager;
    
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name = "id")
    private Long Area.id;
    
    @Version
    @Column(name = "version")
    private Integer Area.version;
    
    public Long Area.getId() {
        return this.id;
    }
    
    public void Area.setId(Long id) {
        this.id = id;
    }
    
    public Integer Area.getVersion() {
        return this.version;
    }
    
    public void Area.setVersion(Integer version) {
        this.version = version;
    }
    
    @Transactional
    public void Area.persist() {
        if (this.entityManager == null) this.entityManager = entityManager();
        this.entityManager.persist(this);
    }
    
    @Transactional
    public void Area.remove() {
        if (this.entityManager == null) this.entityManager = entityManager();
        if (this.entityManager.contains(this)) {
            this.entityManager.remove(this);
        } else {
            Area attached = Area.findArea(this.id);
            this.entityManager.remove(attached);
        }
    }
    
    @Transactional
    public void Area.flush() {
        if (this.entityManager == null) this.entityManager = entityManager();
        this.entityManager.flush();
    }
    
    @Transactional
    public void Area.clear() {
        if (this.entityManager == null) this.entityManager = entityManager();
        this.entityManager.clear();
    }
    
    @Transactional
    public Area Area.merge() {
        if (this.entityManager == null) this.entityManager = entityManager();
        Area merged = this.entityManager.merge(this);
        this.entityManager.flush();
        return merged;
    }
    
    public static final EntityManager Area.entityManager() {
        EntityManager em = new Area().entityManager;
        if (em == null) throw new IllegalStateException("Entity manager has not been injected (is the Spring Aspects JAR configured as an AJC/AJDT aspects library?)");
        return em;
    }
    
    public static long Area.countAreas() {
        return entityManager().createQuery("SELECT COUNT(o) FROM Area o", Long.class).getSingleResult();
    }
    
    public static List<Area> Area.findAllAreas() {
        return entityManager().createQuery("SELECT o FROM Area o", Area.class).getResultList();
    }
    
    public static Area Area.findArea(Long id) {
        if (id == null) return null;
        return entityManager().find(Area.class, id);
    }
    
    public static List<Area> Area.findAreaEntries(int firstResult, int maxResults) {
        return entityManager().createQuery("SELECT o FROM Area o", Area.class).setFirstResult(firstResult).setMaxResults(maxResults).getResultList();
    }
    
}
