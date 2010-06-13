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
package com.bumpslide.data {
	
	import com.bumpslide.data.IPrioritizable;	

	/**
	 * A priority queue to manage prioritized data.
	 * The implementation is based on the heap structure.
	 *  
	 */
	public class PriorityQueue {
		
		private var _q:Array;
		
		/**
		 * Initializes a Queue
		 */
		public function PriorityQueue()
		{
			_q = new Array();
		}
		
		/**
		 * The front item or null if the heap is empty.
		 */
		public function peek():IPrioritizable
		{
			return _q[0];
		}
		
		
		/**
		 * Enqueues a prioritized item.
		 */
		public function enqueue(obj:IPrioritizable):void
		{
			_q.push( obj );
			_q.sortOn( ['priority','creationIndex'], [Array.NUMERIC, Array.NUMERIC]);
		}

		/**
		 * Dequeues and returns the front item.
		 * This is always the item with the highest priority.
		 * 
		 * @return The queue's front item or null if the heap is empty.
		 */
		public function dequeue():IPrioritizable
		{
			return _q.shift();
		}
		
		
		
		/**
		 * Removes an item.
		 * 
		 * @param obj The item to remove.
		 * @return True if removal succeeded, otherwise false.
		 */
		public function remove(obj:IPrioritizable):Boolean
		{
			var i:int = _q.indexOf(obj);
			if(i!=-1) {
				_q.splice(i, 1);	
				return true;
			}	
			return false;
		}
		
		/**
		 * @inheritDoc
		 */
		public function contains(obj:*):Boolean
		{
			var i:int = _q.indexOf(obj);
			if(i!=-1) {	
				return true;
			}	
			return false;
		}
		
		/**
		 * @inheritDoc
		 */
		public function clear():void
		{
			_q = new Array();
		}
				
		/**
		 * @inheritDoc
		 */
		public function get size():int
		{
			return _q.length;
		}
		
		/**
		 * @inheritDoc
		 */
		public function isEmpty():Boolean
		{
			return size==0;
		}
		 
		/**
		 * @inheritDoc
		 */
		public function toArray():Array
		{
			return _q.concat();
		}
		
		/**
		 * Prints out a string representing the current object.
		 * 
		 * @return A string representing the current object.
		 */
		public function toString():String
		{
			return "[PriorityQueue, size=" + size +"]";
		}
		
		/**
		 * Prints all elements (for debug/demo purposes only).
		 */
		public function dump():String
		{
			if (size == 0) return "PriorityQueue (empty)";
			
			var s:String = "PriorityQueue\n{\n";
			var k:int = size;
			for (var i:int = 0; i < k; i++) s += "\t" + _q[i] + "\n";
			
			s += "\n}";
			return s;
		}
		
		
		
    }
}
