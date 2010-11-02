// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package br.unicamp.mc536.t2010s2a.forum.domain;

import br.unicamp.mc536.t2010s2a.forum.domain.DescricaoDocumento;
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

privileged aspect DescricaoDocumento_Roo_Entity {
    
    @PersistenceContext
    transient EntityManager DescricaoDocumento.entityManager;
    
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name = "id")
    private Long DescricaoDocumento.id;
    
    @Version
    @Column(name = "version")
    private Integer DescricaoDocumento.version;
    
    public Long DescricaoDocumento.getId() {
        return this.id;
    }
    
    public void DescricaoDocumento.setId(Long id) {
        this.id = id;
    }
    
    public Integer DescricaoDocumento.getVersion() {
        return this.version;
    }
    
    public void DescricaoDocumento.setVersion(Integer version) {
        this.version = version;
    }
    
    @Transactional
    public void DescricaoDocumento.persist() {
        if (this.entityManager == null) this.entityManager = entityManager();
        this.entityManager.persist(this);
    }
    
    @Transactional
    public void DescricaoDocumento.remove() {
        if (this.entityManager == null) this.entityManager = entityManager();
        if (this.entityManager.contains(this)) {
            this.entityManager.remove(this);
        } else {
            DescricaoDocumento attached = this.entityManager.find(this.getClass(), this.id);
            this.entityManager.remove(attached);
        }
    }
    
    @Transactional
    public void DescricaoDocumento.flush() {
        if (this.entityManager == null) this.entityManager = entityManager();
        this.entityManager.flush();
    }
    
    @Transactional
    public DescricaoDocumento DescricaoDocumento.merge() {
        if (this.entityManager == null) this.entityManager = entityManager();
        DescricaoDocumento merged = this.entityManager.merge(this);
        this.entityManager.flush();
        return merged;
    }
    
    public static final EntityManager DescricaoDocumento.entityManager() {
        EntityManager em = new DescricaoDocumento().entityManager;
        if (em == null) throw new IllegalStateException("Entity manager has not been injected (is the Spring Aspects JAR configured as an AJC/AJDT aspects library?)");
        return em;
    }
    
    public static long DescricaoDocumento.countDescricaoDocumentoes() {
        return ((Number) entityManager().createQuery("select count(o) from DescricaoDocumento o").getSingleResult()).longValue();
    }
    
    @SuppressWarnings("unchecked")
    public static List<DescricaoDocumento> DescricaoDocumento.findAllDescricaoDocumentoes() {
        return entityManager().createQuery("select o from DescricaoDocumento o").getResultList();
    }
    
    public static DescricaoDocumento DescricaoDocumento.findDescricaoDocumento(Long id) {
        if (id == null) return null;
        return entityManager().find(DescricaoDocumento.class, id);
    }
    
    @SuppressWarnings("unchecked")
    public static List<DescricaoDocumento> DescricaoDocumento.findDescricaoDocumentoEntries(int firstResult, int maxResults) {
        return entityManager().createQuery("select o from DescricaoDocumento o").setFirstResult(firstResult).setMaxResults(maxResults).getResultList();
    }
    
}