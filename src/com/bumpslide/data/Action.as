/**
 * This code is part of the Bumpslide Library by David Knape
 * http://bcom.bumpslide.data.Action (c) 2006, 2007, 2008 by Bumpslide, Inc.
 * 
 * Released under the open-source MIT license.
 * http://www.opensource.org/licenses/mit-license.php
 * see LICENSE.txt for full license terms
 */ 
 
package com.bumpslide.data {
	
	import com.bumpslide.data.IPrioritizable;	

	/** 
	 * This is just an action and a priority as well as a creation index 
	 * used to preserve queue order in case priority is not used.
	 * 
	 * @author David Knape
	 */
	public class Action implements IPrioritizable {

		static private var lastNum:int =0;
				
		private var _action:Function;
		private var _priority:int;
		private var _creationIndex:int;
		
		public function Action(action:Function, priority:int=-1) {
			_priority = priority;
			_action = action;
			_creationIndex = lastNum++;
		}
		
		public function get action():Function {
			return _action;
		}
		
		public function set action(action:Function):void {
			_action = action;
		}
		
		public function execute() : void {
			action.call();
		}
		
		public function get priority():int {
			return _priority;
		}
		
		public function set priority(priority:int):void {
			_priority = priority;
		}
		
		public function toString() : String {
			return "[Action "+_creationIndex + "]";
		}
		
		public function get creationIndex():int {
			return _creationIndex;
		}
	}
}
