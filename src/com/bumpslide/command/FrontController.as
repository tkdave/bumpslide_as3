/**
 * This code is part of the Bumpslide Library maintained by David Knape
 * Fork me at http://github.com/tkdave/bumpslide_as3
 * 
 * Copyright (c) 2010 by Bumpslide, Inc. 
 * http://www.bumpslide.com/
 *
 * This code is released under the open-source MIT license.
 * See LICENSE.txt for full license terms.
 * More info at http://www.opensource.org/licenses/mit-license.php
 */
package com.bumpslide.command
{

	import flash.utils.Dictionary;
	[DefaultProperty(name='mappedCommands')]
		/**	 * A base class for an application specific front controller.	 * 	 * This is a Cairngorm Front Controller with flex dependencies removed.	 */	public class FrontController {		protected var commands:Dictionary=new Dictionary();		/**		 * Registers a ICommand class with the Front Controller, against an event name		 * and listens for events with that name.		 */     		public function addCommand( commandName:String, commandRef:Class, useWeakReference:Boolean=true ):void {			if( commands[ commandName ] != null ) {				throw new Error("Command already registered: " + commandName);			}			commands[ commandName ] = commandRef;			CommandEventDispatcher.getInstance().addEventListener(commandName, executeCommand, false, 0, useWeakReference);		}		/**		 * Deregisters an ICommand class with the given event name from the Front Controller		 */     		public function removeCommand( commandName:String ):void {			if( commands[ commandName ] === null) {				throw new Error("Unable to remove command, not registered: " + commandName);  			}			CommandEventDispatcher.getInstance().removeEventListener(commandName, executeCommand);			commands[ commandName ] = null;			delete commands[ commandName ]; 		}		/**		 * Executes the command		 */  		protected function executeCommand( event:CommandEvent ):void {			var commandClass:Class=getCommand(event.type);			var commandToExecute:ICommand=new commandClass();			commandToExecute.execute(event);		}		/**		 * Returns the command class registered with the command name. 		 */		protected function getCommand( commandName:String ):Class {			var command:Class=commands[ commandName ];         			if ( command == null ) {				throw new Error("Command not found: " + commandName);			}			return command;		}  
		
		public function set mappedCommands( a:Array ):void {
			for each (var map:* in a) {
				if( map is MapCommand) {
					var m:MapCommand = (map as MapCommand);
					addCommand( m.name,  m.commandClass );
				}
			}
		}  
		
		  	}   }