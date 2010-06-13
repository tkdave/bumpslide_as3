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
package com.bumpslide.util 
{
	import flash.ui.Keyboard;
	import flash.display.Stage;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;		

	/**
	 * Provides AS2-style isDown function.
	 * 
	 * @author David Knape
	 */
	public class KeyTracker extends EventDispatcher {

		private static var stage:Stage;
		private static var initialized:Boolean;
		private static var pressedKeys:Object;

		static public function init( stage:Stage ):void {
			if(KeyTracker.initialized) return;
			KeyTracker.stage = stage;
			KeyTracker.initialized = true;
			pressedKeys = new Object();
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyPressed, false, 999);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyReleased, false, 999);
		}
		
		public function cancel():void {
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyPressed);
			stage.removeEventListener(KeyboardEvent.KEY_UP, keyReleased);
			pressedKeys = new Object();
			KeyTracker.stage = null;
		}
		
		public static function isDown(keycode:uint):Boolean {
			return Boolean(keycode in pressedKeys);
		}	
		
		public static function isLetterDown(letter:String ):Boolean {
			return isDown( letter.toUpperCase().charCodeAt(0) ) || isDown( letter.toLowerCase().charCodeAt(0) );
		}
				
		static private function keyPressed(evt:KeyboardEvent):void {
			//trace('[KeyTracker] pressed key ' + evt.keyCode);
			pressedKeys[evt.keyCode] = true;
		}
		
		static private function keyReleased(evt:KeyboardEvent):void {
			delete pressedKeys[evt.keyCode];
		}		
	}
}
