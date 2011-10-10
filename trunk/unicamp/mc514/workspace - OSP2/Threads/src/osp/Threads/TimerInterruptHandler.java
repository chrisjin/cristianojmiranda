package osp.Threads;

import osp.IFLModules.IflTimerInterruptHandler;

/**
 * The timer interrupt handler. This class is called upon to handle timer
 * interrupts.
 * 
 * @OSPProject Threads
 */
public class TimerInterruptHandler extends IflTimerInterruptHandler {
	/**
	 * This basically only needs to reset the times and dispatch another
	 * process.
	 * 
	 * @OSPProject Threads
	 */
	public void do_handleInterrupt() {

		System.out.println("\n----------------");
		System.out.println("handleInterrupt!");
		System.out.println("----------------\n");

		ThreadCB.dispatch();
	}

}
