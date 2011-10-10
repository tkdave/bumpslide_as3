package com.bumpslide.command.robotlegs
{

	import com.bumpslide.command.Command;
	import com.bumpslide.command.CommandEvent;
	import com.bumpslide.ui.Label;
	import com.bumpslide.util.Delegate;

	/**
	 * Post message to startup log
	 *
	 * @author David Knape
	 */
	public class StartupMessage extends Command
	{

		[Inject(name='startupLogDisplay')]
		public var startupLogDisplay:Label;

		public var text:String = "";
		public var pause:uint = 200;
		
		override public function execute( event:CommandEvent = null ):void
		{
			if (event.data) {
				text = event.data as String;
			}

			startupLogDisplay.text += "\n" + text;
			startupLogDisplay.updateNow();

			Delegate.callLater( 10 + pause, super.execute, event );
		}
	}
}
