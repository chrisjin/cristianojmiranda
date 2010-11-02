// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package br.unicamp.mc536.t2010s2a.forum.domain;

import br.unicamp.mc536.t2010s2a.forum.domain.DescricaoDocumentoDataOnDemand;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.transaction.annotation.Transactional;

privileged aspect DescricaoDocumentoIntegrationTest_Roo_IntegrationTest {
    
    declare @type: DescricaoDocumentoIntegrationTest: @RunWith(SpringJUnit4ClassRunner.class);
    
    declare @type: DescricaoDocumentoIntegrationTest: @ContextConfiguration(locations = "classpath:/META-INF/spring/applicationContext.xml");
    
    @Autowired
    private DescricaoDocumentoDataOnDemand DescricaoDocumentoIntegrationTest.dod;
    
    @Test
    public void DescricaoDocumentoIntegrationTest.testCountDescricaoDocumentoes() {
        org.junit.Assert.assertNotNull("Data on demand for 'DescricaoDocumento' failed to initialize correctly", dod.getRandomDescricaoDocumento());
        long count = br.unicamp.mc536.t2010s2a.forum.domain.DescricaoDocumento.countDescricaoDocumentoes();
        org.junit.Assert.assertTrue("Counter for 'DescricaoDocumento' incorrectly reported there were no entries", count > 0);
    }
    
    @Test
    public void DescricaoDocumentoIntegrationTest.testFindDescricaoDocumento() {
        br.unicamp.mc536.t2010s2a.forum.domain.DescricaoDocumento obj = dod.getRandomDescricaoDocumento();
        org.junit.Assert.assertNotNull("Data on demand for 'DescricaoDocumento' failed to initialize correctly", obj);
        java.lang.Long id = obj.getId();
        org.junit.Assert.assertNotNull("Data on demand for 'DescricaoDocumento' failed to provide an identifier", id);
        obj = br.unicamp.mc536.t2010s2a.forum.domain.DescricaoDocumento.findDescricaoDocumento(id);
        org.junit.Assert.assertNotNull("Find method for 'DescricaoDocumento' illegally returned null for id '" + id + "'", obj);
        org.junit.Assert.assertEquals("Find method for 'DescricaoDocumento' returned the incorrect identifier", id, obj.getId());
    }
    
    @Test
    public void DescricaoDocumentoIntegrationTest.testFindAllDescricaoDocumentoes() {
        org.junit.Assert.assertNotNull("Data on demand for 'DescricaoDocumento' failed to initialize correctly", dod.getRandomDescricaoDocumento());
        long count = br.unicamp.mc536.t2010s2a.forum.domain.DescricaoDocumento.countDescricaoDocumentoes();
        org.junit.Assert.assertTrue("Too expensive to perform a find all test for 'DescricaoDocumento', as there are " + count + " entries; set the findAllMaximum to exceed this value or set findAll=false on the integration test annotation to disable the test", count < 250);
        java.util.List<br.unicamp.mc536.t2010s2a.forum.domain.DescricaoDocumento> result = br.unicamp.mc536.t2010s2a.forum.domain.DescricaoDocumento.findAllDescricaoDocumentoes();
        org.junit.Assert.assertNotNull("Find all method for 'DescricaoDocumento' illegally returned null", result);
        org.junit.Assert.assertTrue("Find all method for 'DescricaoDocumento' failed to return any data", result.size() > 0);
    }
    
    @Test
    public void DescricaoDocumentoIntegrationTest.testFindDescricaoDocumentoEntries() {
        org.junit.Assert.assertNotNull("Data on demand for 'DescricaoDocumento' failed to initialize correctly", dod.getRandomDescricaoDocumento());
        long count = br.unicamp.mc536.t2010s2a.forum.domain.DescricaoDocumento.countDescricaoDocumentoes();
        if (count > 20) count = 20;
        java.util.List<br.unicamp.mc536.t2010s2a.forum.domain.DescricaoDocumento> result = br.unicamp.mc536.t2010s2a.forum.domain.DescricaoDocumento.findDescricaoDocumentoEntries(0, (int) count);
        org.junit.Assert.assertNotNull("Find entries method for 'DescricaoDocumento' illegally returned null", result);
        org.junit.Assert.assertEquals("Find entries method for 'DescricaoDocumento' returned an incorrect number of entries", count, result.size());
    }
    
    @Test
    @Transactional
    public void DescricaoDocumentoIntegrationTest.testFlush() {
        br.unicamp.mc536.t2010s2a.forum.domain.DescricaoDocumento obj = dod.getRandomDescricaoDocumento();
        org.junit.Assert.assertNotNull("Data on demand for 'DescricaoDocumento' failed to initialize correctly", obj);
        java.lang.Long id = obj.getId();
        org.junit.Assert.assertNotNull("Data on demand for 'DescricaoDocumento' failed to provide an identifier", id);
        obj = br.unicamp.mc536.t2010s2a.forum.domain.DescricaoDocumento.findDescricaoDocumento(id);
        org.junit.Assert.assertNotNull("Find method for 'DescricaoDocumento' illegally returned null for id '" + id + "'", obj);
        boolean modified =  dod.modifyDescricaoDocumento(obj);
        java.lang.Integer currentVersion = obj.getVersion();
        obj.flush();
        org.junit.Assert.assertTrue("Version for 'DescricaoDocumento' failed to increment on flush directive", obj.getVersion() > currentVersion || !modified);
    }
    
    @Test
    @Transactional
    public void DescricaoDocumentoIntegrationTest.testMerge() {
        br.unicamp.mc536.t2010s2a.forum.domain.DescricaoDocumento obj = dod.getRandomDescricaoDocumento();
        org.junit.Assert.assertNotNull("Data on demand for 'DescricaoDocumento' failed to initialize correctly", obj);
        java.lang.Long id = obj.getId();
        org.junit.Assert.assertNotNull("Data on demand for 'DescricaoDocumento' failed to provide an identifier", id);
        obj = br.unicamp.mc536.t2010s2a.forum.domain.DescricaoDocumento.findDescricaoDocumento(id);
        boolean modified =  dod.modifyDescricaoDocumento(obj);
        java.lang.Integer currentVersion = obj.getVersion();
        obj.merge();
        obj.flush();
        org.junit.Assert.assertTrue("Version for 'DescricaoDocumento' failed to increment on merge and flush directive", obj.getVersion() > currentVersion || !modified);
    }
    
    @Test
    @Transactional
    public void DescricaoDocumentoIntegrationTest.testPersist() {
        org.junit.Assert.assertNotNull("Data on demand for 'DescricaoDocumento' failed to initialize correctly", dod.getRandomDescricaoDocumento());
        br.unicamp.mc536.t2010s2a.forum.domain.DescricaoDocumento obj = dod.getNewTransientDescricaoDocumento(Integer.MAX_VALUE);
        org.junit.Assert.assertNotNull("Data on demand for 'DescricaoDocumento' failed to provide a new transient entity", obj);
        org.junit.Assert.assertNull("Expected 'DescricaoDocumento' identifier to be null", obj.getId());
        obj.persist();
        obj.flush();
        org.junit.Assert.assertNotNull("Expected 'DescricaoDocumento' identifier to no longer be null", obj.getId());
    }
    
    @Test
    @Transactional
    public void DescricaoDocumentoIntegrationTest.testRemove() {
        br.unicamp.mc536.t2010s2a.forum.domain.DescricaoDocumento obj = dod.getRandomDescricaoDocumento();
        org.junit.Assert.assertNotNull("Data on demand for 'DescricaoDocumento' failed to initialize correctly", obj);
        java.lang.Long id = obj.getId();
        org.junit.Assert.assertNotNull("Data on demand for 'DescricaoDocumento' failed to provide an identifier", id);
        obj = br.unicamp.mc536.t2010s2a.forum.domain.DescricaoDocumento.findDescricaoDocumento(id);
        obj.remove();
        obj.flush();
        org.junit.Assert.assertNull("Failed to remove 'DescricaoDocumento' with identifier '" + id + "'", br.unicamp.mc536.t2010s2a.forum.domain.DescricaoDocumento.findDescricaoDocumento(id));
    }
    
}