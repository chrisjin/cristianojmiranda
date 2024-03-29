// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package br.unicamp.mc536.t2010s2a.forum.domain;

import br.unicamp.mc536.t2010s2a.forum.domain.ComentarioDocumento;
import flexjson.JSONDeserializer;
import flexjson.JSONSerializer;
import java.lang.String;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

privileged aspect ComentarioDocumento_Roo_Json {
    
    public String ComentarioDocumento.toJson() {
        return new JSONSerializer().exclude("*.class").serialize(this);
    }
    
    public static ComentarioDocumento ComentarioDocumento.fromJsonToComentarioDocumento(String json) {
        return new JSONDeserializer<ComentarioDocumento>().use(null, ComentarioDocumento.class).deserialize(json);
    }
    
    public static String ComentarioDocumento.toJsonArray(Collection<ComentarioDocumento> collection) {
        return new JSONSerializer().exclude("*.class").serialize(collection);
    }
    
    public static Collection<ComentarioDocumento> ComentarioDocumento.fromJsonArrayToComentarioDocumentoes(String json) {
        return new JSONDeserializer<List<ComentarioDocumento>>().use(null, ArrayList.class).use("values", ComentarioDocumento.class).deserialize(json);
    }
    
}
