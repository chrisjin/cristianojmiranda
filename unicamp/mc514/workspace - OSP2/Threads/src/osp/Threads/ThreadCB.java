package osp.Threads;

import java.util.PriorityQueue;
import java.util.Vector;
import java.util.Enumeration;
import java.util.concurrent.PriorityBlockingQueue;

import osp.Utilities.*;
import osp.IFLModules.*;
import osp.Tasks.*;
import osp.EventEngine.*;
import osp.Hardware.*;
import osp.Devices.*;
import osp.Memory.*;
import osp.Resources.*;

/**
 * This class is responsible for actions related to threads, including creating,
 * killing, dispatching, resuming, and suspending threads.
 * 
 * @OSPProject Threads
 */
public class ThreadCB extends IflThreadCB {
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
		// your code goes here

	}

	/**
	 * This method will be called once at the beginning of the simulation. The
	 * student can set up static variables here.
	 * 
	 * @OSPProject Threads
	 */
	public static void init() {
		// your code goes here

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

		System.out.println("Criando uma thread...");
		ThreadCB thread = new ThreadCB();

		System.out.println("Relacionando a thread á task...");
		if (task.addThread(thread) == FAILURE) {

			System.out
					.println("Excedeu o numero de threads por task, operação não pode ser realizada.");
			return null;
		}

		System.out.println("Relacionando a task á thread...");
		thread.setTask(task);

		System.out.println("Setando prioridade a thread...");
		thread.setPriority(1);

		System.out.println("Setando status da thread para Ready...");
		thread.setStatus(ThreadReady);

		// TODO: deve ser colocada na fila de ready ?

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
		if (this.getStatus() == ThreadWaiting) {

			System.out.println("Thread no status Waiting.");

			System.out.println("Obtendo IORB...");
			IORB iorb = new IORB(this, null, 0, 0, 0, null);

			System.out.println("Procurando dispositivo a ser cancelado...");
			for (int i = 0; i <= Device.getTableSize(); i++) {

				Device device = Device.get(i);
				System.out.println("Verificando dispositivo: "
						+ device.toString());
				if (device.getID() == iorb.getDeviceID()) {

					System.out
							.println("Dispositivo encontrado! Cancelando IO...");
					device.cancelPendingIO(this);
					System.out.println("IO finalizado com sucesso!");

				}

			}

		}

		// TODO: and a number of other actions must be performed depending on
		// the current status of the thread (getStatus())

		System.out.println("Setando o status da thread para Kill...");
		this.setStatus(ThreadKill);

		// TODO: remover da fila de ready ?
		// TODO: remover do controle da CPU

		System.out.println("Liberando recursos alocados...");
		ResourceCB.giveupResources(this);

		// TODO: esta correto ?
		dispatch();

		System.out
				.println("Verificando se a Task apresenta alguma outra thread...");
		if (this.getTask().getThreadCount() == 1) {

			System.out
					.println("Finalizando a Task, pois todas as suas threads foram finalizada...");
			this.getTask().kill();

		}

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

			System.out.println("Adicionado a thread a lista do evento...");
			event.addThread(this);

			// TODO: a thread em questão deve perder o controle da CPU ! (como
			// fazer isso?)

		} else if (this.getStatus() >= ThreadWaiting) {

			System.out.println("Thread Waiting. Atualizando para Waiting+1...");
			this.setStatus(this.getStatus() + 1);

			System.out.println("Adicionado a thread a lista do evento...");
			event.addThread(this);

		} else {
			System.out
					.println("Atenção! A thread a ser suspensa não se encontra nem no status Running, nem no status Waiting.");

		}

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

			// TODO: colocar na fila. Como?

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
		// your code goes here
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
		// your code goes here

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
		// your code goes here

	}

	/*
	 * Feel free to add methods/fields to improve the readability of your code
	 */

}

/*
 * Feel free to add local classes to improve the readability of your code
 */
