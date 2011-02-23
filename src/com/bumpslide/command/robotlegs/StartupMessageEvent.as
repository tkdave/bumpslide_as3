package com.bumpslide.command.robotlegs
{

	import flash.events.Event;
	import com.bumpslide.command.CommandEvent;

	/**
	 * Log a message to the startup log
	 *
	 * @author David Knape, http://bumpslide.com/
	 */
	public class StartupMessageEvent extends CommandEvent
	{
		
		static public const LOG_MESSAGE:String = "startupLogMessage";

		public function StartupMessageEvent(message:String)
		{
			super(LOG_MESSAGE, message, resultHandler, faultHandler );
		}
		
		public function get message():String {
			return data as String;
		}
		
		
		override public function clone():Event
		{
			return new StartupMessageEvent(message);
		}
		
	}
}
