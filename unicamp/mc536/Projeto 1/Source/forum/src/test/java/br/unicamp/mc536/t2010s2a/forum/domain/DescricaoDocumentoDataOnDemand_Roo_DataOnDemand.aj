// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package br.unicamp.mc536.t2010s2a.forum.domain;

import br.unicamp.mc536.t2010s2a.forum.domain.DescricaoDocumento;
import br.unicamp.mc536.t2010s2a.forum.domain.DocumentoDataOnDemand;
import br.unicamp.mc536.t2010s2a.forum.domain.IdiomaDataOnDemand;
import java.util.List;
import java.util.Random;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

privileged aspect DescricaoDocumentoDataOnDemand_Roo_DataOnDemand {
    
    declare @type: DescricaoDocumentoDataOnDemand: @Component;
    
    private Random DescricaoDocumentoDataOnDemand.rnd = new java.security.SecureRandom();
    
    private List<DescricaoDocumento> DescricaoDocumentoDataOnDemand.data;
    
    @Autowired
    private DocumentoDataOnDemand DescricaoDocumentoDataOnDemand.documentoDataOnDemand;
    
    @Autowired
    private IdiomaDataOnDemand DescricaoDocumentoDataOnDemand.idiomaDataOnDemand;
    
    public DescricaoDocumento DescricaoDocumentoDataOnDemand.getNewTransientDescricaoDocumento(int index) {
        br.unicamp.mc536.t2010s2a.forum.domain.DescricaoDocumento obj = new br.unicamp.mc536.t2010s2a.forum.domain.DescricaoDocumento();
        obj.setDsDocumento("dsDocumento_" + index);
        obj.setIdDocumento(documentoDataOnDemand.getRandomDocumento());
        obj.setIdIdiomaDocumento(idiomaDataOnDemand.getRandomIdioma());
        return obj;
    }
    
    public DescricaoDocumento DescricaoDocumentoDataOnDemand.getSpecificDescricaoDocumento(int index) {
        init();
        if (index < 0) index = 0;
        if (index > (data.size() - 1)) index = data.size() - 1;
        DescricaoDocumento obj = data.get(index);
        return DescricaoDocumento.findDescricaoDocumento(obj.getId());
    }
    
    public DescricaoDocumento DescricaoDocumentoDataOnDemand.getRandomDescricaoDocumento() {
        init();
        DescricaoDocumento obj = data.get(rnd.nextInt(data.size()));
        return DescricaoDocumento.findDescricaoDocumento(obj.getId());
    }
    
    public boolean DescricaoDocumentoDataOnDemand.modifyDescricaoDocumento(DescricaoDocumento obj) {
        return false;
    }
    
    @Transactional(propagation = Propagation.REQUIRES_NEW)
    public void DescricaoDocumentoDataOnDemand.init() {
        if (data != null && !data.isEmpty()) {
            return;
        }
        
        data = br.unicamp.mc536.t2010s2a.forum.domain.DescricaoDocumento.findDescricaoDocumentoEntries(0, 10);
        if (data == null) throw new IllegalStateException("Find entries implementation for 'DescricaoDocumento' illegally returned null");
        if (!data.isEmpty()) {
            return;
        }
        
        data = new java.util.ArrayList<br.unicamp.mc536.t2010s2a.forum.domain.DescricaoDocumento>();
        for (int i = 0; i < 10; i++) {
            br.unicamp.mc536.t2010s2a.forum.domain.DescricaoDocumento obj = getNewTransientDescricaoDocumento(i);
            obj.persist();
            data.add(obj);
        }
    }
    
}
