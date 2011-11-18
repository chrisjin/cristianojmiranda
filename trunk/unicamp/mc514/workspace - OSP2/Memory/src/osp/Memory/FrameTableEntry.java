package osp.Memory;

/**
 The FrameTableEntry class contains information about a specific page
 frame of memory.

 @OSPProject Memory
 */
import osp.IFLModules.IflFrameTableEntry;

public class FrameTableEntry extends IflFrameTableEntry {

	/**
	 * The frame constructor. Must have
	 * 
	 * super(frameID)
	 * 
	 * as its first statement.
	 * 
	 * @OSPProject Memory
	 */
	public FrameTableEntry(int frameID) {
		super(frameID);

		System.out.println("\nConstrutor FrameTableEntry. frameID=" + frameID);

	}

}
