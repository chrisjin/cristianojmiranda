// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package br.unicamp.mc536.t2010s2a.forum.domain;

import br.unicamp.mc536.t2010s2a.forum.domain.DocumentoVinculo;
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

privileged aspect DocumentoVinculo_Roo_Entity {

	@PersistenceContext
	transient EntityManager DocumentoVinculo.entityManager;

	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	@Column(name = "id")
	private Long DocumentoVinculo.id;

	@Version
	@Column(name = "version")
	private Integer DocumentoVinculo.version;

	public Long DocumentoVinculo.getId() {
		return this.id;
	}

	public void DocumentoVinculo.setId(Long id) {
		this.id = id;
	}

	public Integer DocumentoVinculo.getVersion() {
		return this.version;
	}

	public void DocumentoVinculo.setVersion(Integer version) {
		this.version = version;
	}

	@Transactional
	public void DocumentoVinculo.persist() {
		if (this.entityManager == null)
			this.entityManager = entityManager();
		this.entityManager.persist(this);
	}

	@Transactional
	public void DocumentoVinculo.remove() {
		if (this.entityManager == null)
			this.entityManager = entityManager();
		if (this.entityManager.contains(this)) {
			this.entityManager.remove(this);
		} else {
			DocumentoVinculo attached = this.entityManager.find(
					this.getClass(), this.id);
			this.entityManager.remove(attached);
		}
	}

	@Transactional
	public void DocumentoVinculo.flush() {
		if (this.entityManager == null)
			this.entityManager = entityManager();
		this.entityManager.flush();
	}

	@Transactional
	public DocumentoVinculo DocumentoVinculo.merge() {
		if (this.entityManager == null)
			this.entityManager = entityManager();
		DocumentoVinculo merged = this.entityManager.merge(this);
		this.entityManager.flush();
		return merged;
	}

	public static final EntityManager DocumentoVinculo.entityManager() {
		EntityManager em = new DocumentoVinculo().entityManager;
		if (em == null)
			throw new IllegalStateException(
					"Entity manager has not been injected (is the Spring Aspects JAR configured as an AJC/AJDT aspects library?)");
		return em;
	}

	public static long DocumentoVinculo.countDocumentoVinculoes() {
		return ((Number) entityManager().createQuery(
				"select count(o) from DocumentoVinculo o").getSingleResult())
				.longValue();
	}

	@SuppressWarnings("unchecked")
	public static List<DocumentoVinculo> DocumentoVinculo.findAllDocumentoVinculoes() {
		return entityManager().createQuery("select o from DocumentoVinculo o")
				.getResultList();
	}

	@SuppressWarnings("unchecked")
	public static List<DocumentoVinculo> DocumentoVinculo.findDocumentoVinculosByDocumento(
			Long id) {
		return entityManager().createQuery(
				"select o from DocumentoVinculo o where o.idDocumento.id = "
						+ id).getResultList();
	}

	public static DocumentoVinculo DocumentoVinculo.findDocumentoVinculo(Long id) {
		if (id == null)
			return null;
		return entityManager().find(DocumentoVinculo.class, id);
	}

	@SuppressWarnings("unchecked")
	public static List<DocumentoVinculo> DocumentoVinculo.findDocumentoVinculoEntries(
			int firstResult, int maxResults) {
		return entityManager().createQuery("select o from DocumentoVinculo o")
				.setFirstResult(firstResult).setMaxResults(maxResults)
				.getResultList();
	}

}
