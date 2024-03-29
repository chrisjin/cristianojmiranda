// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package br.unicamp.mc536.t2010s2a.forum.domain;

import br.unicamp.mc536.t2010s2a.forum.domain.RedeTrabalho;
import br.unicamp.mc536.t2010s2a.forum.domain.UsuarioDataOnDemand;
import java.util.List;
import java.util.Random;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

privileged aspect RedeTrabalhoDataOnDemand_Roo_DataOnDemand {
    
    declare @type: RedeTrabalhoDataOnDemand: @Component;
    
    private Random RedeTrabalhoDataOnDemand.rnd = new java.security.SecureRandom();
    
    private List<RedeTrabalho> RedeTrabalhoDataOnDemand.data;
    
    @Autowired
    private UsuarioDataOnDemand RedeTrabalhoDataOnDemand.usuarioDataOnDemand;
    
    public RedeTrabalho RedeTrabalhoDataOnDemand.getNewTransientRedeTrabalho(int index) {
        br.unicamp.mc536.t2010s2a.forum.domain.RedeTrabalho obj = new br.unicamp.mc536.t2010s2a.forum.domain.RedeTrabalho();
        obj.setDsDetalhadoRedetrabalho("dsDetalhadoRedetrabalho_" + index);
        java.lang.String dsRedetrabalho = "dsRedetrabalho_" + index;
        if (dsRedetrabalho.length() > 255) {
            dsRedetrabalho  = dsRedetrabalho.substring(0, 255);
        }
        obj.setDsRedetrabalho(dsRedetrabalho);
        obj.setDtInclusao(new java.util.Date());
        obj.setIdUsuario(usuarioDataOnDemand.getRandomUsuario());
        java.lang.String nmRedetrabalho = "nmRedetrabalho_" + index;
        if (nmRedetrabalho.length() > 255) {
            nmRedetrabalho  = nmRedetrabalho.substring(0, 255);
        }
        obj.setNmRedetrabalho(nmRedetrabalho);
        return obj;
    }
    
    public RedeTrabalho RedeTrabalhoDataOnDemand.getSpecificRedeTrabalho(int index) {
        init();
        if (index < 0) index = 0;
        if (index > (data.size() - 1)) index = data.size() - 1;
        RedeTrabalho obj = data.get(index);
        return RedeTrabalho.findRedeTrabalho(obj.getId());
    }
    
    public RedeTrabalho RedeTrabalhoDataOnDemand.getRandomRedeTrabalho() {
        init();
        RedeTrabalho obj = data.get(rnd.nextInt(data.size()));
        return RedeTrabalho.findRedeTrabalho(obj.getId());
    }
    
    public boolean RedeTrabalhoDataOnDemand.modifyRedeTrabalho(RedeTrabalho obj) {
        return false;
    }
    
    @Transactional(propagation = Propagation.REQUIRES_NEW)
    public void RedeTrabalhoDataOnDemand.init() {
        if (data != null && !data.isEmpty()) {
            return;
        }
        
        data = br.unicamp.mc536.t2010s2a.forum.domain.RedeTrabalho.findRedeTrabalhoEntries(0, 10);
        if (data == null) throw new IllegalStateException("Find entries implementation for 'RedeTrabalho' illegally returned null");
        if (!data.isEmpty()) {
            return;
        }
        
        data = new java.util.ArrayList<br.unicamp.mc536.t2010s2a.forum.domain.RedeTrabalho>();
        for (int i = 0; i < 10; i++) {
            br.unicamp.mc536.t2010s2a.forum.domain.RedeTrabalho obj = getNewTransientRedeTrabalho(i);
            obj.persist();
            data.add(obj);
        }
    }
    
}
