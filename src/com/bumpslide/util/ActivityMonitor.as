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
		public var debugEnabled:Boolean=false;
		
		public var timeStart:Number;
		public var timeEnd:Number;

		function ActivityMonitor(stage:InteractiveObject, timeoutSeconds:uint = 90) {
			_timeoutSecs = timeoutSeconds;
			_timer = new Timer(_timeoutSecs*1000, 1);
			_timer.addEventListener(TimerEvent.TIMER, timeoutHandler);
			_stage = stage;
		}
		
		public function start():void {
			debug('start');
			timeStart = new Date().time;
			_timer.reset();
			_timer.start();
			_stage.addEventListener(MouseEvent.MOUSE_UP, uiEventHandler);
			_stage.addEventListener(MouseEvent.MOUSE_DOWN, uiEventHandler);
			_stage.addEventListener(MouseEvent.MOUSE_MOVE, uiEventHandler);			_stage.addEventListener(KeyboardEvent.KEY_UP, uiEventHandler);
			_stage.addEventListener(KeyboardEvent.KEY_DOWN, uiEventHandler);
		}

		public function stop():void {
			debug('stop');
			_timer.stop();
			_stage.removeEventListener(MouseEvent.MOUSE_UP, uiEventHandler);
			_stage.removeEventListener(MouseEvent.MOUSE_DOWN, uiEventHandler);			_stage.removeEventListener(MouseEvent.MOUSE_MOVE, uiEventHandler);
			_stage.removeEventListener(KeyboardEvent.KEY_UP, uiEventHandler);
			_stage.removeEventListener(KeyboardEvent.KEY_DOWN, uiEventHandler);
		}

		protected function uiEventHandler(e:Event = null):void {
			debug('noticed event: ' + e.type );
			_timer.reset();
			_timer.start();
		
			// update session end time every time 	
			timeEnd = new Date().time;
		}
		
		

		private function timeoutHandler(event:TimerEvent):void {
			debug('User has been idle for '+_timeoutSecs+' seconds.');
			_timer.stop();
			_timer.reset();
			
			// use timeout as final ending time
			//timeEnd = new Date().time;
			
			dispatchEvent(new Event(EVENT_IDLE));
		}
		
		/**
		 * Time spent interacting with the display in milliseconds
		 */
		public function getTimeSpent():Number {
			return timeEnd - timeStart;
		}
		
		private function debug(s:String) : void  {
			if(debugEnabled) trace( '[IdleTracker] '+ s);
		}
	}
}
