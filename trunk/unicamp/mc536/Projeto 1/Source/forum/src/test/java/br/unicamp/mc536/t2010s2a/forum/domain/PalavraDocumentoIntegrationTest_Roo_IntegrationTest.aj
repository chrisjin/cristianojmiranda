// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package br.unicamp.mc536.t2010s2a.forum.domain;

import br.unicamp.mc536.t2010s2a.forum.domain.PalavraDocumentoDataOnDemand;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.transaction.annotation.Transactional;

privileged aspect PalavraDocumentoIntegrationTest_Roo_IntegrationTest {
    
    declare @type: PalavraDocumentoIntegrationTest: @RunWith(SpringJUnit4ClassRunner.class);
    
    declare @type: PalavraDocumentoIntegrationTest: @ContextConfiguration(locations = "classpath:/META-INF/spring/applicationContext.xml");
    
    @Autowired
    private PalavraDocumentoDataOnDemand PalavraDocumentoIntegrationTest.dod;
    
    @Test
    public void PalavraDocumentoIntegrationTest.testCountPalavraDocumentoes() {
        org.junit.Assert.assertNotNull("Data on demand for 'PalavraDocumento' failed to initialize correctly", dod.getRandomPalavraDocumento());
        long count = br.unicamp.mc536.t2010s2a.forum.domain.PalavraDocumento.countPalavraDocumentoes();
        org.junit.Assert.assertTrue("Counter for 'PalavraDocumento' incorrectly reported there were no entries", count > 0);
    }
    
    @Test
    public void PalavraDocumentoIntegrationTest.testFindPalavraDocumento() {
        br.unicamp.mc536.t2010s2a.forum.domain.PalavraDocumento obj = dod.getRandomPalavraDocumento();
        org.junit.Assert.assertNotNull("Data on demand for 'PalavraDocumento' failed to initialize correctly", obj);
        java.lang.Long id = obj.getId();
        org.junit.Assert.assertNotNull("Data on demand for 'PalavraDocumento' failed to provide an identifier", id);
        obj = br.unicamp.mc536.t2010s2a.forum.domain.PalavraDocumento.findPalavraDocumento(id);
        org.junit.Assert.assertNotNull("Find method for 'PalavraDocumento' illegally returned null for id '" + id + "'", obj);
        org.junit.Assert.assertEquals("Find method for 'PalavraDocumento' returned the incorrect identifier", id, obj.getId());
    }
    
    @Test
    public void PalavraDocumentoIntegrationTest.testFindAllPalavraDocumentoes() {
        org.junit.Assert.assertNotNull("Data on demand for 'PalavraDocumento' failed to initialize correctly", dod.getRandomPalavraDocumento());
        long count = br.unicamp.mc536.t2010s2a.forum.domain.PalavraDocumento.countPalavraDocumentoes();
        org.junit.Assert.assertTrue("Too expensive to perform a find all test for 'PalavraDocumento', as there are " + count + " entries; set the findAllMaximum to exceed this value or set findAll=false on the integration test annotation to disable the test", count < 250);
        java.util.List<br.unicamp.mc536.t2010s2a.forum.domain.PalavraDocumento> result = br.unicamp.mc536.t2010s2a.forum.domain.PalavraDocumento.findAllPalavraDocumentoes();
        org.junit.Assert.assertNotNull("Find all method for 'PalavraDocumento' illegally returned null", result);
        org.junit.Assert.assertTrue("Find all method for 'PalavraDocumento' failed to return any data", result.size() > 0);
    }
    
    @Test
    public void PalavraDocumentoIntegrationTest.testFindPalavraDocumentoEntries() {
        org.junit.Assert.assertNotNull("Data on demand for 'PalavraDocumento' failed to initialize correctly", dod.getRandomPalavraDocumento());
        long count = br.unicamp.mc536.t2010s2a.forum.domain.PalavraDocumento.countPalavraDocumentoes();
        if (count > 20) count = 20;
        java.util.List<br.unicamp.mc536.t2010s2a.forum.domain.PalavraDocumento> result = br.unicamp.mc536.t2010s2a.forum.domain.PalavraDocumento.findPalavraDocumentoEntries(0, (int) count);
        org.junit.Assert.assertNotNull("Find entries method for 'PalavraDocumento' illegally returned null", result);
        org.junit.Assert.assertEquals("Find entries method for 'PalavraDocumento' returned an incorrect number of entries", count, result.size());
    }
    
    @Test
    @Transactional
    public void PalavraDocumentoIntegrationTest.testFlush() {
        br.unicamp.mc536.t2010s2a.forum.domain.PalavraDocumento obj = dod.getRandomPalavraDocumento();
        org.junit.Assert.assertNotNull("Data on demand for 'PalavraDocumento' failed to initialize correctly", obj);
        java.lang.Long id = obj.getId();
        org.junit.Assert.assertNotNull("Data on demand for 'PalavraDocumento' failed to provide an identifier", id);
        obj = br.unicamp.mc536.t2010s2a.forum.domain.PalavraDocumento.findPalavraDocumento(id);
        org.junit.Assert.assertNotNull("Find method for 'PalavraDocumento' illegally returned null for id '" + id + "'", obj);
        boolean modified =  dod.modifyPalavraDocumento(obj);
        java.lang.Integer currentVersion = obj.getVersion();
        obj.flush();
        org.junit.Assert.assertTrue("Version for 'PalavraDocumento' failed to increment on flush directive", obj.getVersion() > currentVersion || !modified);
    }
    
    @Test
    @Transactional
    public void PalavraDocumentoIntegrationTest.testMerge() {
        br.unicamp.mc536.t2010s2a.forum.domain.PalavraDocumento obj = dod.getRandomPalavraDocumento();
        org.junit.Assert.assertNotNull("Data on demand for 'PalavraDocumento' failed to initialize correctly", obj);
        java.lang.Long id = obj.getId();
        org.junit.Assert.assertNotNull("Data on demand for 'PalavraDocumento' failed to provide an identifier", id);
        obj = br.unicamp.mc536.t2010s2a.forum.domain.PalavraDocumento.findPalavraDocumento(id);
        boolean modified =  dod.modifyPalavraDocumento(obj);
        java.lang.Integer currentVersion = obj.getVersion();
        obj.merge();
        obj.flush();
        org.junit.Assert.assertTrue("Version for 'PalavraDocumento' failed to increment on merge and flush directive", obj.getVersion() > currentVersion || !modified);
    }
    
    @Test
    @Transactional
    public void PalavraDocumentoIntegrationTest.testPersist() {
        org.junit.Assert.assertNotNull("Data on demand for 'PalavraDocumento' failed to initialize correctly", dod.getRandomPalavraDocumento());
        br.unicamp.mc536.t2010s2a.forum.domain.PalavraDocumento obj = dod.getNewTransientPalavraDocumento(Integer.MAX_VALUE);
        org.junit.Assert.assertNotNull("Data on demand for 'PalavraDocumento' failed to provide a new transient entity", obj);
        org.junit.Assert.assertNull("Expected 'PalavraDocumento' identifier to be null", obj.getId());
        obj.persist();
        obj.flush();
        org.junit.Assert.assertNotNull("Expected 'PalavraDocumento' identifier to no longer be null", obj.getId());
    }
    
    @Test
    @Transactional
    public void PalavraDocumentoIntegrationTest.testRemove() {
        br.unicamp.mc536.t2010s2a.forum.domain.PalavraDocumento obj = dod.getRandomPalavraDocumento();
        org.junit.Assert.assertNotNull("Data on demand for 'PalavraDocumento' failed to initialize correctly", obj);
        java.lang.Long id = obj.getId();
        org.junit.Assert.assertNotNull("Data on demand for 'PalavraDocumento' failed to provide an identifier", id);
        obj = br.unicamp.mc536.t2010s2a.forum.domain.PalavraDocumento.findPalavraDocumento(id);
        obj.remove();
        obj.flush();
        org.junit.Assert.assertNull("Failed to remove 'PalavraDocumento' with identifier '" + id + "'", br.unicamp.mc536.t2010s2a.forum.domain.PalavraDocumento.findPalavraDocumento(id));
    }
    
}