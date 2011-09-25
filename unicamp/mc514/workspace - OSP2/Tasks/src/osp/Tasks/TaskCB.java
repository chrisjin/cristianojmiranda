package osp.Tasks;

import java.util.ArrayList;
import java.util.List;

import osp.FileSys.FileSys;
import osp.FileSys.OpenFile;
import osp.Hardware.HClock;
import osp.IFLModules.IflTaskCB;
import osp.Memory.MMU;
import osp.Memory.PageTable;
import osp.Ports.PortCB;
import osp.Threads.ThreadCB;

/**
 * 
 * The student module dealing with the creation and killing of tasks. A task
 * acts primarily as a container for threads and as a holder of resources.
 * Execution is associated entirely with threads. The primary methods that the
 * student will implement are do_create(TaskCB) and do_kill(TaskCB). The student
 * can choose how to keep track of which threads are part of a task. In this
 * implementation, an array is used.
 * 
 * @author - Cristiano J. Miranda ra: 083382
 * @OSPProject Tasks
 */
public class TaskCB extends IflTaskCB {

	/**
	 * List of threads.
	 */
	private List<ThreadCB> threadList = null;

	/**
	 * 
	 */
	private List<OpenFile> files = null;

	/**
	 * List of Ports
	 */
	private List<PortCB> portList = null;

	/**
	 * The task constructor. Must have
	 * 
	 * super();
	 * 
	 * as its first statement.
	 * 
	 * @OSPProject Tasks
	 */
	public TaskCB() {

		super();
		this.threadList = new ArrayList<ThreadCB>();
		this.portList = new ArrayList<PortCB>();
		this.files = new ArrayList<OpenFile>();

		System.out.println("Creating task: " + this);

	}

	/**
	 * This method is called once at the beginning of the simulation. Can be
	 * used to initialize static variables.
	 * 
	 * @OSPProject Tasks
	 */
	public static void init() {
		System.out.println("Running init...");
	}

	/**
	 * Sets the properties of a new task, passed as an argument.
	 * 
	 * Creates a new thread list, sets TaskLive status and creation time,
	 * creates and opens the task's swap file of the size equal to the size (in
	 * bytes) of the addressable virtual memory.
	 * 
	 * @return task or null
	 * @OSPProject Tasks
	 */
	static public TaskCB do_create() {

		TaskCB task = new TaskCB();

		System.out.println("Create a new page");
		task.setPageTable(new PageTable(task));

		System.out.println("Set creation time");
		task.setCreationTime(HClock.get());
		System.out.println("Creation time: " + task.getCreationTime());

		System.out.println("Set task status");
		task.setStatus(TaskLive);
		System.out.println("Status: " + TaskLive);

		task.setPriority(1);

		System.out.println("Generate swap file Name");
		String swapFileName = generateSwapFileName(task);

		try {

			System.out.println("Create swap file");

			System.out.println("VirtualAddresBits: "
					+ MMU.getVirtualAddressBits());

			if (FileSys.create(swapFileName, 64 * 64 * MMU
					.getVirtualAddressBits()) == FAILURE) {

				return null;
			}

			System.out.println("Attach swap file to task");
			task.setSwapFile(OpenFile.open(swapFileName, task));

			System.out.println("Verify create swap file");
			if (task.getSwapFile() == null) {

				System.out.println("Erro!");

				ThreadCB.dispatch();
				task.do_kill();
				return null;
			}

		} catch (Exception e) {
			System.out.println("Exception occurs: ");
			e.printStackTrace();
			task = null;
		}

		System.out.println("Creating first thread for task");
		ThreadCB.create(task);

		// Return task instance
		return task;

	}

	/**
	 * Generate swap file name.
	 * 
	 * @param task
	 * @return
	 */
	private static String generateSwapFileName(TaskCB task) {
		// Create swap file name
		String swapFileName = SwapDeviceMountPoint
				+ String.valueOf(task.getID());
		return swapFileName;
	}

	/**
	 * Kills the specified task and all of it threads.
	 * 
	 * Sets the status TaskTerm, frees all memory frames (reserved frames may
	 * not be unreserved, but must be marked free), deletes the task's swap
	 * file.
	 * 
	 * @OSPProject Tasks
	 */
	public void do_kill() {

		System.out.println("Kill threads");
		int i = this.threadList.size() - 1;
		while (!this.threadList.isEmpty()) {
			System.out.println("Removing thread: " + this.threadList.get(i));
			this.threadList.get(i--).kill();
		}

		System.out.println("Thread already in task: "
				+ this.do_getThreadCount());

		System.out.println("Remove ports");
		i = this.portList.size() - 1;
		while (!this.portList.isEmpty()) {
			this.portList.get(i--).destroy();
		}

		System.out.println("Remove files");
		i = this.files.size() - 1;
		while (i >= 0) {
			this.files.get(i).close();
			i--;
		}

		System.out.println("Set status like Term");
		this.setStatus(TaskTerm);

		System.out.println("Dealocating memory page.");
		this.getPageTable().deallocateMemory();

		System.out.println("Deleting swap file: " + generateSwapFileName(this));
		FileSys.delete(generateSwapFileName(this));

	}

