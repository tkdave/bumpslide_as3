package com.bumpslide.command.robotlegs
{
	import com.bumpslide.command.Command;
	import com.bumpslide.command.CommandEvent;
	import com.bumpslide.tween.FTween;
	import com.bumpslide.ui.Label;

	import org.robotlegs.core.IInjector;

	/**
	 * Hide the startup log created by the InitStartupLog command
	 *
	 * @author David Knape, http://bumpslide.com/
	 */
	public class HideStartupLog extends Command
	{

		[Inject]
		public var injector:IInjector;
		
		[Inject(name='startupLogDisplay')]
		public var label:Label;
		
		override public function execute( event:CommandEvent = null ):void
		{
			if(label) FTween.fadeOut( label, 500, .3, notifyComplete );
			else notifyComplete();
		}
		
		
		override public function notifyComplete( data:Object = null ):void
		{
			if(label && label.parent && label.parent.contains(label)) {
				label.parent.removeChild( label );
			}
			
			injector.unmap( Label, 'startupLogDisplay');
				
			super.notifyComplete( data );
		}
		
	}
}
