package com.bumpslide.command.robotlegs
{

	import com.bumpslide.command.CommandEvent;
	import com.bumpslide.command.ICommand;
	import org.robotlegs.base.CommandMap;
	import org.robotlegs.core.IInjector;
	import org.robotlegs.core.IReflector;

	import flash.events.IEventDispatcher;

	/**
	 * Robotlegs command map that support bumpslide MVC commands
	 *
	 * @author David Knape
	 */
	public class BumpslideCommandMap extends CommandMap
	{

		public function BumpslideCommandMap( eventDispatcher:IEventDispatcher, injector:IInjector, reflector:IReflector )
		{
			super( eventDispatcher, injector, reflector );
		}


		/**
		 * @inheritDoc
		 */
		override public function execute( commandClass:Class, payload:Object = null, payloadClass:Class = null, named:String = '' ):void
		{
			verifyCommandClass( commandClass );

			if (payload != null || payloadClass != null) {
				payloadClass ||= reflector.getClass( payload );
				injector.mapValue( payloadClass, payload, named );
			}

			var command:Object = injector.instantiate( commandClass );

			if (payload !== null || payloadClass != null)
				injector.unmap( payloadClass, named );

			if(command is ICommand && payload is CommandEvent) {
				var bumpslide_command:ICommand = command as ICommand;
				bumpslide_command.execute( payload as CommandEvent );
			} else {
				command.execute();
			}
		}
	}
}
