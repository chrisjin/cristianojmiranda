// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package br.unicamp.mc536.t2010s2a.forum.domain;

import br.unicamp.mc536.t2010s2a.forum.domain.RedeTrabalhoUsuario;
import flexjson.JSONDeserializer;
import flexjson.JSONSerializer;
import java.lang.String;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

privileged aspect RedeTrabalhoUsuario_Roo_Json {
    
    public String RedeTrabalhoUsuario.toJson() {
        return new JSONSerializer().exclude("*.class").serialize(this);
    }
    
    public static RedeTrabalhoUsuario RedeTrabalhoUsuario.fromJsonToRedeTrabalhoUsuario(String json) {
        return new JSONDeserializer<RedeTrabalhoUsuario>().use(null, RedeTrabalhoUsuario.class).deserialize(json);
    }
    
    public static String RedeTrabalhoUsuario.toJsonArray(Collection<RedeTrabalhoUsuario> collection) {
        return new JSONSerializer().exclude("*.class").serialize(collection);
    }
    
    public static Collection<RedeTrabalhoUsuario> RedeTrabalhoUsuario.fromJsonArrayToRedeTrabalhoUsuarios(String json) {
        return new JSONDeserializer<List<RedeTrabalhoUsuario>>().use(null, ArrayList.class).use("values", RedeTrabalhoUsuario.class).deserialize(json);
    }
    
}