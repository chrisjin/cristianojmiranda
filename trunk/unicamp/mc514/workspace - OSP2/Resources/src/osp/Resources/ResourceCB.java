package osp.Resources;

import java.util.ArrayList;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.List;
import java.util.Vector;

import osp.IFLModules.IflResourceCB;
import osp.Memory.MMU;
import osp.Threads.ThreadCB;

/**
 * Class ResourceCB is the core of the resource management module. Students
 * implement all the do_* methods.
 * 
 * @OSPProject Resources
 * @author Cristiano J. Miranda (ra: 083382)
 */
public class ResourceCB extends IflResourceCB {

	/**
	 * Array com os recursos disponiveis.
	 */
	private static List<Integer> recDisponiveis = new ArrayList<Integer>(
			ResourceTable.getSize());

	/**
	 * Hash com os recursos alocados, indexados por id de processos.
	 */
	private static List<Hashtable<Integer, Integer>> recAlocados = new ArrayList<Hashtable<Integer, Integer>>(
			ResourceTable.getSize());

	/**
	 * Requests.
	 */
	private static List<Hashtable<Integer, Integer>> requisicoes = new ArrayList<Hashtable<Integer, Integer>>(
			ResourceTable.getSize());

	/**
	 * Threads do sistema.
	 */
	private static Hashtable<Integer, ThreadCB> threads = new Hashtable<Integer, ThreadCB>();

	/**
	 * Vetor de recursos.
	 */
	private static Vector<RRB> RRBs = new Vector<RRB>();

	/**
	 * Hash com o status dos recursos.
	 */

	/**
	 * Creates a new ResourceCB instance with the given number of available
	 * instances. This constructor must have super(qty) as its first statement.
	 * 
	 * @OSPProject Resources
	 */
	public ResourceCB(int qty) {
		super(qty);
		recDisponiveis.add(this.getID(), qty);
		System.out.println("\n\nExecutando contrutor ResourceCB().");
	}

	/**
	 * This method is called once, at the beginning of the simulation. Can be
	 * used to initialize static variables.
	 * 
	 * @OSPProject Resources
	 */
	public static void init() {

		System.out.println("\n\nExecutando o metodo init().");

		System.out.println("Instanciando lista de hashes...");
		for (int i = 0; i < ResourceTable.getSize(); i++) {
			recAlocados.add(i, new Hashtable<Integer, Integer>());
			requisicoes.add(i, new Hashtable<Integer, Integer>());
		}
	}

