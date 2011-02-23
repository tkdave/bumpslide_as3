package com.bumpslide.command
{

	import com.bumpslide.util.Delegate;

	import flash.utils.Timer;

	/**
	 * Pause Command
	 * 
	 * Useful in MXML startup sequence
	 * 
	 * Example: 
	 *   
	 *   <command:Pause time="500" />
	 *
	 * @author David Knape
	 */
	public class Pause extends Command
	{

		public var time:Number = 1000;

		private var delay:Timer;
		
		override public function execute( event:CommandEvent = null ):void
		{
			if (event.data is Number) {
				time = event.data as Number;
			}

			delay = Delegate.callLater( time, notifyComplete );
		}


		override public function cancel():void
		{
			Delegate.cancel( delay );
			super.cancel();
		}

	}
}
