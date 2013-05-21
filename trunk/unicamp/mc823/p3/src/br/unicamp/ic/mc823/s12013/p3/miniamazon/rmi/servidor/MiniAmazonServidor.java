package br.unicamp.ic.mc823.s12013.p3.miniamazon.rmi.servidor;

import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;

import br.unicamp.ic.mc823.s12013.p3.miniamazon.rmi.servidor.impl.MiniAmazonLivrariaImpl;

/**
 * @author Cristiano
 * 
 */
public class MiniAmazonServidor {

	/**
	 * @param args
	 */
	public static void main(String... args) {

		/*System.setProperty(
				"java.security.policy",
				"C:/Users/Cristiano/Documents/Unicamp/MC823/projetos/svn/unicamp/mc823/p3/resource/acesso.policy"); */

		try {
			LocateRegistry.createRegistry(1099);
		} catch (Exception e1) {
			e1.printStackTrace();
		}

		if (System.getSecurityManager() == null) {
			System.setSecurityManager(new SecurityManager());
		}

		System.out.println("inicializando o servidor rmi...");

		try {

			Registry registry = LocateRegistry.getRegistry(1099);
			registry.rebind(MiniAmazonLivraria.RMI_SERVER_NAME,
					new MiniAmazonLivrariaImpl());
			System.out.println("MiniAmazon bound");

		} catch (Exception e) {
			System.err.println("ComputeEngine exception:");
			e.printStackTrace();
			System.exit(-1);
		}

	}
}
