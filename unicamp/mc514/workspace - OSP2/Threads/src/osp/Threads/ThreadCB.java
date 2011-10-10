package osp.Threads;

import java.util.ArrayList;
import java.util.List;

import osp.Devices.Device;
import osp.IFLModules.Event;
import osp.IFLModules.IflThreadCB;
import osp.Memory.MMU;
import osp.Resources.ResourceCB;
import osp.Tasks.TaskCB;

/**
 * This class is responsible for actions related to threads, including creating,
 * killing, dispatching, resuming, and suspending threads.
 * 
 * @OSPProject Threads
 * @author Cristiano J. Miranda(ra 083382)
 */
public class ThreadCB extends IflThreadCB {

	// Lista com as threads criadas.
	private static List<ThreadCB> threadsReady;

	/**
	 * The thread constructor. Must call
	 * 
	 * super();
	 * 
	 * as its first statement.
	 * 
	 * @OSPProject Threads
	 */
	public ThreadCB() {

		super();
		System.out.println("Executando o contrutor ThreadCB().");

	}

	/**
	 * This method will be called once at the beginning of the simulation. The
	 * student can set up static variables here.
	 * 
	 * @OSPProject Threads
	 */
	public static void init() {

		System.out.println("executando o metodo init().");

		// Inicializando a lista de threads
		threadsReady = new ArrayList<ThreadCB>();

	}

	/**
	 * Sets up a new thread and adds it to the given task. The method must set
	 * the ready status and attempt to add thread to task. If the latter fails
	 * because there are already too many threads in this task, so does this
	 * method, otherwise, the thread is appended to the ready queue and
	 * dispatch() is called.
	 * 
	 * The priority of the thread can be set using the getPriority/setPriority
	 * methods. However, OSP itself doesn't care what the actual value of the
	 * priority is. These methods are just provided in case priority scheduling
	 * is required.
	 * 
	 * @return thread or null
	 * @OSPProject Threads
	 */
	public static ThreadCB do_create(TaskCB task) {

		System.out.println("Executando o metodo: do_create()");

		System.out.println("Verificando limite de threads por tasks.");
		if (task.getThreadCount() == ThreadCB.MaxThreadsPerTask) {

			System.out
					.println("Excedeu o numero de threads por task, operação não pode ser realizada.");
			dispatch();
			return null;

		}

		System.out.println("Criando uma thread...");
		ThreadCB thread = new ThreadCB();

		System.out.println("Relacionando a thread á task...");
		if (task.addThread(thread) == FAILURE) {

			System.out
					.println("Excedeu o numero de threads por task, operação não pode ser realizada.");
			// dispatch();
			return null;
		}

		System.out.println("Relacionando a task á thread...");
		thread.setTask(task);

		// System.out.println("Setando prioridade a thread...");
		// thread.setPriority(1);

		System.out.println("Setando status da thread para Ready...");
		thread.setStatus(ThreadReady);

		System.out.println("Colocando thread na fila ready.");
		threadsReady.add(thread);

		// MMU.setPTBR(task.getPageTable());

		dispatch();

		System.out.println("Retonando a thread criada.");
		return thread;

	}

