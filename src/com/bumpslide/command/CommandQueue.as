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

package com.bumpslide.command{	import com.bumpslide.data.ActionQueue;	import com.bumpslide.net.IResponder;	import com.bumpslide.util.Delegate;	import flash.events.Event;	import flash.events.EventDispatcher;	
	/**
	 * In MXML, all commands are passed to the commands setter which is an array
	 */
	[DefaultProperty(name='commands')]
		/**	 * Macro/Sequence Command	 * 	 * - manages a queue of commands	 * - implements ICommand interface to facilitate nesting of sequences	 * 	 * This is useful for things like application startup where you really 	 * just want to run a bunch of commands in sequence, but you want to 	 * make sure each one finishes before the next is run.
	 * 
	 * Updated to support MXML.	 *  	 * @author David Knape	 */	public class CommandQueue extends EventDispatcher implements ICommand {		public var debugEnabled:Boolean = false;				protected var _queue:ActionQueue;		protected var _actions:Array;		protected var _callback:IResponder;				public function CommandQueue() {			_queue = new ActionQueue();			_queue.paused = true;			_actions = new Array();		}
		/**
		 * Add a command class or instance to the queue
		 */		public function add( commandOrClass:*, dataOrEvent:*=null, priority:int=1):PendingCommand {						var e:CommandEvent = dataOrEvent is CommandEvent ? dataOrEvent as CommandEvent : new CommandEvent( "enqueuedEvent", dataOrEvent );
			
			var command:ICommand;
			
			if(commandOrClass is Class) {
				command = new commandOrClass() as ICommand;
			} else {
				command = commandOrClass as ICommand;
				
				// make sure command instances are unique
				//command = ObjectUtil.clone( command ) as ICommand;
			}
			
			if(command==null) {
				throw new Error('Attempt to add an invalid command. Commands must implement ICommand.');
			}
															// create action//			var f:Function = Delegate.create( doExecute, command, e );//			var a:Action=new Action(f, priority);//			
			var action:PendingCommand = new PendingCommand( command, Delegate.create( doExecute, command, e ), priority );
						// save reference to action so it can be cancelled using the command as a key			_actions.push( action );
			 			debug('Enqueueing Action ' + action );			_queue.enqueue(action);			
			
			// return reference to the command that was added			return action;		}				protected function doExecute( command:ICommand, event:CommandEvent=null ):void {			command.addEventListener( Event.COMPLETE, handleCommandComplete );
			command.execute( event );		}		/**		 * Cancel any pending calls to a specific command class		 */
		public function remove( pending:PendingCommand ):void
		{	
			var current:PendingCommand = _queue.currentActions[0];
			
			pending.command.cancel();
			
			if(pending==current) {
				advance();
			} else {
				_queue.remove(pending);
			}		}				/**		 * Start the queue		 */		public function execute(event:CommandEvent=null):void {			debug('Running Sequence' ); 			if(_queue.paused) _queue.paused = false;			_callback = event;		}				/**		 * remove all pending commands, and cancel active ones		 */
		public function cancel():void
		{
			for each (var a:PendingCommand in _queue.currentActions) {
				a.command.cancel();
			}						_queue.clear();		}
				
		/**
		 * When each command is completed, advance to the next
		 */		private function handleCommandComplete(event:Event):void {			advance();		}		
		/**
		 * Remove currently running command from the queue and check to see if we are done
		 */		private function advance():void {			
			debug('advance()');			
			var current:PendingCommand = _queue.currentActions[0];
			
			if(current!=null) {
				_queue.remove( current );
				current.command.removeEventListener( Event.COMPLETE, handleCommandComplete );
			} else {
				trace('current action is null?');
			}
									if(size==0) {				debug('Sequence Complete ');				dispatchEvent( new Event( Event.COMPLETE ) );								// call callback result				if(callback) callback.result(null);			}		}		public function get size():int {			return _queue.size;		}				public function get callback():IResponder {			return _callback;		}				public function set callback(callback:IResponder):void {			_callback = callback;		}				protected function debug(s:*) : void {			if(debugEnabled) trace( this + ' ' + s );		}				override public function toString():String {			return "[CommandQueue]";		}
		
		/**
		 * Setter used when defining queues in MXML
		 */
		public function set commands( cmds:Array ):void {
			for each ( var cmd:* in cmds ) {
				//trace('adding ' + cmd );
				add( cmd );
			}
		}	}}