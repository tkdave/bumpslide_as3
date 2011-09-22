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

	import com.bumpslide.data.constant.Direction;
	import com.bumpslide.events.DragEvent;
	import com.bumpslide.ui.IScrollable;

	import flash.display.InteractiveObject;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;

	/**
	 * DragScrollBehavior
	 * 
	 * When attached to a scrollTarget of type IScrollable, it allows this content to be scrolled by dragging.
	 * 
	 * @author David Knape
	 */
	public class DragScrollBehavior extends EventDispatcher
	{			
		// track instances locally to aid in event management
		static private var _targets:Dictionary = new Dictionary(true);
		
		private var dragTarget:InteractiveObject;
		private var scrollableContent:IScrollable;
		private var scrollStart:Number;
		
		public var tweenEaseFactor:Number  = .15;
		public var tweenUpdateDelay:Number = 30;

		public var tweenEnabled:Boolean = false;

		private var dragBehavior:DragBehavior;

		/**
		 * Attaches behavior to a button
		 */
		static public function init( drag_target:InteractiveObject, scrollable_content:IScrollable ):DragScrollBehavior {
			return new DragScrollBehavior( drag_target, scrollable_content);	
		}
		

		/**
		 * Removes behavior from a button
		 */
		static public function destroy(target:InteractiveObject) : void {
			if(_targets[target]!=null) (_targets[target] as DragZoomBehavior).remove();
		}		
		
		/**
		 * Adds drag and zoom behavior to a display object and zoomable content
		 */
		function DragScrollBehavior( drag_target:InteractiveObject, scrollable_content:IScrollable) {		
			
			DragScrollBehavior.destroy( drag_target );
			
			dragTarget = drag_target;
			scrollableContent = scrollable_content;
		
			_targets[dragTarget] = this;
			
			dragBehavior = DragBehavior.init( drag_target, null, false);
			
			drag_target.addEventListener( DragEvent.EVENT_DRAG_START, handleDragStart);
			drag_target.addEventListener( DragEvent.EVENT_DRAG_MOVE, handleDragMove);
			drag_target.addEventListener( DragEvent.EVENT_DRAG_STOP, handleDragStop);
		}



		/**
		 * removes event listeners, thus removing behavior
		 */
		public function remove() : void {	
			dragBehavior.remove();
			dragBehavior = null;			
			delete _targets[dragTarget];
		}
		
		private function handleDragStart(event:DragEvent):void {
			if(event.target!=event.currentTarget) return;
			scrollStart = scrollableContent.scrollPosition;
		}

		private function handleDragMove(event:DragEvent):void {
			if(event.target!=event.currentTarget) return;
			var delta:Number = scrollableContent.orientation==Direction.HORIZONTAL ? event.delta.x : event.delta.y;			
			scrollableContent.scrollPosition = scrollStart - delta / scrollableContent.pixelsPerUnit;
		}
		
		
		private function handleDragStop( event:DragEvent ):void
		{
		}
		

	}
}
		