	/**
	 * Tries to acquire the given quantity of this resource. Uses deadlock
	 * avoidance or detection depending on the strategy in use, as determined by
	 * ResourceCB.getDeadlockMethod().
	 * 
	 * @param quantity
	 * @return The RRB corresponding to the request. If the request is invalid
	 *         (quantity+allocated>total) then return null.
	 * @OSPProject Resources
	 */
	public RRB do_acquire(int quantity) {

		long timer = System.currentTimeMillis();
		System.out.println("\n\nIniciando do_acquire().");

		// Hashtable<Integer, Boolean> Finish[] = new Hashtable[numRecursos];

		boolean flag = true;

		ThreadCB thread = MMU.getPTBR().getTask().getCurrentThread();

		int work = (this.getMaxClaim(thread) - this.getAllocated(thread));

		int id = this.getID();

		Enumeration<RRB> en = RRBs.elements();

		Vector<RRB> rrbs = new Vector<RRB>();

		RRB rrb = new RRB(thread, this, quantity), rrbaux;

		// inicializar o vetor need

		while (en.hasMoreElements()) {
			rrbaux = (RRB) en.nextElement();
			if (rrbaux.getID() == id)
				rrbs.add(rrbaux); // se for um rrb desta thread entao "fingimos"
			// que alocamos
		}

		if (quantity <= (this.getMaxClaim(thread) - this.getAllocated(thread))
				&& quantity <= this.getMaxClaim(thread)) {
			if (quantity <= this.getAvailable()) {
				if (ResourceCB.getDeadlockMethod() == Avoidance) {
					work = this.getAvailable() - quantity;
					en = rrbs.elements();
					while (en.hasMoreElements()) { // verifica todos os rrbs até
						// encontrar um que possa
						// ser satisfeito.
						rrbaux = (RRB) en.nextElement();
						if (rrbaux.getQuantity() <= work) {
							work += rrbaux.getQuantity();
							rrbs.remove(rrbaux); // remove o rrb que pode ser
							// granted
							en = rrbs.elements();
						}
					}
				} // banqueiro

				if (!(rrbs.isEmpty()))
					flag = false; // se esse vetor estiver vazio eh porque todos
				// os rrbs puderam ser granted
			} else {
				// processo deve esperar
				rrb.setStatus(Suspended);
				thread.suspend(rrb);
				if (requisicoes.get(id).keys().hasMoreElements()) {
					if (requisicoes.get(id).contains(thread.getID()))
						requisicoes.get(id).put(
								thread.getID(),
								requisicoes.get(id).get(thread.getID())
										+ quantity);
					else
						requisicoes.get(id).put(thread.getID(), quantity);
				} else
					requisicoes.get(id).put(thread.getID(), quantity);
				threads.put(thread.getID(), thread);
				RRBs.add(rrb);
				return rrb;
			}
		} else
			return null;// processo excedeu o máximo pedido

		if (flag) {
			// sistema em estado seguro

			if (recAlocados.get(id).get(thread.getID()) != null)
				recAlocados.get(id).put(thread.getID(),
						(recAlocados.get(id).get(thread.getID()) + quantity));
			else
				recAlocados.get(id).put(thread.getID(), quantity);
			recDisponiveis.add(id, this.getAvailable() - quantity);
			rrb.grant();
			threads.put(thread.getID(), thread);
		} else {

			System.out.println("\n\n!Sistema em unsafe state...\n");
			rrb.setStatus(Suspended);
			thread.suspend(rrb);
			RRBs.add(rrb);
			if (requisicoes.get(id).keys().hasMoreElements()) {
				if (requisicoes.get(id).contains(thread.getID())) {
					requisicoes.get(id).put(thread.getID(),
							requisicoes.get(id).get(thread.getID()) + quantity);
				} else {
					requisicoes.get(id).put(thread.getID(), quantity);
				}
			} else {
				requisicoes.get(id).put(thread.getID(), quantity);
			}
			threads.put(thread.getID(), thread);
		}

		System.out.println("Finalizando do_acquire(). Em "
				+ (System.currentTimeMillis() - timer) + "ms.");
		return rrb;
	}

	/**
	 * Performs deadlock detection.
	 * 
	 * @return A vector of ThreadCB objects found to be in a deadlock.
	 * @OSPProject Resources
	 */
	public static Vector<ThreadCB> do_deadlockDetection() {
		Vector<ThreadCB> threadsEmDeadlock = new Vector<ThreadCB>();
		Hashtable<Integer, Boolean> finish = new Hashtable<Integer, Boolean>();
		int threadID;
		int numRecursos = ResourceTable.getSize();
		List<Integer> work = new ArrayList<Integer>(numRecursos);
		boolean fim = false;

		// work = available
		// System.arraycopy(recDisponiveis, 0, work, 0, numRecursos);
		work.addAll(recDisponiveis);

		// se a thread nao tem nenhum recurso alocado seta finish como true,
		// caso contrario, seta como false
		Enumeration<Integer> en = threads.keys();
		while (en.hasMoreElements()) {
			threadID = (Integer) en.nextElement();
			for (int i = 0; i < numRecursos; i++) {
				if (recAlocados.get(i).containsKey(threadID)) {
					if (!finish.containsKey(threadID))
						finish.put(threadID, true);
					if (recAlocados.get(i).get(threadID) != 0)
						finish.put(threadID, false);
				}
			}
		}

		// testa se as threads conseguirao ser finalizadas sem entrar em
		// Deadlock
		test: while (!fim) {
			en = finish.keys();
			while (en.hasMoreElements()) {
				threadID = (Integer) en.nextElement();
				if (!finish.get(threadID)
						&& ResourceCB.requestMenorWork(work, threadID)) {
					for (int i = 0; i < numRecursos; i++) {
						if (recAlocados.get(i).get(threadID) != null)
							work.set(i, recAlocados.get(i).get(threadID)
									+ work.get(i));

					}
					finish.put(threadID, true);
					continue test;
				}
			}
			fim = true;
		}

		// se houver alguma thread com finish igual a false, o sistema
		// esta em Deadlock
		en = finish.keys();
		while (en.hasMoreElements()) {
			threadID = (Integer) en.nextElement();
			if (!finish.get(threadID))
				threadsEmDeadlock.add(threads.get(threadID));
		}

		// nao ha threads em Deadlock
		if (threadsEmDeadlock.isEmpty())
			return null;

		// mata uma thread e chama do_deadlockDetection recursivamente
		threadsEmDeadlock.firstElement().kill();
		ResourceCB.do_deadlockDetection();

		return threadsEmDeadlock;
	}

