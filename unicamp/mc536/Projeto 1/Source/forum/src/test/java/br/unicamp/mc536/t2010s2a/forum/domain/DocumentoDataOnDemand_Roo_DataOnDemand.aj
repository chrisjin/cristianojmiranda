// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package br.unicamp.mc536.t2010s2a.forum.domain;

import br.unicamp.mc536.t2010s2a.forum.domain.Documento;
import br.unicamp.mc536.t2010s2a.forum.domain.IdiomaDataOnDemand;
import br.unicamp.mc536.t2010s2a.forum.domain.PaisDataOnDemand;
import br.unicamp.mc536.t2010s2a.forum.domain.TipoDocumentoDataOnDemand;
import java.util.List;
import java.util.Random;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

privileged aspect DocumentoDataOnDemand_Roo_DataOnDemand {
    
    declare @type: DocumentoDataOnDemand: @Component;
    
    private Random DocumentoDataOnDemand.rnd = new java.security.SecureRandom();
    
    private List<Documento> DocumentoDataOnDemand.data;
    
    @Autowired
    private IdiomaDataOnDemand DocumentoDataOnDemand.idiomaDataOnDemand;
    
    @Autowired
    private PaisDataOnDemand DocumentoDataOnDemand.paisDataOnDemand;
    
    @Autowired
    private TipoDocumentoDataOnDemand DocumentoDataOnDemand.tipoDocumentoDataOnDemand;
    
    public Documento DocumentoDataOnDemand.getNewTransientDocumento(int index) {
        br.unicamp.mc536.t2010s2a.forum.domain.Documento obj = new br.unicamp.mc536.t2010s2a.forum.domain.Documento();
        java.lang.String dsDocumento = "dsDocumento_" + index;
        if (dsDocumento.length() > 2000) {
            dsDocumento  = dsDocumento.substring(0, 2000);
        }
        obj.setDsDocumento(dsDocumento);
        obj.setDsEmailAutor("dsEmailAutor_" + index);
        obj.setDsInfoMaquina("dsInfoMaquina_" + index);
        obj.setDtCriacao(new java.util.Date());
        obj.setDtInclusao(new java.util.Date());
        obj.setIdIdiomaDocumento(idiomaDataOnDemand.getRandomIdioma());
        obj.setIdPais(paisDataOnDemand.getRandomPais());
        obj.setIdPrograma(null);
        obj.setIdRedeTrabalho(null);
        obj.setIdUsuarioAutor(null);
        obj.setIdUsuarioResponsavel(null);
        java.lang.String nmArquivo = "nmArquivo_" + index;
        if (nmArquivo.length() > 255) {
            nmArquivo  = nmArquivo.substring(0, 255);
        }
        obj.setNmArquivo(nmArquivo);
        obj.setNmAutor("nmAutor_" + index);
        java.lang.String nmDocumento = "nmDocumento_" + index;
        if (nmDocumento.length() > 255) {
            nmDocumento  = nmDocumento.substring(0, 255);
        }
        obj.setNmDocumento(nmDocumento);
        obj.setQtdVisualizacao(new Integer(index).longValue());
        obj.setTipoDocumento(tipoDocumentoDataOnDemand.getRandomTipoDocumento());
        return obj;
    }
    
    public Documento DocumentoDataOnDemand.getSpecificDocumento(int index) {
        init();
        if (index < 0) index = 0;
        if (index > (data.size() - 1)) index = data.size() - 1;
        Documento obj = data.get(index);
        return Documento.findDocumento(obj.getId());
    }
    
    public Documento DocumentoDataOnDemand.getRandomDocumento() {
        init();
        Documento obj = data.get(rnd.nextInt(data.size()));
        return Documento.findDocumento(obj.getId());
    }
    
    public boolean DocumentoDataOnDemand.modifyDocumento(Documento obj) {
        return false;
    }
    
    @Transactional(propagation = Propagation.REQUIRES_NEW)
    public void DocumentoDataOnDemand.init() {
        if (data != null && !data.isEmpty()) {
            return;
        }
        
        data = br.unicamp.mc536.t2010s2a.forum.domain.Documento.findDocumentoEntries(0, 10);
        if (data == null) throw new IllegalStateException("Find entries implementation for 'Documento' illegally returned null");
        if (!data.isEmpty()) {
            return;
        }
        
        data = new java.util.ArrayList<br.unicamp.mc536.t2010s2a.forum.domain.Documento>();
        for (int i = 0; i < 10; i++) {
            br.unicamp.mc536.t2010s2a.forum.domain.Documento obj = getNewTransientDocumento(i);
            obj.persist();
            data.add(obj);
        }
    }
    
}