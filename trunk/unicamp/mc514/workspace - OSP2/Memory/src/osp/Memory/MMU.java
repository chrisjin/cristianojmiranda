package osp.Memory;

import osp.Hardware.CPU;
import osp.IFLModules.IflMMU;
import osp.Interrupts.InterruptVector;
import osp.Threads.ThreadCB;

/**
 * The MMU class contains the student code that performs the work of handling a
 * memory reference. It is responsible for calling the interrupt handler if a
 * page fault is required.
 * 
 * @OSPProject Memory
 */
public class MMU extends IflMMU {
	/**
	 * This method is called once before the simulation starts. Can be used to
	 * initialize the frame table and other static variables.
	 * 
	 * @OSPProject Memory
	 */
	public static void init() {

		long timer = System.currentTimeMillis();
		System.out.println("INICIO metodo init().");

		for (int i = 0; i < MMU.getFrameTableSize(); ++i) {
			MMU.setFrame(i, new FrameTableEntry(i));
		}

		System.out.println("FIM metodo init(). "
				+ (System.currentTimeMillis() - timer) + "ms");
	}

	/**
	 * This method handlies memory references. The method must calculate, which
	 * memory page contains the memoryAddress, determine, whether the page is
	 * valid, start page fault by making an interrupt if the page is invalid,
	 * finally, if the page is still valid, i.e., not swapped out by another
	 * thread while this thread was suspended, set its frame as referenced and
	 * then set it as dirty if necessary. (After pagefault, the thread will be
	 * placed on the ready queue, and it is possible that some other thread will
	 * take away the frame.)
	 * 
	 * @param memoryAddress
	 *            A virtual memory address
	 * @param referenceType
	 *            The type of memory reference to perform
	 * @param thread
	 *            that does the memory access (e.g., MemoryRead or MemoryWrite).
	 * @return The referenced page.
	 * @OSPProject Memory
	 */
	static public PageTableEntry do_refer(int memoryAddress, int referenceType,
			ThreadCB thread) {

		long timer = System.currentTimeMillis();
		System.out.println("INICIO metodo do_refer().");

		System.out.println("Calculando o tamanho da pagina...");
		int pageSize = (int) Math.pow(2, getVirtualAddressBits()
				- getPageAddressBits());

		System.out.println("Calculando o nr de paginas...");
		int totalPaginas = memoryAddress / pageSize;

		System.out.println("Obtendo a pagina...");
		PageTableEntry page = thread.getTask().getPageTable().pages[totalPaginas];

		if (page.isValid()) {

			if (referenceType == MemoryWrite) {
				page.getFrame().setDirty(true);
			}

			page.getFrame().setReferenced(true);
			System.out.println("FIM metodo do_refer(). "
					+ (System.currentTimeMillis() - timer));
			return page;

		} else {
			if (page.getValidatingThread() != null) {
				thread.suspend(page);

				page.getFrame().setReferenced(true); // Kill?
				if (referenceType == MemoryWrite
						&& thread.getStatus() != ThreadKill)
					page.getFrame().setDirty(true);

				System.out.println("FIM metodo do_refer(). "
						+ (System.currentTimeMillis() - timer));
				return page;
			} else {
				InterruptVector.setInterruptType(PageFault);
				InterruptVector.setPage(page);
				InterruptVector.setReferenceType(referenceType);
				InterruptVector.setThread(thread);

				CPU.interrupt(PageFault);

				page.getFrame().setReferenced(true); // Kill?
				if (referenceType == MemoryWrite
						&& thread.getStatus() != ThreadKill)
					page.getFrame().setDirty(true);

				System.out.println("FIM metodo do_refer(). "
						+ (System.currentTimeMillis() - timer));
				return page;
			}
		}

	}

	/**
	 * Called by OSP after printing an error message. The student can insert
	 * code here to print various tables and data structures in their state just
	 * after the error happened. The body can be left empty, if this feature is
	 * not used.
	 * 
	 * @OSPProject Memory
	 */
	public static void atError() {
		System.out.println("\n\nOps, ocorreu um erro!");
	}

	/**
	 * Called by OSP after printing a warning message. The student can insert
	 * code here to print various tables and data structures in their state just
	 * after the warning happened. The body can be left empty, if this feature
	 * is not used.
	 * 
	 * @OSPProject Memory
	 */
	public static void atWarning() {

		System.out.println("\n\nOps, ocorreu um warning!");

	}

}
