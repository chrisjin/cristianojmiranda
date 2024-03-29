// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package br.unicamp.mc536.t2010s2a.forum.domain;

import br.unicamp.mc536.t2010s2a.forum.domain.UsuarioDocumento;
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

privileged aspect UsuarioDocumento_Roo_Entity {

	@PersistenceContext
	transient EntityManager UsuarioDocumento.entityManager;

	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	@Column(name = "id")
	private Long UsuarioDocumento.id;

	@Version
	@Column(name = "version")
	private Integer UsuarioDocumento.version;

	public Long UsuarioDocumento.getId() {
		return this.id;
	}

	public void UsuarioDocumento.setId(Long id) {
		this.id = id;
	}

	public Integer UsuarioDocumento.getVersion() {
		return this.version;
	}

	public void UsuarioDocumento.setVersion(Integer version) {
		this.version = version;
	}

	@Transactional
	public void UsuarioDocumento.persist() {
		if (this.entityManager == null)
			this.entityManager = entityManager();
		this.entityManager.persist(this);
	}

	@Transactional
	public void UsuarioDocumento.remove() {
		if (this.entityManager == null)
			this.entityManager = entityManager();
		if (this.entityManager.contains(this)) {
			this.entityManager.remove(this);
		} else {
			UsuarioDocumento attached = this.entityManager.find(
					this.getClass(), this.id);
			this.entityManager.remove(attached);
		}
	}

	@Transactional
	public void UsuarioDocumento.flush() {
		if (this.entityManager == null)
			this.entityManager = entityManager();
		this.entityManager.flush();
	}

	@Transactional
	public UsuarioDocumento UsuarioDocumento.merge() {
		if (this.entityManager == null)
			this.entityManager = entityManager();
		UsuarioDocumento merged = this.entityManager.merge(this);
		this.entityManager.flush();
		return merged;
	}

	public static final EntityManager UsuarioDocumento.entityManager() {
		EntityManager em = new UsuarioDocumento().entityManager;
		if (em == null)
			throw new IllegalStateException(
					"Entity manager has not been injected (is the Spring Aspects JAR configured as an AJC/AJDT aspects library?)");
		return em;
	}

	public static long UsuarioDocumento.countUsuarioDocumentoes() {
		return ((Number) entityManager().createQuery(
				"select count(o) from UsuarioDocumento o").getSingleResult())
				.longValue();
	}

	@SuppressWarnings("unchecked")
	public static List<UsuarioDocumento> UsuarioDocumento.findAllUsuarioDocumentoes() {
		return entityManager().createQuery("select o from UsuarioDocumento o")
				.getResultList();
	}

	@SuppressWarnings("unchecked")
	public static List<UsuarioDocumento> UsuarioDocumento.findUsuarioDocumentosByDocumento(
			Long id) {
		return entityManager()
				.createQuery(
						"select o from UsuarioDocumento o where o.idDocumento.id= "
								+ id).getResultList();
	}

	public static UsuarioDocumento UsuarioDocumento.findUsuarioDocumento(Long id) {
		if (id == null)
			return null;
		return entityManager().find(UsuarioDocumento.class, id);
	}

	@SuppressWarnings("unchecked")
	public static List<UsuarioDocumento> UsuarioDocumento.findUsuarioDocumentoEntries(
			int firstResult, int maxResults) {
		return entityManager().createQuery("select o from UsuarioDocumento o")
				.setFirstResult(firstResult).setMaxResults(maxResults)
				.getResultList();
	}

}
