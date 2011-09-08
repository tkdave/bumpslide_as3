package com.bumpslide.command.robotlegs
{

	import com.bumpslide.command.Command;
	import com.bumpslide.command.CommandEvent;

	import flash.desktop.NativeApplication;
	import flash.events.IEventDispatcher;

	/**
	 * Displays AIR app info (pulled from app xml) in the startup log display
	 *
	 * @author David Knape
	 */
	public class DisplayApplicationStartupInfo extends Command
	{
		[Inject]
		public var dispatcher:IEventDispatcher;
		
		override public function execute( event:CommandEvent = null ):void
		{
			var app:XML  = NativeApplication.nativeApplication.applicationDescriptor;
			var ns:Namespace = app.namespace();
			var msg:String = "Loading " + app.ns::name[0] + " version " + app.ns::versionNumber[0] +"\n\n";
			
			dispatcher.dispatchEvent( new StartupMessageEvent( msg ) );
			
			super.execute( event );
		}
			

	}
}
