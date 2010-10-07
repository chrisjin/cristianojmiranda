// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package br.unicamp.mc536.t2010s2a.forum.domain;

import br.unicamp.mc536.t2010s2a.forum.domain.ProgramaUsuario;
import flexjson.JSONDeserializer;
import flexjson.JSONSerializer;
import java.lang.String;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

privileged aspect ProgramaUsuario_Roo_Json {
    
    public String ProgramaUsuario.toJson() {
        return new JSONSerializer().exclude("*.class").serialize(this);
    }
    
    public static ProgramaUsuario ProgramaUsuario.fromJsonToProgramaUsuario(String json) {
        return new JSONDeserializer<ProgramaUsuario>().use(null, ProgramaUsuario.class).deserialize(json);
    }
    
    public static String ProgramaUsuario.toJsonArray(Collection<ProgramaUsuario> collection) {
        return new JSONSerializer().exclude("*.class").serialize(collection);
    }
    
    public static Collection<ProgramaUsuario> ProgramaUsuario.fromJsonArrayToProgramaUsuarios(String json) {
        return new JSONDeserializer<List<ProgramaUsuario>>().use(null, ArrayList.class).use("values", ProgramaUsuario.class).deserialize(json);
    }
    
}
