// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package br.unicamp.mc536.t2010s2a.forum.domain;

import br.unicamp.mc536.t2010s2a.forum.domain.DocumentoReferenciaPais;
import flexjson.JSONDeserializer;
import flexjson.JSONSerializer;
import java.lang.String;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

privileged aspect DocumentoReferenciaPais_Roo_Json {
    
    public String DocumentoReferenciaPais.toJson() {
        return new JSONSerializer().exclude("*.class").serialize(this);
    }
    
    public static DocumentoReferenciaPais DocumentoReferenciaPais.fromJsonToDocumentoReferenciaPais(String json) {
        return new JSONDeserializer<DocumentoReferenciaPais>().use(null, DocumentoReferenciaPais.class).deserialize(json);
    }
    
    public static String DocumentoReferenciaPais.toJsonArray(Collection<DocumentoReferenciaPais> collection) {
        return new JSONSerializer().exclude("*.class").serialize(collection);
    }
    
    public static Collection<DocumentoReferenciaPais> DocumentoReferenciaPais.fromJsonArrayToDocumentoReferenciaPaises(String json) {
        return new JSONDeserializer<List<DocumentoReferenciaPais>>().use(null, ArrayList.class).use("values", DocumentoReferenciaPais.class).deserialize(json);
    }
    
}
