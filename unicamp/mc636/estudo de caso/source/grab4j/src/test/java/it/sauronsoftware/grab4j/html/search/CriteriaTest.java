package it.sauronsoftware.grab4j.html.search;

import it.sauronsoftware.grab4j.toolkit.EnvironmentToolkit;
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

	/**
	 * Testando exception para criteria vazio.
	 */
	public void testInvalidCriteria() {

		try {

			// Instancia uma criteria invalida
			Criteria criteria = new Criteria(" .[*]\\/[1] ");
			criteria.getConditionCount();
			fail("Era esperado InvalidCriteriaException.");

		} catch (InvalidCriteriaException invalidCriteriaException) {

		} catch (Exception e) {
			fail("Era esperado InvalidCriteriaException.");
		}
	}

	/**
	 * 
	 */
	public void testConditionsSize() {

		Criteria criteria = new Criteria("html/body/div");
		EnvironmentToolkit.print("testConditionsSize: "
				+ criteria.getConditionCount());

		assertEquals("Era esperado criteria com 3 conditions", 3, criteria
				.getConditionCount());
	}

}
