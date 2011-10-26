package osp.Resources;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import osp.IFLModules.IflResourceCB;
import osp.Memory.MMU;
import osp.Tasks.TaskCB;
import osp.Threads.ThreadCB;

/**
 * Class ResourceCB is the core of the resource management module. Students
 * implement all the do_* methods.
 * 
 * @OSPProject Resources
 * @author Cristiano J. Miranda (ra: 083382)
 */
public class ResourceCB extends IflResourceCB {

	// Threads do sistema
	private static List<ThreadCB> threadsSistema = new ArrayList<ThreadCB>();

	// Map para armazenar as requests suspensas.
	private static Map<Integer, HashMap<ThreadCB, RRB>> threadsSuspenas = new HashMap<Integer, HashMap<ThreadCB, RRB>>();

	/**
	 * Creates a new ResourceCB instance with the given number of available
	 * instances. This constructor must have super(qty) as its first statement.
	 * 
	 * @OSPProject Resources
	 */
	public ResourceCB(int qty) {
		super(qty);
		System.out.println("Executando contrutor ResourceCB().");
	}

	/**
	 * This method is called once, at the beginning of the simulation. Can be
	 * used to initialize static variables.
	 * 
	 * @OSPProject Resources
	 */
	public static void init() {

		System.out.println("Executando o metodo init().");

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
		System.out.println("Iniciando do_acquire().");

		System.out
				.println("Verifica se esta sendo solicitado uma quantidade valida de recursos.");
		if (quantity <= 0) {

			System.out
					.println("Deve ser fornecido quantidades superiores a 0 de recursos...");
			System.out.println("Finalizando do_acquire(). Em "
					+ (System.currentTimeMillis() - timer) + "ms.");
			return null;
		}

		System.out.println("Obtendo a task atual...");
		TaskCB taskAtual = MMU.getPTBR().getTask();

		System.out.println("Obtendo a thread que esta executando...");
		ThreadCB threadAtual = taskAtual.getCurrentThread();

		System.out.println("Adiciona thread a lista de threads do sistema...");
		threadsSistema.add(threadAtual);

		System.out
				.println("Verifica se a quantidade de recursos alocados mais a quantidade solicitada é maior que o total...");
		if ((this.getAllocated(threadAtual)) + quantity > this.getTotal()) {
			System.out
					.println("Impossivel alocar mais recursos que existentes.");
			System.out.println("Finalizando do_acquire(). Em "
					+ (System.currentTimeMillis() - timer) + "ms.");
			return null;
		}

		System.out
				.println("Verificando se a quantidade de recursos solicitados supera os recursos esperados para a task...");
		if ((this.getAllocated(threadAtual)) + quantity > this
				.getMaxClaim(threadAtual)) {
			System.out
					.println("Recursos solicitados superam os valores declarados para essa task...");
			System.out.println("Finalizando do_acquire(). Em "
					+ (System.currentTimeMillis() - timer) + "ms.");
			return null;
		}

		System.out.println("Montando a request....");
		RRB request = new RRB(threadAtual, this, quantity);

		System.out
				.println("Simula a atribuição do recurso antes de fato atribui-lo...");
		if (bankerVerify(threadAtual, quantity, this)) {

			System.out.println("Autoriza a requisição...");
			request.grant();

		} else {

			System.out.println("Suspende a requisição...");
			request.setStatus(RRB.Suspended);

			System.out
					.println("Inserindo requisição na map de itens suspensos...");
			if (threadsSuspenas.containsKey(getID())) {
				System.out
						.println("Já existem itens suspensos para esse id, inserindo outro mais...");
				threadsSuspenas.get(getID()).put(threadAtual, request);
			} else {

				System.out
						.println("Inserindo o primeiro item suspenso para o id...");
				HashMap<ThreadCB, RRB> map = new HashMap<ThreadCB, RRB>();
				map.put(threadAtual, request);
				threadsSuspenas.put(getID(), map);
			}

			System.out.println("Seta a thread atual como suspensa...");
			threadAtual.suspend(request);
		}

		System.out.println("Finalizando do_acquire(). Em "
				+ (System.currentTimeMillis() - timer) + "ms.");

		return request;

	}

	/**
	 * Verifica a integridade do sistema com base no banker algorithm.
	 * 
	 * @param thread
	 * @param quantity
	 * @param recurso
	 * @return
	 */
	private boolean bankerVerify(ThreadCB thread, int quantity,
			ResourceCB recurso) {

		long timer = System.currentTimeMillis();
		System.out.println("Iniciando bankerVerify().");

		// Impede a alocação caso tente alocar menos que zero recurso,
		// ou não haja recursos disponiveis para alocação ou
		// a quantidade de recursos a serem alocados seja superior a quantidade
		// de recursos declarados.
		System.out.println("Verifica a validade da requisição...");
		if (quantity <= 0
				|| recurso.getAvailable() < quantity
				|| (recurso.getAllocated(thread) + quantity) > recurso
						.getMaxClaim(thread)) {

			System.out.println("Requisição invalida. Não permite alocar.");
			System.out.println("Finalizando bankerVerify(). Em "
					+ (System.currentTimeMillis() - timer) + "ms.");
			return false;
		}

		// Monta vetor de recursos disponiveis
		int resourcesAvailables[] = new int[ResourceTable.getSize()];

		// Monta Matrix de recursos previamente pretendidos(necessarios) para a
		// task
		int claimMatrix[][] = new int[threadsSistema.size()][ResourceTable
				.getSize()];

		// Monta a matrix de alocação dos recursos
		int allocationMatrix[][] = new int[threadsSistema.size()][ResourceTable
				.getSize()];

		// Executa a contagem de recursos disponiveis e alocados
		contabilizarRecursos(quantity, recurso, resourcesAvailables,
				claimMatrix, allocationMatrix);

		System.out.println("Verificando se o sistema esta em estado seguro...");
		if (verificaSistemaEstadoSeguro(resourcesAvailables, claimMatrix,
				allocationMatrix)) {

			System.out.println("Sistema em estado seguro. Alocação permitida!");
			return true;
		}

		System.out.println("Finalizando bankerVerify(). Em "
				+ (System.currentTimeMillis() - timer) + "ms.");

		return false;
	}

