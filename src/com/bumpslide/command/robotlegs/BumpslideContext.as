package com.bumpslide.command.robotlegs
{

	import org.robotlegs.core.ICommandMap;
	import org.robotlegs.mvcs.Context;

	import flash.display.DisplayObjectContainer;

	/**
	 * Robotlegs context that enables support for Bumpslide command map and Bumpslide commands
	 *
	 * @author David Knape, http://bumpslide.com/
	 */
	public class BumpslideContext extends Context
	{

		public function BumpslideContext( contextView:DisplayObjectContainer = null, autoStartup:Boolean = true )
		{
			super( contextView, autoStartup );
		}


		/**
		 * Use custom Bumpslide-MVC CommandMap
		 */
		override protected function get commandMap():ICommandMap {
			return _commandMap || (_commandMap = new BumpslideCommandMap( eventDispatcher, injector.createChild(), reflector ));
		}
		
	}
}
