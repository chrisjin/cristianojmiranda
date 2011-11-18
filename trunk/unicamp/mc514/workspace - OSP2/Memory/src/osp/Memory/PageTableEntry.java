package osp.Memory;

import osp.Devices.IORB;
import osp.IFLModules.IflPageTableEntry;
import osp.Threads.ThreadCB;

/**
 * The PageTableEntry object contains information about a specific virtual page
 * in memory, including the page frame in which it resides.
 * 
 * @OSPProject Memory
 */

public class PageTableEntry extends IflPageTableEntry {
	/**
	 * The constructor. Must call
	 * 
	 * super(ownerPageTable,pageNumber);
	 * 
	 * as its first statement.
	 * 
	 * @OSPProject Memory
	 */
	public PageTableEntry(PageTable ownerPageTable, int pageNumber) {

		super(ownerPageTable, pageNumber);
		System.out.println("Construtor PageTableEntry(). ownerPageTable="
				+ ownerPageTable + ", pageNumber=" + pageNumber);

	}

	/**
	 * This method increases the lock count on the page by one.
	 * 
	 * The method must FIRST increment lockCount, THEN check if the page is
	 * valid, and if it is not and no page validation event is present for the
	 * page, start page fault by calling PageFaultHandler.handlePageFault().
	 * 
	 * @return SUCCESS or FAILURE FAILURE happens when the pagefault due to
	 *         locking fails or the that created the IORB thread gets killed.
	 * @OSPProject Memory
	 */
	public int do_lock(IORB iorb) {

		long timer = System.currentTimeMillis();
		System.out.println("INICIO metodo do_lock().");

		System.out.println("iorb=" + iorb);
		System.out.println("frame=" + this.getFrame());

		System.out.println("Checando se a pagina esta na memoria...");
		if (this.getFrame() == null || !isValid()) {

			System.out.println("Instanciando o pagefault....");
			//PageFaultHandler.handlePageFault(iorb.getThread(), iorb.getDeviceID(), this);

			System.out.println("FIM metodo do_lock(). "
					+ (System.currentTimeMillis() - timer) + "ms.");
			return FAILURE;
		}

		System.out.println("Incrementando o lock count...");
		this.getFrame().incrementLockCount();

		// To help identify the pages that are involved in a pagefault, OSP 2
		// provides the method getValidatingThread()
		// this method returns the thread that caused a pagefault on that page
		if (iorb.getThread() == null
				|| getValidatingThread() == iorb.getThread()) {
			// If Th2 = Th1, then the proper action is to return right after
			// incrementing the lock count
			System.out.println("FIM metodo do_lock(). "
					+ (System.currentTimeMillis() - timer) + "ms.");
			return SUCCESS;
		}
		if (iorb.getThread() != null
				|| getValidatingThread() != iorb.getThread()) {
			// If Th2 != Th1 execute the suspend() method on Th2 and pass page P
			// as a parameter
			ThreadCB th = iorb.getThread();
			th.suspend(this);
			if (isValid()) {
				System.out.println("FIM metodo do_lock(). "
						+ (System.currentTimeMillis() - timer) + "ms.");
				return SUCCESS;
				// SUCCESS if the page became valid as a result of the pagefault
			}
			// and FAILURE otherwise.
			System.out.println("FIM metodo do_lock(). "
					+ (System.currentTimeMillis() - timer) + "ms.");
			return FAILURE;
		}

		System.out.println("FIM metodo do_lock(). "
				+ (System.currentTimeMillis() - timer) + "ms.");
		return SUCCESS;

	}

	/**
	 * This method decreases the lock count on the page by one.
	 * 
	 * This method must decrement lockCount, but not below zero.
	 * 
	 * @OSPProject Memory
	 */
	public void do_unlock() {

		// lock count ne sme da padne ispod nule
		if (this.getFrame().getLockCount() > 0) {
			this.getFrame().decrementLockCount();
		}

	}

}