// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package br.unicamp.mc536.t2010s2a.forum.domain;

import java.lang.String;

privileged aspect RedeTrabalho_Roo_ToString {

	public String RedeTrabalho.toString() {
		StringBuilder sb = new StringBuilder();
		sb.append(getNmRedetrabalho());
		return sb.toString();
	}
}
