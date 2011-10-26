package osp.Resources;

import osp.IFLModules.IflRRB;
import osp.Threads.ThreadCB;

/**
 * The studends module for dealing with resource management. The methods that
 * have to be implemented are do_grant().
 * 
 * @OSPProject Resources
 * @author Cristiano J. Miranda (ra: 083382)
 */
public class RRB extends IflRRB {
	/**
	 * constructor of class RRB Creates a new RRB object. This constructor must
	 * have super() as its first statement.
	 * 
	 * @OSPProject Resources
	 */
	public RRB(ThreadCB thread, ResourceCB resource, int quantity) {

		super(thread, resource, quantity);
		System.out.println("Executando construtor RRB()");

	}

	/**
	 * This method is called when we decide to grant an RRB. The method must
	 * update the various resource quantities and notify the thread waiting on
	 * the granted RRB.
	 * 
	 * @OSPProject Resources
	 */
	public void do_grant() {

		long timer = System.currentTimeMillis();
		System.out.println("Inciando do_grant().");

		System.out.println("Obtendo o resource atual.");
		ResourceCB resourceAtual = getResource();

		System.out.println("Obtendo a thread atual.");
		ThreadCB threadAtual = getThread();

		System.out.println("Calculando quantidade...");
		int qtd = (resourceAtual.getAvailable()) - (getQuantity());

		System.out.println("Calculando alocação...");
		int qtdAlocado = (resourceAtual.getAllocated(threadAtual))
				+ (getQuantity());

		System.out.println("Setando quantidade...");
		resourceAtual.setAvailable(qtd);

		System.out.println("Setando alocação...");
		resourceAtual.setAllocated(threadAtual, qtdAlocado);

		System.out.println("Realizando grant...");
		setStatus(Granted);

		System.out.println("Notificando threads...");
		notifyThreads();

		System.out.println("Finalizando do_grant(). Tempo: "
				+ (System.currentTimeMillis() - timer));

	}

}
