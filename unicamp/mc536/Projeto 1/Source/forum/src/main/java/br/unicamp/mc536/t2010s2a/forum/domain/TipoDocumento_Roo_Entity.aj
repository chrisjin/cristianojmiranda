// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package br.unicamp.mc536.t2010s2a.forum.domain;

import java.util.List;

import javax.persistence.Column;
import javax.persistence.EntityManager;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;
import javax.persistence.Version;

import org.springframework.transaction.annotation.Transactional;

privileged aspect TipoDocumento_Roo_Entity {

	@PersistenceContext
	transient EntityManager TipoDocumento.entityManager;

	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	@Column(name = "id")
	private Long TipoDocumento.id;

	@Version
	@Column(name = "version")
	private Integer TipoDocumento.version;

	public Long TipoDocumento.getId() {
		return this.id;
	}

	public void TipoDocumento.setId(Long id) {
		this.id = id;
	}

	public Integer TipoDocumento.getVersion() {
		return this.version;
	}

	public void TipoDocumento.setVersion(Integer version) {
		this.version = version;
	}

	@Transactional
	public void TipoDocumento.persist() {
		if (this.entityManager == null)
			this.entityManager = entityManager();
		this.entityManager.persist(this);
	}

	@Transactional
	public void TipoDocumento.remove() {
		if (this.entityManager == null)
			this.entityManager = entityManager();
		if (this.entityManager.contains(this)) {
			this.entityManager.remove(this);
		} else {
			TipoDocumento attached = this.entityManager.find(this.getClass(),
					this.id);
			this.entityManager.remove(attached);
		}
	}

	@Transactional
	public void TipoDocumento.flush() {
		if (this.entityManager == null)
			this.entityManager = entityManager();
		this.entityManager.flush();
	}

	@Transactional
	public TipoDocumento TipoDocumento.merge() {
		if (this.entityManager == null)
			this.entityManager = entityManager();
		TipoDocumento merged = this.entityManager.merge(this);
		this.entityManager.flush();
		return merged;
	}

	public static final EntityManager TipoDocumento.entityManager() {
		EntityManager em = new TipoDocumento().entityManager;
		if (em == null)
			throw new IllegalStateException(
					"Entity manager has not been injected (is the Spring Aspects JAR configured as an AJC/AJDT aspects library?)");
		return em;
	}

	public static long TipoDocumento.countTipoDocumentoes() {
		return ((Number) entityManager().createQuery(
				"select count(o) from TipoDocumento o").getSingleResult())
				.longValue();
	}

	@SuppressWarnings("unchecked")
	public static List<TipoDocumento> TipoDocumento.findAllTipoDocumentoes() {
		return entityManager().createQuery("select o from TipoDocumento o")
				.getResultList();
	}

	public static TipoDocumento TipoDocumento.findTipoDocumento(Long id) {
		if (id == null)
			return null;
		return entityManager().find(TipoDocumento.class, id);
	}

	@SuppressWarnings("unchecked")
	public static List<TipoDocumento> TipoDocumento.findTipoDocumentoEntries(
			int firstResult, int maxResults) {
		return entityManager().createQuery("select o from TipoDocumento o")
				.setFirstResult(firstResult).setMaxResults(maxResults)
				.getResultList();
	}

	@SuppressWarnings("unchecked")
	public static List<TipoDocumento> TipoDocumento.findTipoDocumentoByNome(
			String nmTipoDocumento) {

		// Monta a consulta de tipo de documento
		Query query = entityManager()
				.createQuery(
						"select o from TipoDocumento o where trim(upper(o.nmTipoDocumento)) = trim(upper(:nmTipoDocumento))");

		// Seta o parametro de consulta
		query.setParameter("nmTipoDocumento", nmTipoDocumento);

		// Executa a consulta
		return query.getResultList();

	}

}
