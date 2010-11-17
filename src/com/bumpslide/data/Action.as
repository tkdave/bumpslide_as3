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
		private var _name:String="";
		
		public function Action(action:Function, priority:int=-1, name:String="") {
			_priority = priority;
			_action = action;
			_creationIndex = lastNum++;
			_name = name;
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
			return "[Action "+_creationIndex + " "+name+"]";
		}
		
		public function get creationIndex():int {
			return _creationIndex;
		}


		public function get name():String {
			return _name;
		}


		public function set name( name:String ):void {
			_name = name;
		}
	}
}
