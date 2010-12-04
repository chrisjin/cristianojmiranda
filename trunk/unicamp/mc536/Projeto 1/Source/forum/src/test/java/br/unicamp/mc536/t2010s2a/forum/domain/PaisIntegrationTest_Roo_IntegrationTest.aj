// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package br.unicamp.mc536.t2010s2a.forum.domain;

import br.unicamp.mc536.t2010s2a.forum.domain.PaisDataOnDemand;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.transaction.annotation.Transactional;

privileged aspect PaisIntegrationTest_Roo_IntegrationTest {
    
    declare @type: PaisIntegrationTest: @RunWith(SpringJUnit4ClassRunner.class);
    
    declare @type: PaisIntegrationTest: @ContextConfiguration(locations = "classpath:/META-INF/spring/applicationContext.xml");
    
    @Autowired
    private PaisDataOnDemand PaisIntegrationTest.dod;
    
    @Test
    public void PaisIntegrationTest.testCountPaises() {
        org.junit.Assert.assertNotNull("Data on demand for 'Pais' failed to initialize correctly", dod.getRandomPais());
        long count = br.unicamp.mc536.t2010s2a.forum.domain.Pais.countPaises();
        org.junit.Assert.assertTrue("Counter for 'Pais' incorrectly reported there were no entries", count > 0);
    }
    
    @Test
    public void PaisIntegrationTest.testFindPais() {
        br.unicamp.mc536.t2010s2a.forum.domain.Pais obj = dod.getRandomPais();
        org.junit.Assert.assertNotNull("Data on demand for 'Pais' failed to initialize correctly", obj);
        java.lang.Long id = obj.getId();
        org.junit.Assert.assertNotNull("Data on demand for 'Pais' failed to provide an identifier", id);
        obj = br.unicamp.mc536.t2010s2a.forum.domain.Pais.findPais(id);
        org.junit.Assert.assertNotNull("Find method for 'Pais' illegally returned null for id '" + id + "'", obj);
        org.junit.Assert.assertEquals("Find method for 'Pais' returned the incorrect identifier", id, obj.getId());
    }
    
    @Test
    public void PaisIntegrationTest.testFindAllPaises() {
        org.junit.Assert.assertNotNull("Data on demand for 'Pais' failed to initialize correctly", dod.getRandomPais());
        long count = br.unicamp.mc536.t2010s2a.forum.domain.Pais.countPaises();
        org.junit.Assert.assertTrue("Too expensive to perform a find all test for 'Pais', as there are " + count + " entries; set the findAllMaximum to exceed this value or set findAll=false on the integration test annotation to disable the test", count < 250);
        java.util.List<br.unicamp.mc536.t2010s2a.forum.domain.Pais> result = br.unicamp.mc536.t2010s2a.forum.domain.Pais.findAllPaises();
        org.junit.Assert.assertNotNull("Find all method for 'Pais' illegally returned null", result);
        org.junit.Assert.assertTrue("Find all method for 'Pais' failed to return any data", result.size() > 0);
    }
    
    @Test
    public void PaisIntegrationTest.testFindPaisEntries() {
        org.junit.Assert.assertNotNull("Data on demand for 'Pais' failed to initialize correctly", dod.getRandomPais());
        long count = br.unicamp.mc536.t2010s2a.forum.domain.Pais.countPaises();
        if (count > 20) count = 20;
        java.util.List<br.unicamp.mc536.t2010s2a.forum.domain.Pais> result = br.unicamp.mc536.t2010s2a.forum.domain.Pais.findPaisEntries(0, (int) count);
        org.junit.Assert.assertNotNull("Find entries method for 'Pais' illegally returned null", result);
        org.junit.Assert.assertEquals("Find entries method for 'Pais' returned an incorrect number of entries", count, result.size());
    }
    
    @Test
    @Transactional
    public void PaisIntegrationTest.testFlush() {
        br.unicamp.mc536.t2010s2a.forum.domain.Pais obj = dod.getRandomPais();
        org.junit.Assert.assertNotNull("Data on demand for 'Pais' failed to initialize correctly", obj);
        java.lang.Long id = obj.getId();
        org.junit.Assert.assertNotNull("Data on demand for 'Pais' failed to provide an identifier", id);
        obj = br.unicamp.mc536.t2010s2a.forum.domain.Pais.findPais(id);
        org.junit.Assert.assertNotNull("Find method for 'Pais' illegally returned null for id '" + id + "'", obj);
        boolean modified =  dod.modifyPais(obj);
        java.lang.Integer currentVersion = obj.getVersion();
        obj.flush();
        org.junit.Assert.assertTrue("Version for 'Pais' failed to increment on flush directive", obj.getVersion() > currentVersion || !modified);
    }
    
    @Test
    @Transactional
    public void PaisIntegrationTest.testMerge() {
        br.unicamp.mc536.t2010s2a.forum.domain.Pais obj = dod.getRandomPais();
        org.junit.Assert.assertNotNull("Data on demand for 'Pais' failed to initialize correctly", obj);
        java.lang.Long id = obj.getId();
        org.junit.Assert.assertNotNull("Data on demand for 'Pais' failed to provide an identifier", id);
        obj = br.unicamp.mc536.t2010s2a.forum.domain.Pais.findPais(id);
        boolean modified =  dod.modifyPais(obj);
        java.lang.Integer currentVersion = obj.getVersion();
        obj.merge();
        obj.flush();
        org.junit.Assert.assertTrue("Version for 'Pais' failed to increment on merge and flush directive", obj.getVersion() > currentVersion || !modified);
    }
    
    @Test
    @Transactional
    public void PaisIntegrationTest.testPersist() {
        org.junit.Assert.assertNotNull("Data on demand for 'Pais' failed to initialize correctly", dod.getRandomPais());
        br.unicamp.mc536.t2010s2a.forum.domain.Pais obj = dod.getNewTransientPais(Integer.MAX_VALUE);
        org.junit.Assert.assertNotNull("Data on demand for 'Pais' failed to provide a new transient entity", obj);
        org.junit.Assert.assertNull("Expected 'Pais' identifier to be null", obj.getId());
        obj.persist();
        obj.flush();
        org.junit.Assert.assertNotNull("Expected 'Pais' identifier to no longer be null", obj.getId());
    }
    
    @Test
    @Transactional
    public void PaisIntegrationTest.testRemove() {
        br.unicamp.mc536.t2010s2a.forum.domain.Pais obj = dod.getRandomPais();
        org.junit.Assert.assertNotNull("Data on demand for 'Pais' failed to initialize correctly", obj);
        java.lang.Long id = obj.getId();
        org.junit.Assert.assertNotNull("Data on demand for 'Pais' failed to provide an identifier", id);
        obj = br.unicamp.mc536.t2010s2a.forum.domain.Pais.findPais(id);
        obj.remove();
        obj.flush();
        org.junit.Assert.assertNull("Failed to remove 'Pais' with identifier '" + id + "'", br.unicamp.mc536.t2010s2a.forum.domain.Pais.findPais(id));
    }
    
}