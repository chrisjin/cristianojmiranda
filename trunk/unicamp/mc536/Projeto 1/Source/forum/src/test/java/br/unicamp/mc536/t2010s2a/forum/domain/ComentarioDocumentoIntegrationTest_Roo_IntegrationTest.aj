// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package br.unicamp.mc536.t2010s2a.forum.domain;

import br.unicamp.mc536.t2010s2a.forum.domain.ComentarioDocumentoDataOnDemand;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.transaction.annotation.Transactional;

privileged aspect ComentarioDocumentoIntegrationTest_Roo_IntegrationTest {
    
    declare @type: ComentarioDocumentoIntegrationTest: @RunWith(SpringJUnit4ClassRunner.class);
    
    declare @type: ComentarioDocumentoIntegrationTest: @ContextConfiguration(locations = "classpath:/META-INF/spring/applicationContext.xml");
    
    @Autowired
    private ComentarioDocumentoDataOnDemand ComentarioDocumentoIntegrationTest.dod;
    
    @Test
    public void ComentarioDocumentoIntegrationTest.testCountComentarioDocumentoes() {
        org.junit.Assert.assertNotNull("Data on demand for 'ComentarioDocumento' failed to initialize correctly", dod.getRandomComentarioDocumento());
        long count = br.unicamp.mc536.t2010s2a.forum.domain.ComentarioDocumento.countComentarioDocumentoes();
        org.junit.Assert.assertTrue("Counter for 'ComentarioDocumento' incorrectly reported there were no entries", count > 0);
    }
    
    @Test
    public void ComentarioDocumentoIntegrationTest.testFindComentarioDocumento() {
        br.unicamp.mc536.t2010s2a.forum.domain.ComentarioDocumento obj = dod.getRandomComentarioDocumento();
        org.junit.Assert.assertNotNull("Data on demand for 'ComentarioDocumento' failed to initialize correctly", obj);
        java.lang.Long id = obj.getId();
        org.junit.Assert.assertNotNull("Data on demand for 'ComentarioDocumento' failed to provide an identifier", id);
        obj = br.unicamp.mc536.t2010s2a.forum.domain.ComentarioDocumento.findComentarioDocumento(id);
        org.junit.Assert.assertNotNull("Find method for 'ComentarioDocumento' illegally returned null for id '" + id + "'", obj);
        org.junit.Assert.assertEquals("Find method for 'ComentarioDocumento' returned the incorrect identifier", id, obj.getId());
    }
    
    @Test
    public void ComentarioDocumentoIntegrationTest.testFindAllComentarioDocumentoes() {
        org.junit.Assert.assertNotNull("Data on demand for 'ComentarioDocumento' failed to initialize correctly", dod.getRandomComentarioDocumento());
        long count = br.unicamp.mc536.t2010s2a.forum.domain.ComentarioDocumento.countComentarioDocumentoes();
        org.junit.Assert.assertTrue("Too expensive to perform a find all test for 'ComentarioDocumento', as there are " + count + " entries; set the findAllMaximum to exceed this value or set findAll=false on the integration test annotation to disable the test", count < 250);
        java.util.List<br.unicamp.mc536.t2010s2a.forum.domain.ComentarioDocumento> result = br.unicamp.mc536.t2010s2a.forum.domain.ComentarioDocumento.findAllComentarioDocumentoes();
        org.junit.Assert.assertNotNull("Find all method for 'ComentarioDocumento' illegally returned null", result);
        org.junit.Assert.assertTrue("Find all method for 'ComentarioDocumento' failed to return any data", result.size() > 0);
    }
    
    @Test
    public void ComentarioDocumentoIntegrationTest.testFindComentarioDocumentoEntries() {
        org.junit.Assert.assertNotNull("Data on demand for 'ComentarioDocumento' failed to initialize correctly", dod.getRandomComentarioDocumento());
        long count = br.unicamp.mc536.t2010s2a.forum.domain.ComentarioDocumento.countComentarioDocumentoes();
        if (count > 20) count = 20;
        java.util.List<br.unicamp.mc536.t2010s2a.forum.domain.ComentarioDocumento> result = br.unicamp.mc536.t2010s2a.forum.domain.ComentarioDocumento.findComentarioDocumentoEntries(0, (int) count);
        org.junit.Assert.assertNotNull("Find entries method for 'ComentarioDocumento' illegally returned null", result);
        org.junit.Assert.assertEquals("Find entries method for 'ComentarioDocumento' returned an incorrect number of entries", count, result.size());
    }
    
    @Test
    @Transactional
    public void ComentarioDocumentoIntegrationTest.testFlush() {
        br.unicamp.mc536.t2010s2a.forum.domain.ComentarioDocumento obj = dod.getRandomComentarioDocumento();
        org.junit.Assert.assertNotNull("Data on demand for 'ComentarioDocumento' failed to initialize correctly", obj);
        java.lang.Long id = obj.getId();
        org.junit.Assert.assertNotNull("Data on demand for 'ComentarioDocumento' failed to provide an identifier", id);
        obj = br.unicamp.mc536.t2010s2a.forum.domain.ComentarioDocumento.findComentarioDocumento(id);
        org.junit.Assert.assertNotNull("Find method for 'ComentarioDocumento' illegally returned null for id '" + id + "'", obj);
        boolean modified =  dod.modifyComentarioDocumento(obj);
        java.lang.Integer currentVersion = obj.getVersion();
        obj.flush();
        org.junit.Assert.assertTrue("Version for 'ComentarioDocumento' failed to increment on flush directive", obj.getVersion() > currentVersion || !modified);
    }
    
    @Test
    @Transactional
    public void ComentarioDocumentoIntegrationTest.testMerge() {
        br.unicamp.mc536.t2010s2a.forum.domain.ComentarioDocumento obj = dod.getRandomComentarioDocumento();
        org.junit.Assert.assertNotNull("Data on demand for 'ComentarioDocumento' failed to initialize correctly", obj);
        java.lang.Long id = obj.getId();
        org.junit.Assert.assertNotNull("Data on demand for 'ComentarioDocumento' failed to provide an identifier", id);
        obj = br.unicamp.mc536.t2010s2a.forum.domain.ComentarioDocumento.findComentarioDocumento(id);
        boolean modified =  dod.modifyComentarioDocumento(obj);
        java.lang.Integer currentVersion = obj.getVersion();
        obj.merge();
        obj.flush();
        org.junit.Assert.assertTrue("Version for 'ComentarioDocumento' failed to increment on merge and flush directive", obj.getVersion() > currentVersion || !modified);
    }
    
    @Test
    @Transactional
    public void ComentarioDocumentoIntegrationTest.testPersist() {
        org.junit.Assert.assertNotNull("Data on demand for 'ComentarioDocumento' failed to initialize correctly", dod.getRandomComentarioDocumento());
        br.unicamp.mc536.t2010s2a.forum.domain.ComentarioDocumento obj = dod.getNewTransientComentarioDocumento(Integer.MAX_VALUE);
        org.junit.Assert.assertNotNull("Data on demand for 'ComentarioDocumento' failed to provide a new transient entity", obj);
        org.junit.Assert.assertNull("Expected 'ComentarioDocumento' identifier to be null", obj.getId());
        obj.persist();
        obj.flush();
        org.junit.Assert.assertNotNull("Expected 'ComentarioDocumento' identifier to no longer be null", obj.getId());
    }
    
    @Test
    @Transactional
    public void ComentarioDocumentoIntegrationTest.testRemove() {
        br.unicamp.mc536.t2010s2a.forum.domain.ComentarioDocumento obj = dod.getRandomComentarioDocumento();
        org.junit.Assert.assertNotNull("Data on demand for 'ComentarioDocumento' failed to initialize correctly", obj);
        java.lang.Long id = obj.getId();
        org.junit.Assert.assertNotNull("Data on demand for 'ComentarioDocumento' failed to provide an identifier", id);
        obj = br.unicamp.mc536.t2010s2a.forum.domain.ComentarioDocumento.findComentarioDocumento(id);
        obj.remove();
        obj.flush();
        org.junit.Assert.assertNull("Failed to remove 'ComentarioDocumento' with identifier '" + id + "'", br.unicamp.mc536.t2010s2a.forum.domain.ComentarioDocumento.findComentarioDocumento(id));
    }
    
}