package it.sauronsoftware.grab4j.html.search;

import junit.framework.TestCase;

/**
 * @author Cristiano
 * 
 */
public class CriteriaTest extends TestCase {

	/**
	 * Testando exception para criteria vazio.
	 */
	public void testEmptyCriteria() {

		try {

			Criteria criteria = new Criteria("");
			criteria.getConditionCount();
			fail("Era esperado InvalidCriteriaException.");

		} catch (InvalidCriteriaException invalidCriteriaException) {

		} catch (Exception e) {
			fail("Era esperado InvalidCriteriaException.");
		}
	}

}
