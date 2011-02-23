package com.bumpslide.command.robotlegs
{

	import com.bumpslide.command.CommandEvent;
	import com.bumpslide.command.CommandQueue;
	import com.bumpslide.command.ICommand;

	import org.robotlegs.core.IInjector;

	/**
	 * Robotlegs-friendly Command Queue 
	 * 
	 * Supports Dependency Injection into each command being run.
	 *
	 * This class can be used in MXML or Actionscript.
	 * 
	 * @author David Knape
	 */
	public class CommandSequence extends CommandQueue
	{

		[Inject]
		public var injector:IInjector;

		// inject dependencies just before we execute the command
		override protected function doExecute( command:ICommand, event:CommandEvent = null ):void
		{
			debug( 'Running command ' + command );
			injector.injectInto( command );
			super.doExecute( command, event );
		}
	}
}
