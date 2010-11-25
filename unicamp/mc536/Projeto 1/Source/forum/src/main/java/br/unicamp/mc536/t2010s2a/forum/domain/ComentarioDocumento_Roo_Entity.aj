// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package br.unicamp.mc536.t2010s2a.forum.domain;

import br.unicamp.mc536.t2010s2a.forum.domain.ComentarioDocumento;
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

privileged aspect ComentarioDocumento_Roo_Entity {

	@PersistenceContext
	transient EntityManager ComentarioDocumento.entityManager;

	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	@Column(name = "id")
	private Long ComentarioDocumento.id;

	@Version
	@Column(name = "version")
	private Integer ComentarioDocumento.version;

	public Long ComentarioDocumento.getId() {
		return this.id;
	}

	public void ComentarioDocumento.setId(Long id) {
		this.id = id;
	}

	public Integer ComentarioDocumento.getVersion() {
		return this.version;
	}

	public void ComentarioDocumento.setVersion(Integer version) {
		this.version = version;
	}

	@Transactional
	public void ComentarioDocumento.persist() {
		if (this.entityManager == null)
			this.entityManager = entityManager();
		this.entityManager.persist(this);
	}

	@Transactional
	public void ComentarioDocumento.remove() {
		if (this.entityManager == null)
			this.entityManager = entityManager();
		if (this.entityManager.contains(this)) {
			this.entityManager.remove(this);
		} else {
			ComentarioDocumento attached = this.entityManager.find(this
					.getClass(), this.id);
			this.entityManager.remove(attached);
		}
	}

	@Transactional
	public void ComentarioDocumento.flush() {
		if (this.entityManager == null)
			this.entityManager = entityManager();
		this.entityManager.flush();
	}

	@Transactional
	public ComentarioDocumento ComentarioDocumento.merge() {
		if (this.entityManager == null)
			this.entityManager = entityManager();
		ComentarioDocumento merged = this.entityManager.merge(this);
		this.entityManager.flush();
		return merged;
	}

	public static final EntityManager ComentarioDocumento.entityManager() {
		EntityManager em = new ComentarioDocumento().entityManager;
		if (em == null)
			throw new IllegalStateException(
					"Entity manager has not been injected (is the Spring Aspects JAR configured as an AJC/AJDT aspects library?)");
		return em;
	}

	public static long ComentarioDocumento.countComentarioDocumentoes() {
		return ((Number) entityManager().createQuery(
				"select count(o) from ComentarioDocumento o").getSingleResult())
				.longValue();
	}

	@SuppressWarnings("unchecked")
	public static List<ComentarioDocumento> ComentarioDocumento.findAllComentarioDocumentoes() {
		return entityManager().createQuery(
				"select o from ComentarioDocumento o").getResultList();
	}

	@SuppressWarnings("unchecked")
	public static List<ComentarioDocumento> ComentarioDocumento.findComentarioDocumentosByDocumento(
			Long id) {
		return entityManager().createQuery(
				"select o from ComentarioDocumento o where o.idDocumento.id = "
						+ id).getResultList();
	}

	@SuppressWarnings("unchecked")
	public static List<ComentarioDocumento> ComentarioDocumento.findComentarioFilhos(
			Long id) {
		return entityManager().createQuery(
				"select o from ComentarioDocumento o where o.idComentario.id = "
						+ id).getResultList();
	}

	public static ComentarioDocumento ComentarioDocumento.findComentarioDocumento(
			Long id) {
		if (id == null)
			return null;
		return entityManager().find(ComentarioDocumento.class, id);
	}

	@SuppressWarnings("unchecked")
	public static List<ComentarioDocumento> ComentarioDocumento.findComentarioDocumentoEntries(
			int firstResult, int maxResults) {
		return entityManager().createQuery(
				"select o from ComentarioDocumento o").setFirstResult(
				firstResult).setMaxResults(maxResults).getResultList();
	}

}