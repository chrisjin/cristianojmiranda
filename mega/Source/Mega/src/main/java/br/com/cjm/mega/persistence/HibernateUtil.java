package br.com.cjm.mega.persistence;

import org.hibernate.SessionFactory;
import org.hibernate.cfg.AnnotationConfiguration;

/**
 * @author Cristiano
 * 
 */
public class HibernateUtil {

	private static final SessionFactory sessionFactory;
	static {
		sessionFactory = new AnnotationConfiguration().configure()
				.buildSessionFactory();
	}

	public static SessionFactory getSessionFactory() {
		return sessionFactory;
	}
}
