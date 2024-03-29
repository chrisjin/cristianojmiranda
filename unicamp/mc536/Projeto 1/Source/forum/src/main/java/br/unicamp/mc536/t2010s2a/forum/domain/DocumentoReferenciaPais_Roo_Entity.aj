// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package br.unicamp.mc536.t2010s2a.forum.domain;

import br.unicamp.mc536.t2010s2a.forum.domain.DocumentoReferenciaPais;
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

privileged aspect DocumentoReferenciaPais_Roo_Entity {

	@PersistenceContext
	transient EntityManager DocumentoReferenciaPais.entityManager;

	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	@Column(name = "id")
	private Long DocumentoReferenciaPais.id;

	@Version
	@Column(name = "version")
	private Integer DocumentoReferenciaPais.version;

	public Long DocumentoReferenciaPais.getId() {
		return this.id;
	}

	public void DocumentoReferenciaPais.setId(Long id) {
		this.id = id;
	}

	public Integer DocumentoReferenciaPais.getVersion() {
		return this.version;
	}

	public void DocumentoReferenciaPais.setVersion(Integer version) {
		this.version = version;
	}

	@Transactional
	public void DocumentoReferenciaPais.persist() {
		if (this.entityManager == null)
			this.entityManager = entityManager();
		this.entityManager.persist(this);
	}

	@Transactional
	public void DocumentoReferenciaPais.remove() {
		if (this.entityManager == null)
			this.entityManager = entityManager();
		if (this.entityManager.contains(this)) {
			this.entityManager.remove(this);
		} else {
			DocumentoReferenciaPais attached = this.entityManager.find(this
					.getClass(), this.id);
			this.entityManager.remove(attached);
		}
	}

	@Transactional
	public void DocumentoReferenciaPais.flush() {
		if (this.entityManager == null)
			this.entityManager = entityManager();
		this.entityManager.flush();
	}

	@Transactional
	public DocumentoReferenciaPais DocumentoReferenciaPais.merge() {
		if (this.entityManager == null)
			this.entityManager = entityManager();
		DocumentoReferenciaPais merged = this.entityManager.merge(this);
		this.entityManager.flush();
		return merged;
	}

	public static final EntityManager DocumentoReferenciaPais.entityManager() {
		EntityManager em = new DocumentoReferenciaPais().entityManager;
		if (em == null)
			throw new IllegalStateException(
					"Entity manager has not been injected (is the Spring Aspects JAR configured as an AJC/AJDT aspects library?)");
		return em;
	}

	public static long DocumentoReferenciaPais.countDocumentoReferenciaPaises() {
		return ((Number) entityManager().createQuery(
				"select count(o) from DocumentoReferenciaPais o")
				.getSingleResult()).longValue();
	}

	@SuppressWarnings("unchecked")
	public static List<DocumentoReferenciaPais> DocumentoReferenciaPais.findAllDocumentoReferenciaPaises() {
		return entityManager().createQuery(
				"select o from DocumentoReferenciaPais o").getResultList();
	}

	@SuppressWarnings("unchecked")
	public static List<DocumentoReferenciaPais> DocumentoReferenciaPais.findDocumentoReferenciaPaisesByDocumento(
			Long id) {
		return entityManager().createQuery(
				"select o from DocumentoReferenciaPais o where o.idDocumento.id = "
						+ id).getResultList();
	}

	public static DocumentoReferenciaPais DocumentoReferenciaPais.findDocumentoReferenciaPais(
			Long id) {
		if (id == null)
			return null;
		return entityManager().find(DocumentoReferenciaPais.class, id);
	}

	@SuppressWarnings("unchecked")
	public static List<DocumentoReferenciaPais> DocumentoReferenciaPais.findDocumentoReferenciaPaisEntries(
			int firstResult, int maxResults) {
		return entityManager().createQuery(
				"select o from DocumentoReferenciaPais o").setFirstResult(
				firstResult).setMaxResults(maxResults).getResultList();
	}

}
