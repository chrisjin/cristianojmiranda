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
	 * Vetor de recursos.
	 */
	private static Vector<RRB> RRBVector = new Vector<RRB>();

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

		long timer = System.currentTimeMillis();
		System.out.println("\n\nExecutando o metodo init().");

		System.out.println("Instanciando lista de hashes...");
		for (int i = 0; i < ResourceTable.getSize(); i++) {
			recAlocados.add(i, new Hashtable<Integer, Integer>());
			requisicoes.add(i, new Hashtable<Integer, Integer>());
		}

		System.out.println("Init() finalizado em "
				+ (System.currentTimeMillis() - timer) + "ms.");
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

		System.out.println("Obtendo a thread atual...");
		ThreadCB thread = MMU.getPTBR().getTask().getCurrentThread();

		System.out
				.println("Calculando quantidade de recursos necessarios para completar....");
		int workDiff = (this.getMaxClaim(thread) - this.getAllocated(thread));

		System.out.println("Montando o vetor de recursos...");
		Vector<RRB> rrbs = buildRRBVector();

		System.out.println("Criando a request...");
		RRB rrb = new RRB(thread, this, quantity);

		System.out
				.println("Adiciona a thread atual a lista de threads do sistema...");
		threads.put(thread.getID(), thread);

		System.out
				.println("Verifiando se a quantidade de recusos solicitados existem disponiveis, e se não ultrapassa o limite maximo declarado para o processo...");
		if (quantity <= workDiff && quantity <= this.getMaxClaim(thread)) {

			if (quantity <= this.getAvailable()) {

				System.out
						.println("Quantidade solicitada inferior ou igual a quantidade disponivel de recursos.");
				if (ResourceCB.getDeadlockMethod() == Avoidance) {
					deadlockAvoidanceApproach(quantity, rrbs);
				}

			} else {

				System.out
						.println("Quantidade solicitada superior a quantidade disponivel de recursos. O processo deve esperar...");
				return doAcquireSuspendProcess(quantity, timer, thread, rrb);
			}
		} else {

			System.out
					.println("ATENCAO! O processo excedeu o limite maximo de recursos declarados para o processo.");
			System.out.println("Metodo do_acquire() executou em "
					+ (System.currentTimeMillis() - timer) + "ms.");
			return null;
		}

		System.out
				.println("Verificando se todos as requests foram atendias...");
		if (rrbs.isEmpty()) {

			System.out
					.println("Sistema em estado segudo. Todas as RRBs estão granted...");
			doAcquireSafeState(quantity, thread, rrb);

		} else {

			System.out.println("\n\n!Sistema em um estado não seguro...\n");
			doAcquireUnsafe(quantity, thread, rrb);
		}

		System.out.println("Metodo do_acquire() executou em "
				+ (System.currentTimeMillis() - timer) + "ms.");
		return rrb;
	}

	/**
	 * Controi o vetor de RRB.
	 * 
	 * /** Performs deadlock detection.
	 * 
	 * @return A vector of ThreadCB objects found to be in a deadlock.
	 * @OSPProject Resources
	 */
	public static Vector<ThreadCB> do_deadlockDetection() {

		long timer = System.currentTimeMillis();
		System.out.println("Iniciando do_deadlockDetection().");

		Vector<ThreadCB> deadlockThreads = new Vector<ThreadCB>();

		System.out.println("Copia a lista de recursos disponiveis...");
		List<Integer> work = new ArrayList<Integer>(ResourceTable.getSize());
		work.addAll(recDisponiveis);

		System.out
				.println("Monta a hash de status das threads por finalidade...");
		Hashtable<Integer, Boolean> finishHash = new Hashtable<Integer, Boolean>();
		createFinishHash(finishHash);

		System.out.println("Tenta finalizar as threads ativas...");
		tryFinishThreads(work, finishHash);

		System.out
				.println("Verificando se existe alguma thread em deadlock....");

		for (Integer threadId : finishHash.keySet()) {

			System.out.print("Verificando deadlock thread: " + threadId);
			if (!finishHash.get(threadId)) {
				System.out.println("  -> DEADLOCK!");
				deadlockThreads.add(threads.get(threadId));
			}

			System.out.println("  -> free!");
		}

		if (deadlockThreads.isEmpty()) {
			System.out.println("Nenhuma  thread em deadlock!");
			System.out.println("Metodo do_deadlockDetection() finalizado em "
					+ (System.currentTimeMillis() - timer) + "ms.");
			return null;
		}

		System.out.println("Killing thread...");
		deadlockThreads.firstElement().kill();

		System.out.println("Verificando deadlock recursivamente...");
		ResourceCB.do_deadlockDetection();

		System.out.println("Metodo do_deadlockDetection() finalizado em "
				+ (System.currentTimeMillis() - timer) + "ms.");

		return deadlockThreads;
	}

	/**
	 * Verifica se uma thread consegue terminar com os recursos disponiveis.
	 * 
	 * @param finish
	 */
	private static void createFinishHash(Hashtable<Integer, Boolean> finish) {
		for (Integer threadId : threads.keySet()) {

			for (int i = 0; i < ResourceTable.getSize(); i++) {

				if (recAlocados.get(i).containsKey(threadId)) {

					if (!finish.containsKey(threadId)) {
						finish.put(threadId, true);
					}

					if (recAlocados.get(i).get(threadId) != 0) {
						finish.put(threadId, false);
					}

				}
			}
		}
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

		long timer = System.currentTimeMillis();
		System.out.println("Iniciando o metodo do_giveupResources().");

		System.out.println("Liberando os recursos alocados para a thread...");
		for (int i = 0; i < ResourceTable.getSize(); i++) {

			// Obtendo o recurso
			ResourceCB resource = ResourceTable.getResourceCB(i);
			System.out.println("Recurso: " + resource);

			System.out.println("Atualizando availability...");
			resource.setAvailable(resource.getAvailable()
					+ resource.getAllocated(thread));

			System.out.println("Zerando alocação...");
			resource.setAllocated(thread, 0);

			System.out.println("Adicionando a lista de disponiveis...");
			recDisponiveis.add(i, resource.getAvailable());

			System.out.println("Removendo da lista de alocados...");
			recAlocados.get(i).remove(thread.getID());
		}

		System.out.println("Removendo a thread da lista RRB...");
		List<RRB> removeList = new ArrayList<RRB>();
		for (RRB rrb : RRBVector) {
			if (rrb.getThread().getID() == thread.getID()) {
				removeList.add(rrb);
			}
		}
		RRBVector.removeAll(removeList);

		// remove thread da lista de threads
		threads.remove(thread.getID());

		// verifica se ha algum RRB que pode ter seus recursos alocados
		Enumeration en = RRBVector.elements();
		while (en.hasMoreElements()) {
			RRB rrb = (RRB) en.nextElement();
			ResourceCB recurso = rrb.getResource();
			if (rrb.getQuantity() <= recurso.getAvailable()) {
				rrb.grant();
				recDisponiveis.add(recurso.getID(), recurso.getAvailable());
				recAlocados.get(recurso.getID()).put(rrb.getThread().getID(),
						recurso.getAllocated(rrb.getThread()));
				RRBVector.remove(rrb);
				en = RRBVector.elements();
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
		ThreadCB thread = MMU.getPTBR().getTask().getCurrentThread();

		int id = this.getID();

		RRB rrb = null;

		ResourceCB recurso;

		Enumeration<RRB> e = RRBVector.elements();

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
				RRBVector.remove(rrb);
				e = RRBVector.elements();
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
		System.out.println("Ops! Ocorreu um error.");
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

		System.out.println("Ops! Ocorreu um warning.");

	}

	/**
	 * @param work
	 * @param finishHash
	 */
	private static void tryFinishThreads(List<Integer> work,
			Hashtable<Integer, Boolean> finishHash) {

		System.out
				.println("Tenta finalizar as threase sem que haja deadlock...");
		boolean endStatus = false;
		firstLoop: while (!endStatus) {

			for (Integer threadId : finishHash.keySet()) {

				System.out
						.println("Tenta finalizar uma thread com os recursos disponiveis....");
				if (!finishHash.get(threadId)
						&& getLessWorkDiff(work, threadId)) {

					for (int i = 0; i < ResourceTable.getSize(); i++) {

						if (recAlocados.get(i).get(threadId) != null) {
							work.set(i, recAlocados.get(i).get(threadId)
									+ work.get(i));
						}

					}

					finishHash.put(threadId, true);
					continue firstLoop;
				}
			}

			endStatus = true;
		}
	}

	/**
	 * @param work
	 * @param idThread
	 * @return
	 */
	public static boolean getLessWorkDiff(List<Integer> work, int idThread) {

		for (RRB rrb : RRBVector) {
			if (rrb.getThread().getID() == idThread
					&& rrb.getQuantity() > work.get(rrb.getResource().getID())) {
				return false;
			}
		}

		return true;
	}

	/**
	 * Constroi um vetor de rrb com base no id do processo que esta executando.
	 * 
	 * @return
	 */
	private Vector<RRB> buildRRBVector() {

		Vector<RRB> rrbs = new Vector<RRB>();
		for (RRB itRRb : RRBVector) {
			if (itRRb.getID() == this.getID()) {
				rrbs.add(itRRb);
			}
		}

		System.out.println("RRBS=" + rrbs);
		return rrbs;
	}

	/**
	 * Susptende o processo caso tenha solicitado mais recurso do que existe
	 * disponivel no sistema no momento.
	 * 
	 * @param quantity
	 * @param timer
	 * @param thread
	 * @param rrb
	 * @return
	 */
	private RRB doAcquireSuspendProcess(int quantity, long timer,
			ThreadCB thread, RRB rrb) {

		System.out.println("Suspendendo o processo...");
		rrb.setStatus(Suspended);
		thread.suspend(rrb);

		if (requisicoes.get(this.getID()).keys().hasMoreElements()) {

			if (requisicoes.get(this.getID()).contains(thread.getID())) {
				requisicoes.get(this.getID()).put(
						thread.getID(),
						requisicoes.get(this.getID()).get(thread.getID())
								+ quantity);
			} else {
				requisicoes.get(this.getID()).put(thread.getID(), quantity);
			}
		} else {
			requisicoes.get(this.getID()).put(thread.getID(), quantity);
		}

		RRBVector.add(rrb);

		System.out.println("Metodo do_acquire() executou em "
				+ (System.currentTimeMillis() - timer) + "ms.");

		return rrb;
	}

	/**
	 * Abordagem de impedir deadlock, utilizando algoritimo do banqueiro.
	 * 
	 * @param quantity
	 * @param rrbs
	 */
	private void deadlockAvoidanceApproach(int quantity, Vector<RRB> rrbs) {
		int workDiff;
		System.out
				.println("Deadlock avoidance approach. Algoritmo do banqueiro.");

		System.out.println("Autalizando workDiff...");
		workDiff = this.getAvailable() - quantity;

		System.out.println("Simulando atender as requests...");
		List<RRB> removeList = new ArrayList<RRB>();
		for (RRB itRRb : rrbs) {
			if (itRRb.getQuantity() <= workDiff) {
				workDiff += itRRb.getQuantity();
				removeList.add(itRRb);
			}
		}

		System.out.println("Remove os rrbs que não podem ser atribuidos...");
		rrbs.removeAll(removeList);
	}

	/**
	 * Concede o recurso ao processo, pois os sistema esta em um estado seguro.
	 * 
	 * @param quantity
	 * @param thread
	 * @param rrb
	 */
	private void doAcquireSafeState(int quantity, ThreadCB thread, RRB rrb) {
		System.out.println("Atualiza vetor de recursos alocados...");
		if (recAlocados.get(this.getID()).get(thread.getID()) != null) {

			System.out.println("updated!");
			recAlocados
					.get(this.getID())
					.put(
							thread.getID(),
							(recAlocados.get(this.getID()).get(thread.getID()) + quantity));

		} else {
			System.out.println("created!");
			recAlocados.get(this.getID()).put(thread.getID(), quantity);
		}

		System.out
				.println("Atualizando a quantidade de recursos disponiveis...");
		recDisponiveis.add(this.getID(), this.getAvailable() - quantity);

		System.out.println("Concedendo grant a request...");
		rrb.grant();
	}

	/**
	 * Suspende o processo por deixar o sistema em um estado não seguro.
	 * 
	 * @param quantity
	 * @param thread
	 * @param rrb
	 */
	private void doAcquireUnsafe(int quantity, ThreadCB thread, RRB rrb) {

		System.out.println("Suspendendo o processo...");
		rrb.setStatus(Suspended);
		thread.suspend(rrb);
		RRBVector.add(rrb);

		if (requisicoes.get(this.getID()).keys().hasMoreElements()) {
			if (requisicoes.get(this.getID()).contains(thread.getID())) {
				requisicoes.get(this.getID()).put(
						thread.getID(),
						requisicoes.get(this.getID()).get(thread.getID())
								+ quantity);
			} else {
				requisicoes.get(this.getID()).put(thread.getID(), quantity);
			}
		} else {
			requisicoes.get(this.getID()).put(thread.getID(), quantity);
		}

	}
}