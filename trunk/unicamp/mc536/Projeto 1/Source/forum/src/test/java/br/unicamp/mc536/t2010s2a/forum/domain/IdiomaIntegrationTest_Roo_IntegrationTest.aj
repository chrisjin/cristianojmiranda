// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package br.unicamp.mc536.t2010s2a.forum.domain;

import br.unicamp.mc536.t2010s2a.forum.domain.IdiomaDataOnDemand;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.transaction.annotation.Transactional;

privileged aspect IdiomaIntegrationTest_Roo_IntegrationTest {
    
    declare @type: IdiomaIntegrationTest: @RunWith(SpringJUnit4ClassRunner.class);
    
    declare @type: IdiomaIntegrationTest: @ContextConfiguration(locations = "classpath:/META-INF/spring/applicationContext.xml");
    
    @Autowired
    private IdiomaDataOnDemand IdiomaIntegrationTest.dod;
    
    @Test
    public void IdiomaIntegrationTest.testCountIdiomas() {
        org.junit.Assert.assertNotNull("Data on demand for 'Idioma' failed to initialize correctly", dod.getRandomIdioma());
        long count = br.unicamp.mc536.t2010s2a.forum.domain.Idioma.countIdiomas();
        org.junit.Assert.assertTrue("Counter for 'Idioma' incorrectly reported there were no entries", count > 0);
    }
    
    @Test
    public void IdiomaIntegrationTest.testFindIdioma() {
        br.unicamp.mc536.t2010s2a.forum.domain.Idioma obj = dod.getRandomIdioma();
        org.junit.Assert.assertNotNull("Data on demand for 'Idioma' failed to initialize correctly", obj);
        java.lang.Long id = obj.getId();
        org.junit.Assert.assertNotNull("Data on demand for 'Idioma' failed to provide an identifier", id);
        obj = br.unicamp.mc536.t2010s2a.forum.domain.Idioma.findIdioma(id);
        org.junit.Assert.assertNotNull("Find method for 'Idioma' illegally returned null for id '" + id + "'", obj);
        org.junit.Assert.assertEquals("Find method for 'Idioma' returned the incorrect identifier", id, obj.getId());
    }
    
    @Test
    public void IdiomaIntegrationTest.testFindAllIdiomas() {
        org.junit.Assert.assertNotNull("Data on demand for 'Idioma' failed to initialize correctly", dod.getRandomIdioma());
        long count = br.unicamp.mc536.t2010s2a.forum.domain.Idioma.countIdiomas();
        org.junit.Assert.assertTrue("Too expensive to perform a find all test for 'Idioma', as there are " + count + " entries; set the findAllMaximum to exceed this value or set findAll=false on the integration test annotation to disable the test", count < 250);
        java.util.List<br.unicamp.mc536.t2010s2a.forum.domain.Idioma> result = br.unicamp.mc536.t2010s2a.forum.domain.Idioma.findAllIdiomas();
        org.junit.Assert.assertNotNull("Find all method for 'Idioma' illegally returned null", result);
        org.junit.Assert.assertTrue("Find all method for 'Idioma' failed to return any data", result.size() > 0);
    }
    
    @Test
    public void IdiomaIntegrationTest.testFindIdiomaEntries() {
        org.junit.Assert.assertNotNull("Data on demand for 'Idioma' failed to initialize correctly", dod.getRandomIdioma());
        long count = br.unicamp.mc536.t2010s2a.forum.domain.Idioma.countIdiomas();
        if (count > 20) count = 20;
        java.util.List<br.unicamp.mc536.t2010s2a.forum.domain.Idioma> result = br.unicamp.mc536.t2010s2a.forum.domain.Idioma.findIdiomaEntries(0, (int) count);
        org.junit.Assert.assertNotNull("Find entries method for 'Idioma' illegally returned null", result);
        org.junit.Assert.assertEquals("Find entries method for 'Idioma' returned an incorrect number of entries", count, result.size());
    }
    
    @Test
    @Transactional
    public void IdiomaIntegrationTest.testFlush() {
        br.unicamp.mc536.t2010s2a.forum.domain.Idioma obj = dod.getRandomIdioma();
        org.junit.Assert.assertNotNull("Data on demand for 'Idioma' failed to initialize correctly", obj);
        java.lang.Long id = obj.getId();
        org.junit.Assert.assertNotNull("Data on demand for 'Idioma' failed to provide an identifier", id);
        obj = br.unicamp.mc536.t2010s2a.forum.domain.Idioma.findIdioma(id);
        org.junit.Assert.assertNotNull("Find method for 'Idioma' illegally returned null for id '" + id + "'", obj);
        boolean modified =  dod.modifyIdioma(obj);
        java.lang.Integer currentVersion = obj.getVersion();
        obj.flush();
        org.junit.Assert.assertTrue("Version for 'Idioma' failed to increment on flush directive", obj.getVersion() > currentVersion || !modified);
    }
    
    @Test
    @Transactional
    public void IdiomaIntegrationTest.testMerge() {
        br.unicamp.mc536.t2010s2a.forum.domain.Idioma obj = dod.getRandomIdioma();
        org.junit.Assert.assertNotNull("Data on demand for 'Idioma' failed to initialize correctly", obj);
        java.lang.Long id = obj.getId();
        org.junit.Assert.assertNotNull("Data on demand for 'Idioma' failed to provide an identifier", id);
        obj = br.unicamp.mc536.t2010s2a.forum.domain.Idioma.findIdioma(id);
        boolean modified =  dod.modifyIdioma(obj);
        java.lang.Integer currentVersion = obj.getVersion();
        obj.merge();
        obj.flush();
        org.junit.Assert.assertTrue("Version for 'Idioma' failed to increment on merge and flush directive", obj.getVersion() > currentVersion || !modified);
    }
    
    @Test
    @Transactional
    public void IdiomaIntegrationTest.testPersist() {
        org.junit.Assert.assertNotNull("Data on demand for 'Idioma' failed to initialize correctly", dod.getRandomIdioma());
        br.unicamp.mc536.t2010s2a.forum.domain.Idioma obj = dod.getNewTransientIdioma(Integer.MAX_VALUE);
        org.junit.Assert.assertNotNull("Data on demand for 'Idioma' failed to provide a new transient entity", obj);
        org.junit.Assert.assertNull("Expected 'Idioma' identifier to be null", obj.getId());
        obj.persist();
        obj.flush();
        org.junit.Assert.assertNotNull("Expected 'Idioma' identifier to no longer be null", obj.getId());
    }
    
    @Test
    @Transactional
    public void IdiomaIntegrationTest.testRemove() {
        br.unicamp.mc536.t2010s2a.forum.domain.Idioma obj = dod.getRandomIdioma();
        org.junit.Assert.assertNotNull("Data on demand for 'Idioma' failed to initialize correctly", obj);
        java.lang.Long id = obj.getId();
        org.junit.Assert.assertNotNull("Data on demand for 'Idioma' failed to provide an identifier", id);
        obj = br.unicamp.mc536.t2010s2a.forum.domain.Idioma.findIdioma(id);
        obj.remove();
        obj.flush();
        org.junit.Assert.assertNull("Failed to remove 'Idioma' with identifier '" + id + "'", br.unicamp.mc536.t2010s2a.forum.domain.Idioma.findIdioma(id));
    }
    
}
