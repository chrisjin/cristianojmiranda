package osp.Memory;

/**
 The PageTable class represents the page table for a given task.
 A PageTable consists of an array of PageTableEntry objects.  This
 page table is of the non-inverted type.

 @OSPProject Memory
 */
import osp.IFLModules.IflPageTable;
import osp.Tasks.TaskCB;

public class PageTable extends IflPageTable {
	/**
	 * The page table constructor. Must call
	 * 
	 * super(ownerTask)
	 * 
	 * as its first statement.
	 * 
	 * @OSPProject Memory
	 */
	private int maxPages;

	public PageTable(TaskCB ownerTask) {
		super(ownerTask);

		maxPages = (int) Math.pow(2, MMU.getPageAddressBits());
		this.pages = new PageTableEntry[maxPages];

		for (int i = 0; i < maxPages; ++i) {
			this.pages[i] = new PageTableEntry(this, i);
		}
	}

	/**
	 * Frees up main memory occupied by the task. Then unreserves the freed
	 * pages, if necessary.
	 * 
	 * @OSPProject Memory
	 */
	public void do_deallocateMemory() {
		for (int i = 0; i < maxPages; ++i) {
			if (this.pages[i].isValid()) {
				if (this.pages[i].getFrame().isReserved())
					this.pages[i].getFrame().setUnreserved(this.getTask());

				this.pages[i].getFrame().setDirty(false);
				this.pages[i].getFrame().setReferenced(false);
				this.pages[i].getFrame().setPage(null);
			}
		}
	}
}