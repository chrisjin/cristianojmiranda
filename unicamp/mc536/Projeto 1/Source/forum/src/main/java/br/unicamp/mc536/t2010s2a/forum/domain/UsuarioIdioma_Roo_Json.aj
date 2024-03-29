// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package br.unicamp.mc536.t2010s2a.forum.domain;

import br.unicamp.mc536.t2010s2a.forum.domain.UsuarioIdioma;
import flexjson.JSONDeserializer;
import flexjson.JSONSerializer;
import java.lang.String;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

privileged aspect UsuarioIdioma_Roo_Json {
    
    public String UsuarioIdioma.toJson() {
        return new JSONSerializer().exclude("*.class").serialize(this);
    }
    
    public static UsuarioIdioma UsuarioIdioma.fromJsonToUsuarioIdioma(String json) {
        return new JSONDeserializer<UsuarioIdioma>().use(null, UsuarioIdioma.class).deserialize(json);
    }
    
    public static String UsuarioIdioma.toJsonArray(Collection<UsuarioIdioma> collection) {
        return new JSONSerializer().exclude("*.class").serialize(collection);
    }
    
    public static Collection<UsuarioIdioma> UsuarioIdioma.fromJsonArrayToUsuarioIdiomas(String json) {
        return new JSONDeserializer<List<UsuarioIdioma>>().use(null, ArrayList.class).use("values", UsuarioIdioma.class).deserialize(json);
    }
    
}