	/**
	 * @param quantity
	 * @param recurso
	 * @param resourcesAvailables
	 * @param claimMatrix
	 * @param allocationMatrix
	 */
	private void contabilizarRecursos(int quantity, ResourceCB recurso,
			int[] resourcesAvailables, int[][] claimMatrix,
			int[][] allocationMatrix) {

		// Executa a contagem de recursos disponiveis
		contabilizarRecursosDisponiveis(quantity, recurso, resourcesAvailables);

		System.out.println("Monta a mapTemporaria...");
		Map<ThreadCB, Integer> tempHash = new HashMap<ThreadCB, Integer>();
		int count = 0;
		for (ThreadCB t : threadsSistema) {
			tempHash.put(t, new Integer(count++));
		}

		System.out
				.println("Contabiliza recursos alocados x recursos declarados.");
		for (int resourceIndex = 0; resourceIndex < ResourceTable.getSize(); resourceIndex++) {

			for (ThreadCB td : threadsSistema) {

				// Obtem o index da thread
				int threadIndex = tempHash.get(td);

				claimMatrix[threadIndex][resourceIndex] = ResourceTable
						.getResourceCB(resourceIndex).getMaxClaim(td);

				if (recurso == ResourceTable.getResourceCB(resourceIndex)) {
					allocationMatrix[threadIndex][resourceIndex] = ResourceTable
							.getResourceCB(resourceIndex).getAllocated(td)
							+ quantity;
				} else {
					allocationMatrix[threadIndex][resourceIndex] = ResourceTable
							.getResourceCB(resourceIndex).getAllocated(td);
				}
			}
		}
	}

	/**
	 * Monta a matrix de recursos disponiveis.
	 * 
	 * @param quantity
	 * @param recurso
	 * @param resourcesAvailables
	 */
	private void contabilizarRecursosDisponiveis(int quantity,
			ResourceCB recurso, int[] resourcesAvailables) {
		for (int i = 0; i < ResourceTable.getSize(); i++) {

			if (recurso == ResourceTable.getResourceCB(i)) {

				System.out
						.println("Setando disponibilidade para o recurso a ser alocado...");
				resourcesAvailables[i] = ResourceTable.getResourceCB(i)
						.getAvailable()
						- quantity;
			} else {

				resourcesAvailables[i] = ResourceTable.getResourceCB(i)
						.getAvailable();
			}
		}
	}

	/**
	 * Verifica se o sistema esta em estado seguro.
	 * 
	 * @param availablesResources
	 * @param claimResources
	 * @param allocatedResources
	 * @return
	 */
	private boolean verificaSistemaEstadoSeguro(int[] availablesResources,
			int[][] claimResources, int[][] allocatedResources) {

		boolean threadFinaliza[] = new boolean[threadsSistema.size()];

		for (int i = 0; i < threadsSistema.size(); i++) {

			boolean finaliza = true;

			for (int j = 0; j < ResourceTable.getSize(); j++) {
				if (availablesResources[j] < (claimResources[i][j] - allocatedResources[i][j])) {
					System.out
							.println("Esta sendo alocado mais recusos do que o disponivel!");
					finaliza = false;
					break;
				}
			}

			if (finaliza) {
				
				for (int k = 0; k < ResourceTable.getSize(); k++) {

					availablesResources[k] = availablesResources[k]
							+ allocatedResources[i][k];

					allocatedResources[i][k] = 0;
				}
				threadFinaliza[i] = true;
			}

		}

		for (int i = 0; i < threadsSistema.size(); i++) {
			if (!threadFinaliza[i]) {

				System.out
						.println("Existem threads que não finalizam. Sistema não se encontra seguro.");
				return false;
			}
		}

		return true;

	}

	/**
	 * Performs deadlock detection.
	 * 
	 * @return A vector of ThreadCB objects found to be in a deadlock.
	 * @OSPProject Resources
	 */
	public static Vector do_deadlockDetection() {
		// your code goes here
		return null;

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
		// your code goes here

	}

	/**
	 * Release a previously acquired resource.
	 * 
	 * @param quantity
	 * @OSPProject Resources
	 */
	public void do_release(int quantity) {
		// your code goes here

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
		System.out.println("Executando atError().");
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
		System.out.println("Executando atWarning().");

	}

}
