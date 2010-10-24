package com.bumpslide.command
{

	import com.bumpslide.data.Action;

	/**
	 * PendingCommand
	 *
	 * @author David Knape
	 */
	public class PendingCommand extends Action
	{
		
		public var command:ICommand;
		
		public function PendingCommand( command:ICommand, executeAction:Function, priority:uint=-1)
		{
			this.command = command;
			super( executeAction, priority);
		}


		override public function toString():String
		{
			return String( command );
		}


	}
}