	/**
	 * When a thread was killed, this is called to release all the resources
	 * owned by that thread.
	 * 
	 * @param thread
	 *            -- the thread in question
	 * @OSPProject Resources
	 */
	public static void do_giveupResources(ThreadCB thread) {
		Enumeration en;
		ResourceCB recurso;
		RRB rrb;

		// libera todos os recursos alocados para a thread
		for (int i = 0; i < ResourceTable.getSize(); i++) {
			recurso = ResourceTable.getResourceCB(i);
			recurso.setAvailable(recurso.getAvailable()
					+ recurso.getAllocated(thread));
			recurso.setAllocated(thread, 0);
			recDisponiveis.add(i, recurso.getAvailable());
			recAlocados.get(i).remove(thread.getID());
		}

		// remove a thread do lista de RRBs, caso ela esteja na lista
		en = RRBs.elements();
		while (en.hasMoreElements()) {
			rrb = (RRB) en.nextElement();
			if (rrb.getThread().getID() == thread.getID())
				RRBs.remove(rrb);
		}

		// remove thread da lista de threads
		threads.remove(thread.getID());

		// verifica se ha algum RRB que pode ter seus recursos alocados
		en = RRBs.elements();
		while (en.hasMoreElements()) {
			rrb = (RRB) en.nextElement();
			recurso = rrb.getResource();
			if (rrb.getQuantity() <= recurso.getAvailable()) {
				rrb.grant();
				recDisponiveis.add(recurso.getID(), recurso.getAvailable());
				recAlocados.get(recurso.getID()).put(rrb.getThread().getID(),
						recurso.getAllocated(rrb.getThread()));
				RRBs.remove(rrb);
				en = RRBs.elements();
			}
		}
	}

	/**
	 * Release a previously acquired resource.
	 * 
	 * @param quantity
	 * @OSPProject Resources
	 */
	public void do_release(int quantity) {
		ThreadCB thread = MMU.getPTBR().getTask().getCurrentThread(), auxThread;

		int id = this.getID(), quant;

		RRB rrb = null;

		ResourceCB recurso;

		Enumeration e = RRBs.elements();

		// libera os recursos
		this.setAvailable((this.getAvailable() + quantity));
		this.setAllocated(thread, (this.getAllocated(thread) - quantity));

		recDisponiveis.add(id, this.getAvailable());
		recAlocados.get(id).put(thread.getID(), this.getAllocated(thread));

		// verifica se ha algum RRB que pode ter seus recursos alocados
		while (e.hasMoreElements()) {
			rrb = (RRB) e.nextElement();
			recurso = rrb.getResource();
			if (rrb.getQuantity() <= recurso.getAvailable()) {
				rrb.grant();
				recDisponiveis.add(recurso.getID(), recurso.getAvailable());
				recAlocados.get(recurso.getID()).put(rrb.getThread().getID(),
						recurso.getAllocated(rrb.getThread()));
				RRBs.remove(rrb);
				e = RRBs.elements();
			}
		}
	}

	/**
	 * Called by OSP after printing an error message. The student can insert
	 * code here to print various tables and data structures in their state just
	 * after the error happened. The body can be left empty, if this feature is
	 * not used.
	 * 
	 * @OSPProject Resources
	 */
	public static void atError() {
		// your code goes here

	}

	/**
	 * Called by OSP after printing a warning message. The student can insert
	 * code here to print various tables and data structures in their state just
	 * after the warning happened. The body can be left empty, if this feature
	 * is not used.
	 * 
	 * @OSPProject Resources
	 */
	public static void atWarning() {
		// your code goes here

	}

	/*
	 * Feel free to add methods/fields to improve the readability of your code
	 */

	/*
	 * Método auxiliar (do_deadlockDetection): retorna 'true' se 'request' <
	 * 'work'. Em vez de usar o próprio 'request', utiliza os rrbs suspensos.
	 */
	public static boolean requestMenorWork(List<Integer> work, int threadID) {
		Enumeration en = RRBs.elements();
		RRB rrb;

		while (en.hasMoreElements()) {
			rrb = (RRB) en.nextElement();
			if (rrb.getThread().getID() == threadID
					&& rrb.getQuantity() > work.get(rrb.getResource().getID())) {
				return false;
			}
		}
		return true;
	}
}