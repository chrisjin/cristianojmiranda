package osp.Memory;

import com.sun.org.apache.xalan.internal.xsltc.compiler.sym;

import osp.IFLModules.IflPageFaultHandler;
import osp.IFLModules.SystemEvent;
import osp.Threads.ThreadCB;

/**
 * The page fault handler is responsible for handling a page fault. If a swap in
 * or swap out operation is required, the page fault handler must request the
 * operation.
 * 
 * @OSPProject Memory
 */
public class PageFaultHandler extends IflPageFaultHandler {
	/**
	 * This method handles a page fault.
	 * 
	 * It must check and return if the page is valid,
	 * 
	 * It must check if the page is already being brought in by some other
	 * thread, i.e., if the page's has already pagefaulted (for instance, using
	 * getValidatingThread()). If that is the case, the thread must be suspended
	 * on that page.
	 * 
	 * If none of the above is true, a new frame must be chosen and reserved
	 * until the swap in of the requested page into this frame is complete.
	 * 
	 * Note that you have to make sure that the validating thread of a page is
	 * set correctly. To this end, you must set the page's validating thread
	 * using setValidatingThread() when a pagefault happens and you must set it
	 * back to null when the pagefault is over.
	 * 
	 * If a swap-out is necessary (because the chosen frame is dirty), the
	 * victim page must be dissasociated from the frame and marked invalid.
	 * After the swap-in, the frame must be marked clean. The swap-ins and
	 * swap-outs must are preformed using regular calls read() and write().
	 * 
	 * The student implementation should define additional methods, e.g, a
	 * method to search for an available frame.
	 * 
	 * Note: multiple threads might be waiting for completion of the page fault.
	 * The thread that initiated the pagefault would be waiting on the IORBs
	 * that are tasked to bring the page in (and to free the frame during the
	 * swapout). However, while pagefault is in progress, other threads might
	 * request the same page. Those threads won't cause another pagefault, of
	 * course, but they would enqueue themselves on the page (a page is also an
	 * Event!), waiting for the completion of the original pagefault. It is thus
	 * important to call notifyThreads() on the page at the end -- regardless of
	 * whether the pagefault succeeded in bringing the page in or not.
	 * 
	 * @param thread
	 *            the thread that requested a page fault
	 * @param referenceType
	 *            whether it is memory read or write
	 * @param page
	 *            the memory page
	 * @return SUCCESS is everything is fine; FAILURE if the thread dies while
	 *         waiting for swap in or swap out or if the page is already in
	 *         memory and no page fault was necessary (well, this shouldn't
	 *         happen, but...). In addition, if there is no frame that can be
	 *         allocated to satisfy the page fault, then it should return
	 *         NotEnoughMemory
	 * @OSPProject Memory
	 */
	public static int do_handlePageFault(ThreadCB thread, int referenceType,
			PageTableEntry page) {

		long timer = System.currentTimeMillis();
		System.out.println("\nINICIO metodo do_handlePageFault().");

		System.out.println("Page=" + page);

		System.out.println("Verificando se a pagina é valida...");
		if (page.isValid()) {
			ThreadCB.dispatch();
			System.out.println("FIM metodo do_handlePageFault(). "
					+ (System.currentTimeMillis() - timer) + "ms.");
			return FAILURE;
		}

		System.out.println("Setando thread na pagina...");
		page.setValidatingThread(thread);

		System.out.println("Obtendo o frame...");
		FrameTableEntry frame = null;
		for (int i = 0; i < MMU.getFrameTableSize(); ++i) {
			FrameTableEntry frm = MMU.getFrame(i);
			System.out.println("Frame=" + frm);
			if (!frm.isReferenced() && !frm.isReserved()) {
				System.out.println("Frame encontrado!");
				frame = frm;
				frm.setReserved(thread.getTask());
				break;
			}
		}

		if (frame == null) {

			System.out.println("Frame não encontrado!");

			page.setValidatingThread(null);
			ThreadCB.dispatch();

			System.out.println("FIM metodo do_handlePageFault(). "
					+ (System.currentTimeMillis() - timer) + "ms.");
			return NotEnoughMemory;
		}

		System.out.println("Montando o systemEvent....");
		SystemEvent systemEvent = new SystemEvent("PageFault");
		thread.suspend(systemEvent);

		if (frame.getPage() != null) {
			PageTableEntry oldPage = frame.getPage();
			if (frame.isDirty()) {

				thread.getTask().getSwapFile().write(frame.getID(), oldPage,
						thread);
				oldPage.setValid(false);
				frame.setDirty(false);

				if (thread.getStatus() == ThreadKill) {
					page.setValidatingThread(null);
					ThreadCB.dispatch();

					System.out.println("FIM metodo do_handlePageFault(). "
							+ (System.currentTimeMillis() - timer) + "ms.");
					return FAILURE;
				}
			}
			frame.setPage(null);
		}

		frame.setReferenced(false);

		thread.getTask().getSwapFile().read(page.getID(), page, thread);
		if (thread.getStatus() == ThreadKill) {
			frame.setDirty(false);
			ThreadCB.dispatch();

			System.out.println("FIM metodo do_handlePageFault(). "
					+ (System.currentTimeMillis() - timer) + "ms.");
			return FAILURE;
		}

		frame.setDirty(referenceType == MemoryWrite);
		frame.setPage(page);
		page.setValid(true);
		page.setValidatingThread(null);

		systemEvent.notifyThreads();
		page.notifyThreads();
		ThreadCB.dispatch();

		System.out.println("FIM metodo do_handlePageFault(). "
				+ (System.currentTimeMillis() - timer) + "ms.");
		return SUCCESS;
	}
}
