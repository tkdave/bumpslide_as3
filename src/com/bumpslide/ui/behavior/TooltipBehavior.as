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

package com.bumpslide.ui.behavior {	import com.bumpslide.events.UIEvent;
	import com.bumpslide.util.Delegate;
	
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	/**	 * Tooltip Behavior	 * 	 * Initialize with a target and a handler for hiding and showing the toolip.	 * 	 * @author David Knape	 */	public class TooltipBehavior extends EventDispatcher {					/**		 * Create a new tooltip Behavior		 */		function TooltipBehavior(target:InteractiveObject, showHandler:Function, hideHandler:Function, initialDelay:int=500 ) {			_target = target;			_initialDelay = initialDelay;			_showHandler = showHandler;			_hideHandler = hideHandler;						// kill existing behavior if found to avoid duplicate listeners			if(_buttons[target]!=null) (_buttons[target] as RepeaterButtonBehavior).remove();						// add ourself to the registry			_buttons[target] = this;						// add mouse event listeners to target			_target.addEventListener( MouseEvent.ROLL_OVER, onRollOver, false, 0, true);			_target.addEventListener( MouseEvent.ROLL_OUT, onRollOut, false, 0, true);		}				/**		 * removes event listeners, thus removing behavior		 */		public function remove() : void {			_target.removeEventListener( MouseEvent.ROLL_OVER, onRollOver);			_target.removeEventListener( MouseEvent.ROLL_OUT, onRollOut);				_showHandler = null;			_hideHandler = null;			delete _buttons[target];		}				/**		 * the button to which this behavior has been applied		 */				public function get target () : InteractiveObject {			return _target;		}
						protected function onRollOver(e:MouseEvent):void {			Delegate.cancel( _delayTimer );			_delayTimer = Delegate.callLater( _initialDelay, _showHandler);			}				protected function onRollOut(e:MouseEvent):void {			Delegate.cancel( _delayTimer );			_hideHandler();		}						protected var _target:InteractiveObject;		protected var _delayTimer:Timer;		protected var _initialDelay:int=500;		protected var _showHandler:Function;		protected var _hideHandler:Function;								// track instances locally to aid in event management		static private var _buttons:Dictionary = new Dictionary(true);			}}