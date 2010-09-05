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

package com.bumpslide.ui.behavior 
{
	import com.bumpslide.util.GridLayout;

	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;

	/**
	 * Keyboard and mouse selection behavior for Grids
	 * 
	 * This class adds selection functionality to list components such as the 
	 * Grid and the combo box.
	 * 
	 * You will need to enable focus in your gridItem buttons. 
	 * 
	 * @see Button.focusStateEnabled
	 * 
	 * @author David Knape
	 */
	public class GridKeyboardFocusBehavior {

		// the grid we are managing
		protected var _gridLayout:GridLayout;

		// the current focus index (as far as we know)
		protected var _focusIndex:int = -1;

		// the display object to which we attach keyboard event listeners 
		protected var _keyboardScope:DisplayObject;

		// where we assign focus when focusIndex reaches -1
		protected var _previousFocusTarget:InteractiveObject;

		// the stage (retrieved from _keyboardScope), used for setting focus on things
		protected var _stage:Stage;

		/**
		 * Attaches focus behavior to a GridLayout instance
		 * 
		 * @param grid_layout  the grid we are managing
		 * @param keyboard_scope   where we attach keyboard event listeners (defaults to grid_layout.timeline)
		 * @param previous_focus_target  where we focus when focusIndex goes back to -1
		 */
		static public function init( grid_layout:GridLayout, keyboard_scope:DisplayObject = null, previous_focus_target:InteractiveObject = null ):GridKeyboardFocusBehavior{
			return new GridKeyboardFocusBehavior(grid_layout, keyboard_scope, previous_focus_target);	
		}

		/**
		 * Removes focus behavior from a grid
		 */
		static public function destroy(grid_layout:GridLayout):void {
			if(_grids[grid_layout] != null) (_grids[grid_layout] as GridKeyboardFocusBehavior).remove();
		}		

		/**
		 * Use the static init method instead of the contructor. 
		 * 
		 * @private
		 */
		public function GridKeyboardFocusBehavior( grid_layout:GridLayout, keyboard_scope:DisplayObject = null, previous_focus_target:InteractiveObject = null ) {
			
			_previousFocusTarget = previous_focus_target;// remove any existing behavior
			GridKeyboardFocusBehavior.destroy(grid_layout);
			
			_gridLayout = grid_layout;
			_keyboardScope = (keyboard_scope == null) ? grid_layout.timeline : keyboard_scope;
			
			if(_keyboardScope.stage) initKeyboardListener();
			else _keyboardScope.addEventListener(Event.ADDED_TO_STAGE, initKeyboardListener);
			
			_keyboardScope.addEventListener(Event.REMOVED_FROM_STAGE, removeKeyboardListener);
			
			_gridLayout.timeline.addEventListener( FocusEvent.MOUSE_FOCUS_CHANGE, handleFocusChange );
			_gridLayout.timeline.addEventListener( FocusEvent.KEY_FOCUS_CHANGE, handleFocusChange );
			
			_grids[grid_layout] = this;
		}
		
		/**
		 * remove event listeners, thus removing behavior
		 */
		public function remove():void {
			_keyboardScope.removeEventListener(Event.REMOVED_FROM_STAGE, removeKeyboardListener);
			_gridLayout.timeline.removeEventListener( FocusEvent.MOUSE_FOCUS_CHANGE, handleFocusChange );			_gridLayout.timeline.removeEventListener( FocusEvent.KEY_FOCUS_CHANGE, handleFocusChange );
			removeKeyboardListener();
			
		}
		
		/**
		 * If focus changes to an object that is not in the grid, reset focus index to -1
		 * but just reference the private _focusIndex, so we don't force focus on previousFocusTarget
		 */
		private function handleFocusChange(event:FocusEvent):void {
			if(event.relatedObject==null || event.relatedObject.parent!=_gridLayout.timeline) {
				
				trace('resetting focus index');
				_focusIndex = -1;
				
			}
		}


		/**
		 * The grid layout we are managing
		 */
		public function get gridLayout():GridLayout {
			return _gridLayout;
		}

		/**
		 * Current focus index
		 */
		public function get focusIndex():int {
			return _focusIndex;
		}

		/**
		 * Change the focus index
		 */
		public function set focusIndex(idx:int):void {
			
			
			if(gridLayout.dataProvider!=null && idx>=0) {
				
				// constrain
				_focusIndex = Math.max(0, Math.min(gridLayout.length - 1, idx));
				
				// don't tween, we need clips right now
				gridLayout.tweeningEnabled = false;
								
				// if selected index is not in the current view, scroll so that it is
				if(focusIndex < gridLayout.indexFirst) {
					gridLayout.scrollPosition = focusIndex;
				} else  if (focusIndex >= gridLayout.indexLast) {
					gridLayout.scrollPosition = focusIndex - gridLayout.offsetUnitsPerPage + 1;
				}
				// make sure we have a sprite to focus (force render)
				gridLayout.updateNow();	
				
				_stage.focus = gridLayout.getGridItemAt(focusIndex) as InteractiveObject;
					
			} else {				
				_focusIndex = -1;	
				_stage.focus = _previousFocusTarget;
			}
			
		}

		/**
		 * Handle key presses and change focus accordingly
		 */
		protected function handleKeyDown(event:KeyboardEvent):void {
			switch(event.keyCode) {
				case Keyboard.DOWN: 	
					focusDown(); 	
					break; 				case Keyboard.UP: 		
					focusUp(); 		
					break; 				case Keyboard.RIGHT:	
					focusRight(); 	
					break; 				case Keyboard.LEFT: 	
					focusLeft(); 	
					break; 
			}
		}

		protected function focusDown():void {
			if(gridLayout.orientation == GridLayout.VERTICAL) {
				focusIndex += gridLayout.columns;
			} else {
				focusIndex += 1;
			}
		}

		protected function focusUp():void {
			if(focusIndex==-1) return;
			if(gridLayout.orientation == GridLayout.VERTICAL) {
				focusIndex -= gridLayout.columns;
			} else {
				focusIndex -= 1;
			}
		}

		protected function focusRight():void {
			if(focusIndex==-1) return;
			if(gridLayout.orientation == GridLayout.VERTICAL) {
				focusIndex += 1;
			} else {
				focusIndex += gridLayout.rows;
			}
		}

		protected function focusLeft():void {
			if(focusIndex==-1) return;
			if(gridLayout.orientation == GridLayout.VERTICAL) {
				focusIndex -= 1;
			} else {
				focusIndex -= gridLayout.rows;
			}
		}
		

		private function initKeyboardListener(event:Event = null):void {
			_stage = _keyboardScope.stage;
			_keyboardScope.removeEventListener(Event.ADDED_TO_STAGE, initKeyboardListener);
			_keyboardScope.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
			
		}

		private function removeKeyboardListener(event:Event=null):void {
			_keyboardScope.removeEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
		}

		// track instances locally to aid in event management
		static private var _grids:Dictionary = new Dictionary(true);	}
}
