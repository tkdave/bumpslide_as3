/**
 * This code is part of the Bumpslide Library by David Knape
 * http://bumpslide.com/
 * 
 * Copyright (c) 2006, 2007, 2008 by Bumpslide, Inc.
 * 
 * Released under the open-source MIT license.
 * http://www.opensource.org/licenses/mit-license.php
 * see LICENSE.txt for full license terms
 */ 
package com.bumpslide.util {
	import flash.events.TimerEvent;	
	import flash.events.Event;	
	import flash.events.KeyboardEvent;	
	import flash.events.MouseEvent;	
	import flash.display.InteractiveObject;	
	import flash.utils.Timer;	
	import flash.events.EventDispatcher;	

	/**
	 * Monitors mouse and keyboard activity to determine when a user is idle.
	 * 
	 * @author David Knape
	 */
	public class ActivityMonitor extends EventDispatcher {

		static public var EVENT_IDLE:String = "onAmericanIdle";
		private var _timeoutSecs:uint;
		private var _timer:Timer;
		private var _stage:InteractiveObject;
		private var debugEnabled:Boolean=false;

		function ActivityMonitor(stage:InteractiveObject, timeoutSeconds:uint = 90) {
			_timeoutSecs = timeoutSeconds;
			_timer = new Timer(_timeoutSecs*1000, 1);
			_timer.addEventListener(TimerEvent.TIMER, timeoutHandler);
			_stage = stage;
		}
		
		public function start():void {
			debug('start');
			_timer.start();
			_stage.addEventListener(MouseEvent.MOUSE_DOWN, uiEventHandler);
			_stage.addEventListener(MouseEvent.MOUSE_MOVE, uiEventHandler);			_stage.addEventListener(KeyboardEvent.KEY_DOWN, uiEventHandler);
		}

		public function stop():void {
			debug('stop');
			_timer.stop();
			_stage.removeEventListener(MouseEvent.MOUSE_DOWN, uiEventHandler);			_stage.removeEventListener(MouseEvent.MOUSE_MOVE, uiEventHandler);
			_stage.removeEventListener(KeyboardEvent.KEY_DOWN, uiEventHandler);
		}

		protected function uiEventHandler(e:Event = null):void {
			switch(e.type) {
				case MouseEvent.MOUSE_DOWN:
					debug('noticed mouse click');
					break;
				case MouseEvent.MOUSE_MOVE:
					debug('noticed mouse movement');
					break;
				case KeyboardEvent.KEY_DOWN:
					debug('noticed key press');
					break;
			}
			_timer.reset();
			_timer.start();
		}

		private function timeoutHandler(event:TimerEvent):void {
			debug('User has been idle for '+_timeoutSecs+' seconds.');
			_timer.stop();
			_timer.reset();
			dispatchEvent(new Event(EVENT_IDLE));
		}
		
		private function debug(s:String) : void  {
			if(debugEnabled) trace( '[IdleTracker] '+ s);
		}
	}
}