	/**
	 * Kills the specified thread.
	 * 
	 * The status must be set to ThreadKill, the thread must be removed from the
	 * task's list of threads and its pending IORBs must be purged from all
	 * device queues.
	 * 
	 * If some thread was on the ready queue, it must removed, if the thread was
	 * running, the processor becomes idle, and dispatch() must be called to
	 * resume a waiting thread.
	 * 
	 * @OSPProject Threads
	 */
	public void do_kill() {

		System.out.println("Destruindo a thread...");

		System.out.println("Verificando status da thrad atual...");
		if (this.getStatus() == ThreadReady) {

			threadsReady.remove(this);

		}

		else if (this.getStatus() == ThreadRunning) {

			dispatch();
			threadsReady.remove(this);

			System.out.println("Remove a thread do processador...");
			MMU.getPTBR().getTask().setCurrentThread(null);

		} else {

			System.out.println("Thread no status Waiting.");

			System.out.println("Procurando dispositivo a ser cancelado...");
			for (int i = 0; i < Device.getTableSize(); i++) {

				System.out.println("Verificando dispositivo...");
				Device.get(i).cancelPendingIO(this);

			}

		}

		System.out.println("Remove a thread da task...");
		if (this.getTask().removeThread(this) == FAILURE) {
			System.out.println("Erro ao remover thread da task.");
			return;
		}

		// TODO: and a number of other actions must be performed depending on
		// the current status of the thread (getStatus())

		System.out.println("Setando o status da thread para Kill...");
		this.setStatus(ThreadKill);

		// TODO: remover da fila de ready ?
		// TODO: remover do controle da CPU

		System.out.println("Liberando recursos alocados...");
		ResourceCB.giveupResources(this);

		System.out
				.println("Verificando se a Task apresenta alguma outra thread...");
		if (this.getTask().getThreadCount() == 0) {

			System.out
					.println("Finalizando a Task, pois todas as suas threads foram finalizada...");
			this.getTask().kill();

		}

		dispatch();

		System.out.println("Thread destruida com sucesso.");

	}

	/**
	 * Suspends the thread that is currenly on the processor on the specified
	 * event.
	 * 
	 * Note that the thread being suspended doesn't need to be running. It can
	 * also be waiting for completion of a pagefault and be suspended on the
	 * IORB that is bringing the page in.
	 * 
	 * Thread's status must be changed to ThreadWaiting or higher, the processor
	 * set to idle, the thread must be in the right waiting queue, and
	 * dispatch() must be called to give CPU control to some other thread.
	 * 
	 * @param event
	 *            - event on which to suspend this thread.
	 * @OSPProject Threads
	 */
	public void do_suspend(Event event) {

		System.out.println("Suspendendo thread...");

		System.out.println("Verificando status atual da thread");
		if (this.getStatus() == ThreadRunning) {

			System.out.println("Thread running. Atualizando para Waiting...");
			this.setStatus(ThreadWaiting);

			System.out
					.println("Remove a thread que esta sendo executada do processador.");
			MMU.getPTBR().getTask().setCurrentThread(null);

			System.out.println("Remove a task do processador.");
			MMU.setPTBR(null);

			System.out.println("Remove a thread do processador...");
			this.getTask().setCurrentThread(null);

		} else if (this.getStatus() == ThreadReady) {

			System.out.println("Remove a thread do evento...");
			event.removeThread(this);
			this.setStatus(ThreadWaiting);

		} else if (this.getStatus() >= ThreadWaiting) {

			System.out.println("Remove a thread do evento...");
			event.removeThread(this);

			System.out.println("Thread Waiting. Atualizando para Waiting+1...");
			this.setStatus(this.getStatus() + 1);

		} else {
			System.out
					.println("Atenção! A thread a ser suspensa não se encontra nem no status Running, nem no status Waiting.");

		}

		System.out.println("Remove a thread da lista de ready...");
		threadsReady.remove(this);

		System.out.println("Adicionado a thread a lista do evento...");
		event.addThread(this);

		// Esta correto?
		dispatch();

	}

	/**
	 * Resumes the thread.
	 * 
	 * Only a thread with the status ThreadWaiting or higher can be resumed. The
	 * status must be set to ThreadReady or decremented, respectively. A ready
	 * thread should be placed on the ready queue.
	 * 
	 * @OSPProject Threads
	 */
	public void do_resume() {

		System.out.println("Resume thread...");

		if (this.getStatus() > ThreadWaiting) {

			System.out.println("Nivel atual: " + this.getStatus());
			System.out.println("Diminuindo o nivel de espera da thread...");
			this.setStatus(this.getStatus() - 1);

		} else if (this.getStatus() == ThreadWaiting) {

			System.out.println("Setando o status da thread para Ready...");
			this.setStatus(ThreadReady);

			threadsReady.add(this);

		} else if (this.getStatus() == ThreadReady) {
			return;
		}

		dispatch();

	}

