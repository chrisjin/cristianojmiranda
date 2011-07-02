// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package br.unicamp.mc536.t2010s2a.forum.domain;

import br.unicamp.mc536.t2010s2a.forum.domain.UsuarioDocumento;
import flexjson.JSONDeserializer;
import flexjson.JSONSerializer;
import java.lang.String;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

privileged aspect UsuarioDocumento_Roo_Json {
    
    public String UsuarioDocumento.toJson() {
        return new JSONSerializer().exclude("*.class").serialize(this);
    }
    
    public static UsuarioDocumento UsuarioDocumento.fromJsonToUsuarioDocumento(String json) {
        return new JSONDeserializer<UsuarioDocumento>().use(null, UsuarioDocumento.class).deserialize(json);
    }
    
    public static String UsuarioDocumento.toJsonArray(Collection<UsuarioDocumento> collection) {
        return new JSONSerializer().exclude("*.class").serialize(collection);
    }
    
    public static Collection<UsuarioDocumento> UsuarioDocumento.fromJsonArrayToUsuarioDocumentoes(String json) {
        return new JSONDeserializer<List<UsuarioDocumento>>().use(null, ArrayList.class).use("values", UsuarioDocumento.class).deserialize(json);
    }
    
}