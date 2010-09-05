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

package com.bumpslide.net {
	import com.bumpslide.data.Action;	import com.bumpslide.data.ActionQueue;	import com.bumpslide.util.Delegate;		import flash.display.Loader;	import flash.events.Event;	import flash.events.EventDispatcher;	import flash.net.URLRequest;	import flash.system.LoaderContext;	import flash.utils.Dictionary;	
	/**
	 * Prioritized loading queue for display object laoders
	 * 
	 * Deprecated.  
	 * Use RequestQueue with LoaderRequests instead for more features.
	 * 
	 * @author David Knape
	 */
	public class LoaderQueue extends EventDispatcher {

		protected var _queue:ActionQueue;
		protected var _actions:Dictionary;
		protected var _handlers:Dictionary;
		
		private static const DEFAULT_THREAD_COUNT:uint = 4;

		public function LoaderQueue() {
			_queue = new ActionQueue();
			_queue.threads = DEFAULT_THREAD_COUNT;
			_actions = new Dictionary(true);			_handlers = new Dictionary(true);
			_queue.addEventListener(Event.COMPLETE, handleQueueComplete);
		}
		
		// forward the Event.COMPLETE event from the ActionQueue
		protected function handleQueueComplete(event:Event):void {
			dispatchEvent( event );
		}

		public function clear() : void {
			for( var loader:Object in _actions) {
				cancel(loader as Loader);
			}
			_queue.clear();
		}
		public function load( url:String, loader:Loader, priority:Number=1, context:LoaderContext=null ):void {
			
			// kill pending loads on this loader
			if(_actions[loader]) cancel(loader);
			
			// create action
			if(context == null) context = new LoaderContext(true);
			var f:Function=Delegate.create(loader.load, new URLRequest(url), context);
			var a:Action=new Action(f, priority);
			
			// save reference to action so it can be cancelled using the loader as a key
			_actions[loader] = a; 
			_handlers[loader] = new LoaderInfoEventHandler( loader, this );
			_queue.enqueue(a);
		}
		
		
		public function cancel( loader:Loader ):void {
			if(loader == null) return;	
			try { loader.close(); } catch ( e:Error ) {}
            try { loader.unload(); /* trace('unloaded');*/ } catch ( e2:Error ) {}    
            try { 
            	// in case content is a swf, and we have FP10, unload and stop
            	if(loader['unloadAndStop'] is Function) {
            		(loader['unloadAndStop'] as Function).call( loader );
           		} 
            } catch (e3:Error) {}
                    		
			finish(loader);
		}

		public function finish( loader:Loader ):void {
			if(loader == null) return;
			var a:Action=_actions[loader];
			if(a != null) {				
				_queue.remove(a);
			}
			delete _actions[loader];
			if(_handlers[loader]) {
				LoaderInfoEventHandler(_handlers[loader]).removeEventListeners(); 
			}
			delete _handlers[loader];
			
		}
		
		public function get threads():uint {
			return _queue.threads;
		}
		
		/**
		 * Number of simultaneous connections
		 */
		public function set threads(threads:uint):void {
			_queue.threads = threads;
		}
		
		/**
		 * Number of items in the queue
		 */
		public function get size():uint {
			return _queue.size;
		}
		
		/**
		 * The action queue
		 */
		public function get queue():ActionQueue {
			return _queue;
		}
	}
}

import com.bumpslide.net.LoaderQueue;import flash.display.Loader;import flash.events.Event;import flash.events.IOErrorEvent;import flash.events.SecurityErrorEvent;
class LoaderInfoEventHandler {
	
	public var loader:Loader;
	private var queue:LoaderQueue;

	public function LoaderInfoEventHandler(l:Loader, q:LoaderQueue) {
		loader = l;
		queue = q;
		
		// add event listeners
		loader.contentLoaderInfo.addEventListener(Event.INIT, handleLoaderInfoEvent, false, 0, true);
		loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, handleLoaderInfoEvent, false, 0, true);
		loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleLoaderInfoEvent, false, 0, true);
	}

	public function handleLoaderInfoEvent(event:Event):void {
		//trace('Loader Info Event: ' + event.type);
		queue.finish(loader);
	}
	
	public function removeEventListeners() : void {
		//trace( 'removing event listeners from queued item');
		loader.contentLoaderInfo.removeEventListener(Event.INIT, handleLoaderInfoEvent);
		loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, handleLoaderInfoEvent);
		loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, handleLoaderInfoEvent);
	}
}