	/**
	 * Selects a thread from the run queue and dispatches it.
	 * 
	 * If there is just one theread ready to run, reschedule the thread
	 * currently on the processor.
	 * 
	 * In addition to setting the correct thread status it must update the PTBR.
	 * 
	 * @return SUCCESS or FAILURE
	 * @OSPProject Threads
	 */
	public static int do_dispatch() {

		System.out.println("Executando o metodo do_dispatch().");

		if (MMU.getPTBR() == null) {

			System.out.println("Não existe threads executando");

			if (threadsReady.isEmpty()) {
				return FAILURE;
			}

			System.out.println("Obtendo a primeira thread da fila de ready...");
			ThreadCB current = threadsReady.remove(0);

			System.out.println("Setando o status da thread para running");
			current.setStatus(ThreadRunning);

			System.out.println("Setando pagina da task a ser executada");
			MMU.setPTBR(current.getTask().getPageTable());

			System.out
					.println("Setando a thread que esta sendo executada na task.");
			current.getTask().setCurrentThread(current);

			System.out.println("Operação realizacao com sucesso.");
			return SUCCESS;

		}
		System.out.println("Obtem a thread local a ser parada...");
		TaskCB currentTaskCB = MMU.getPTBR().getTask();
		ThreadCB currentThreadCB = currentTaskCB.getCurrentThread();

		if (currentThreadCB != null) {

			if (currentThreadCB.getStatus() == ThreadKill) {
				return SUCCESS;
			}

			if (currentThreadCB.getTimeOnCPU() % 2 < 1) {
				return SUCCESS;
			}

			System.out.println("Seta o status da thread atual para Ready.");
			currentThreadCB.setStatus(ThreadReady);

			System.out.println("Seta a thread atual da task como null.");
			currentTaskCB.setCurrentThread(null);

			System.out.println("Remove a thread atual do processador");
			MMU.setPTBR(null);

			System.out.println("Coloca a thread atual na fila de ready.");
			threadsReady.add(currentThreadCB);
		}

		System.out.println("Caso a fila de threads ready não esteja vazia...");
		if (!threadsReady.isEmpty()) {

			System.out.println("Obtem a primeira thread da fila.");
			ThreadCB newThreadCB = threadsReady.remove(0);

			System.out.println("Seta a pagina para a nova thread.");
			MMU.setPTBR(newThreadCB.getTask().getPageTable());

			System.out
					.println("Atualiza a task para a thread atual como sendo a nova.");
			newThreadCB.getTask().setCurrentThread(newThreadCB);

			System.out.println("Seta o status da nova thread para running.");
			newThreadCB.setStatus(ThreadRunning);

			System.out.println("Seta o time slice.");

			System.out.println("Dispatch realizado com sucesso!");
			return SUCCESS;
		}

		// HTimer.set(100);

		System.out
				.println("Não havia threads a serem escaladas. Operação finalizada com erro.");
		MMU.setPTBR(null);
		return FAILURE;

	}

	/**
	 * Called by OSP after printing an error message. The student can insert
	 * code here to print various tables and data structures in their state just
	 * after the error happened. The body can be left empty, if this feature is
	 * not used.
	 * 
	 * @OSPProject Threads
	 */
	public static void atError() {

		System.out.println("Executando o metodo atError().");
	}

	/**
	 * Called by OSP after printing a warning message. The student can insert
	 * code here to print various tables and data structures in their state just
	 * after the warning happened. The body can be left empty, if this feature
	 * is not used.
	 * 
	 * @OSPProject Threads
	 */
	public static void atWarning() {
		System.out.println("Executando o metodo atWarning().");

	}

}
