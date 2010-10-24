package com.bumpslide.command
{

	import org.robotlegs.core.IInjector;

	/**
	 * Robotlegs Friendly Command Queue 
	 * 
	 * Supports dependency injection into each command being run
	 *
	 * @author David Knape
	 */
	public class RLCommandQueue extends CommandQueue
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
