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
			dispatch();
			return null;
		}

		System.out.println("Relacionando a task á thread...");
		thread.setTask(task);

		System.out.println("Setando prioridade a thread...");
		thread.setPriority(1);

		System.out.println("Setando status da thread para Ready...");
		thread.setStatus(ThreadReady);

		// TODO: deve ser colocada na fila de ready ?
		threadsReady.add(thread);

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

			if (!threadsReady.remove(this)) {
				System.out
						.println("A thread que esta sendo removida não se encontra na lista de ready!");
				return;
			}

		}

		else if (this.getStatus() == ThreadWaiting) {

			System.out.println("Thread no status Waiting.");

			// TODO: verificar se esta correto
			System.out.println("Obtendo IORB...");

			System.out.println("Procurando dispositivo a ser cancelado...");
			for (int i = 0; i <= Device.getTableSize(); i++) {

				System.out.println("Verificando dispositivo...");
				Device.get(i).cancelPendingIO(this);

			}

		} else if (this.getStatus() == ThreadRunning) {

			System.out.println("Remove a thread do processador...");
			MMU.getPTBR().getTask().setCurrentThread(null);

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

		// TODO: esta correto ?
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

			System.out.println("Remove a thread do processador...");
			this.getTask().setCurrentThread(null);

		} else if (this.getStatus() >= ThreadWaiting) {

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

			System.out.println("Diminuindo o nivel de espera da thread...");
			this.setStatus(this.getStatus() - 1);

		} else if (this.getStatus() == ThreadWaiting) {

			System.out.println("Setando o status da thread para Ready...");
			this.setStatus(ThreadReady);

			threadsReady.add(this);

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
		
		// Local variables
        TaskCB currentTaskCB = null;
        ThreadCB currentThreadCB = null;
        ThreadCB newThreadCB = null;

        // Getting the current thread to be stopped.
        try {
                currentTaskCB = MMU.getPTBR().getTask();
                currentThreadCB = currentTaskCB.getCurrentThread();
        } catch (Exception e) {
        }

        if (currentThreadCB != null) {
                // To dispatch a new thread, first we need to remove the current
                // thread from the device.
                currentTaskCB.setCurrentThread(null);
                // Set the stopped thread as ready
                currentThreadCB.setStatus(ThreadReady);
                // Remove thread page from MMU
                MMU.setPTBR(null);
                // Put the stopped thread in the array.
                listThreads.add(currentThreadCB);
        }
        // Get the first thread in the array
        if (listThreads.size() > 0) {
                newThreadCB = listThreads.remove(0);
                // Set the page file to be the current thread page
                MMU.setPTBR(newThreadCB.getTask().getPageTable());
                // Set the task's thread as the new thread
                newThreadCB.getTask().setCurrentThread(newThreadCB);

                newThreadCB.setStatus(ThreadRunning);

                // Set the time quantum
                HTimer.set(100);

                return GlobalVariables.SUCCESS;
        }
        // no thread to be executed, we must clean PTBR
        MMU.setPTBR(null);
        return GlobalVariables.FAILURE;
		
		return 0;

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
