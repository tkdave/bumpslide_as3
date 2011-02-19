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

package com.bumpslide.data 
{
	import com.bumpslide.data.Action;
	import com.bumpslide.data.IPrioritizable;
	import com.bumpslide.data.PriorityQueue;
	import com.bumpslide.util.Delegate;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Timer;		


	[Event(name="complete", type="flash.events.Event")]

	/**
	 * Generic Multi-threaded, prioritized, queue
	 * 
	 * This class does not take into account the sometimes asynchronous nature of
	 * actions.  Thus, you need to call queue.remove( action ) once an action is 
	 * complete.  This will advance the queue. See the RequestQueue if you need 
	 * more robust async behavior, as it uses the IResponder interface and deals 
	 * with a more formal IRequest interface.
	 * 
	 * Note that this queue cam be 'multi-threaded', but we default to just a
	 * single concurrent action which is most useful for sequencing actions.
	 * 
	 * @author David Knape
	 */
	public class ActionQueue extends PriorityQueue implements IEventDispatcher 
	{

		// actions currently being run
		protected var _currentActions:Array;

		// max numbver of concurrently running actions
		protected var _threads:Number = 1;		

		// paused?
		protected var _paused:Boolean = false;

		protected var _complete:Boolean = false;

		protected var _runDelay:Timer;

		protected var _dispatcher:EventDispatcher;

		public var debugEnabled:Boolean = false;

		// delay before running each item
		public var runDelayMs:int = 10;

		
		public function ActionQueue() 
		{
			super();
			_currentActions = new Array();
			_dispatcher = new EventDispatcher(this);
		}

		
		/**
		 * Adds action to the queue and starts running actions
		 */
		override public function enqueue(action:IPrioritizable):void 
		{
			super.enqueue(action);			
			_complete = false;
			run();
		}
		
		
		override public function clear():void 
		{
			super.clear();
			_currentActions = new Array();
		}

		
		/**
		 * If found in the queue, action is removed.  If currently running, it 
		 * is removed from the current list and the queue is instructed to 
		 * continue to the next item. 
		 */
		override public function remove(action:IPrioritizable):Boolean 
		{
			if(action == null) {
				debug('cannot remove null action');
				return false;
			} else if(contains(action)) {
				// found in the queue, not yet running.  Just remove it.
				debug('removing pending action ' +action);
				return super.remove(action);	
			} else {
				var i:int;
				if((i = _currentActions.indexOf(action)) != -1) {
					debug('removing current action ' + action);
					_currentActions.splice(i, 1);	
					// load the next item
					run();
					return true;
				}	
				return false;			
			}
		}

		
		public function run():void 
		{
			debug('run');
			Delegate.cancel(_runDelay);
			_runDelay = Delegate.callLater(runDelayMs, doRun);
		}

		
		public function doRun():void 
		{			
			debug('doRun (paused='+paused+')');
			
			Delegate.cancel(_runDelay);
			
			if(paused) return;	
			
			//trace( dump() );
				
			//debug('Next (running=' + _currentActions.length + ', enqueued=' + size + ')');	
			while(_currentActions.length < threads && size > 0) {				
				var nextAction:Action = dequeue() as Action;
				debug('Running ' + nextAction);
				_currentActions.push(nextAction);
				nextAction.execute();					
			} 
			if(size == 0) {				
				if(!_complete) {
					debug('All Done.');
					_complete = true;
					// Note that this event fires when the final action is run.
					// If that action is asynchronous, it may not have actually
					// been completed yet.  ReqeustQueue should deal with this.
					dispatchEvent(new Event(Event.COMPLETE));
				}
			}
		}

		
		public function get paused():Boolean {
			return _paused;
		}

		
		public function set paused(v:Boolean):void {
			if(_paused == v) return;
			_paused = v;
			run();
		}

		
		protected function debug(s:String):void 
		{
			if(debugEnabled) trace('[ActionQueue] ' + s);
		}

		
		public function get threads():Number {
			return _threads;
		}

		
		public function set threads(threadCount:Number):void {
			_threads = threadCount;
		}

		
		public function get currentActions():Array {
			return _currentActions;
		}

		
		static public function Test():void 
		{
			var q:ActionQueue = new ActionQueue();		
			q.debugEnabled = false;
			
			var a1:Action = new Action(function ():void {  
				Delegate.callLater(200, function():void { 
					trace('first'); 
					q.remove(a1); 
				}); 
			}, 1);			var a2:Action = new Action(function ():void {  
				Delegate.callLater(200, function():void { 
					trace('second'); 
					q.remove(a2); 
				}); 
			}, 1);			var a3:Action = new Action(function ():void {  
				Delegate.callLater(200, function():void { 
					trace('third'); 
					q.remove(a3); 
				}); 
			}, 1);
				
			q.enqueue(a1);
			q.enqueue(a2);
			q.enqueue(a3);
		}

		
		// Let us dispatch some events
		public function dispatchEvent(event:Event):Boolean 
		{
			return _dispatcher.dispatchEvent(event);
		}

		
		public function hasEventListener(type:String):Boolean 
		{
			return _dispatcher.hasEventListener(type);
		}

		
		public function willTrigger(type:String):Boolean 
		{
			return _dispatcher.willTrigger(type);
		}

		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void 
		{
			_dispatcher.removeEventListener(type, listener, useCapture);
		}

		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void 
		{
			_dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
	}
}