	/**
	 * Returns a count of the number of threads in this task.
	 * 
	 * @OSPProject Tasks
	 */
	public int do_getThreadCount() {

		System.out.println("Getting thread size: " + this.threadList.size());
		return this.threadList.size();

	}

	/**
	 * Adds the specified thread to this task.
	 * 
	 * @return FAILURE, if the number of threads exceeds MaxThreadsPerTask;
	 *         SUCCESS otherwise.
	 * @OSPProject Tasks
	 */
	public int do_addThread(ThreadCB thread) {

		System.out.println("Add thread: " + thread + " " + thread.hashCode());
		assert (thread.c9().getID() == this.getID());

		System.out.println(" Verify full list");
		if (this.threadList.size() >= ThreadCB.MaxThreadsPerTask) {
			System.out.println("Exceeded maxthread per task size");
			return FAILURE;
		}

		if (this.threadList.contains(thread)) {
			System.out.println("Thread already in task");
			return FAILURE;
		}

		// Append a new thread
		this.threadList.add(thread);

		return SUCCESS;

	}

	/**
	 * Removes the specified thread from this task.
	 * 
	 * @OSPProject Tasks
	 */
	public int do_removeThread(ThreadCB thread) {

		System.out.println("Removing thread: " + thread);

		if (!this.threadList.contains(thread)) {
			return FAILURE;
		}

		if (this.threadList.remove(thread)) {
			return SUCCESS;
		}

		return FAILURE;

	}

	/**
	 * Return number of ports currently owned by this task.
	 * 
	 * @OSPProject Tasks
	 */
	public int do_getPortCount() {
		return this.portList.size();
	}

	/**
	 * Add the port to the list of ports owned by this task.
	 * 
	 * @OSPProject Tasks
	 */
	public int do_addPort(PortCB newPort) {

		if (this.portList.size() >= PortCB.MaxPortsPerTask) {
			return FAILURE;
		}
		this.portList.add(newPort);

		return SUCCESS;
	}

	/**
	 * Remove the port from the list of ports owned by this task.
	 * 
	 * @OSPProject Tasks
	 */
	public int do_removePort(PortCB oldPort) {

		if (!this.portList.contains(oldPort)) {
			return FAILURE;
		}

		this.portList.remove(oldPort);

		return SUCCESS;
	}

	/**
	 * Insert file into the open files table of the task.
	 * 
	 * @OSPProject Tasks
	 */
	public void do_addFile(OpenFile file) {

		this.files.add(file);

	}

	/**
	 * Remove file from the task's open files table.
	 * 
	 * @OSPProject Tasks
	 */
	public int do_removeFile(OpenFile file) {

		System.out.println("Removing file: " + file);
		if (!this.files.contains(file)) {
			return FAILURE;
		}

		if (this.files.remove(file)) {
			return SUCCESS;
		}

		return FAILURE;

	}

	/**
	 * Called by OSP after printing an error message. The student can insert
	 * code here to print various tables and data structures in their state just
	 * after the error happened. The body can be left empty, if this feature is
	 * not used.
	 * 
	 * @OSPProject Tasks
	 */
	public static void atError() {

		System.out.println("ERROR Custom !");

	}

	/**
	 * Called by OSP after printing a warning message. The student can insert
	 * code here to print various tables and data structures in their state just
	 * after the warning happened. The body can be left empty, if this feature
	 * is not used.
	 * 
	 * @OSPProject Tasks
	 */
	public static void atWarning() {

		System.out.println("WARNING Custom !");
	}

	public final static void dispatch() {

		System.out.println("Running dispatch...");

	}

	@Override
	public String toString() {

		StringBuffer buff = new StringBuffer();
		buff.append("Task[id=");
		buff.append(this.getID());
		buff.append(", threads=");
		buff.append(this.threadList.size());
		buff.append(", ports=");
		buff.append(this.portList.size());
		buff.append(", files=");
		buff.append(this.files.size());
		buff.append("]");

		return buff.toString();
	}

	/*
	 * Feel free to add methods/fields to improve the readability of your code
	 */

}

/*
 * Feel free to add local classes to improve the readability of your code
 */
