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
 * The student module dealing with the creation and killing of tasks. A task
 * acts primarily as a container for threads and as a holder of resources.
 * Execution is associated entirely with threads. The primary methods that the
 * student will implement are do_create(TaskCB) and do_kill(TaskCB). The student
 * can choose how to keep track of which threads are part of a task. In this
 * implementation, an array is used.
 * 
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

	private int MaxThreadsPerTask = 100;
	private int MaxPortsPerTask = 10;

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

		// your code goes here
		super();
		this.threadList = new ArrayList<ThreadCB>();
		this.portList = new ArrayList<PortCB>();
		this.files = new ArrayList<OpenFile>();

	}

	/**
	 * This method is called once at the beginning of the simulation. Can be
	 * used to initialize static variables.
	 * 
	 * @OSPProject Tasks
	 */
	public static void init() {
		// your code goes here

		// This method is called at the very beginning of simulation and can be
		// used to initialize static variables of the class, if necessary.

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

		// allocation of resources to the task, and various initializations

		System.out.println("Create a new page");
		task.setPageTable(new PageTable(task));

		System.out.println("Set creation time");
		task.setCreationTime(HClock.get());
		System.out.println("Creation time: " + task.getCreationTime());

		System.out.println("Set task status");
		task.setStatus(TaskLive);
		System.out.println("Status: " + TaskLive);

		System.out.println("Generate swap file Name");
		String swapFileName = generateSwapFileName(task);

		try {

			System.out.println("Create swap file");
			FileSys.create(swapFileName, MMU.getVirtualAddressBits());

			System.out.println("Attach swap file to task");
			task.setSwapFile(OpenFile.open(swapFileName, task));

		} catch (Exception e) {
			System.out.println("Exception occurs: ");
			e.printStackTrace();
			task = null;
		}

		System.out.println("Creating first thread for task");
		create(task);

		// Return task instance
		return task;

	}

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

		// Kill threads
		for (ThreadCB thread : this.threadList) {
			thread.kill();

			// Remove thread from task
			this.do_removeThread(thread);
		}

		// Remove ports
		for (PortCB port : this.portList) {
			this.do_removePort(port);
		}

		// Set status like Term
		this.setStatus(TaskTerm);

		// Deallocate memory from task page
		this.getPageTable().deallocateMemory();

		for (OpenFile file : this.files) {
			this.do_removeFile(file);
		}

		// Realease swap file
		this.getSwapFile().close();
		this.do_removeFile(getSwapFile());
		FileSys.delete(generateSwapFileName(this));

		// Clear lists
		this.threadList.clear();
		this.threadList = null;
		this.portList.clear();
		this.portList = null;

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

		// Verify full list
		if (this.threadList.size() >= this.MaxThreadsPerTask) {
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

		if (!this.threadList.contains(thread)) {
			return FAILURE;
		}

		this.threadList.remove(thread);
		return SUCCESS;

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

		if (this.portList.size() >= MaxPortsPerTask) {
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

		if (!this.files.contains(file)) {
			return FAILURE;
		}

		this.files.remove(file);

		return SUCCESS;

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
		// your code goes here

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
		// your code goes here

	}

	public final static void dispatch() {

	}

	public final static ThreadCB create(TaskCB task) {

		System.out.println("Creating thread for task " + task.getID());
		ThreadCB thread = null;
		if (task != null) {
			thread = ThreadCB.create(task);
			task.do_addThread(thread);
		}

		dispatch();

		return thread;

	}

	/*
	 * Feel free to add methods/fields to improve the readability of your code
	 */

}

/*
 * Feel free to add local classes to improve the readability of your code
 */
