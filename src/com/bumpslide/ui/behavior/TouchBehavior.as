package com.bumpslide.ui.behavior
{

	import flash.display.InteractiveObject;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;

	/**
	 * TouchBehavior
	 *
	 * @author David Knape, http://bumpslide.com/
	 */
	public class TouchBehavior
	{
		
		// track instances locally to aid in event management
		static private var _targets:Dictionary = new Dictionary(true);
		
		public var target:InteractiveObject;
		
		protected var _enabled:Boolean = true;
		
		
		private var useCapture:Boolean = false;
		
		public var touchPoints:Dictionary;
		
		
		static public function init( touch_target:InteractiveObject, use_capture:Boolean = false ):TouchBehavior {
			return new TouchBehavior(touch_target, use_capture);	
		}

		static public function destroy(touch_target:InteractiveObject):void {
			if(_targets[touch_target] != null) (_targets[touch_target] as DragBehavior).remove();
		}		

	
		public function TouchBehavior( touch_target:InteractiveObject, use_capture:Boolean = false ) 
		{		
			TouchBehavior.destroy(touch_target);			
			target = touch_target;
			useCapture = use_capture;
			_targets[target] = this;	
			
			touchPoints = new Dictionary();
			
			target.addEventListener( TouchEvent.TOUCH_BEGIN, onTouchBegin, useCapture );
			target.addEventListener( TouchEvent.TOUCH_MOVE, onTouchMove, useCapture );
			target.addEventListener( TouchEvent.TOUCH_END, onTouchEnd, useCapture );		
			
		}

		/**
		 * removes event listeners, thus removing behavior
		 */
		public function remove():void {
			
			
			for(var id:String in touchPoints) {
				delete touchPoints[id];
			}			
						
			touchPoints = null;			
			
			target.removeEventListener( TouchEvent.TOUCH_BEGIN, onTouchBegin, useCapture );
			target.removeEventListener( TouchEvent.TOUCH_MOVE, onTouchMove, useCapture );
			target.removeEventListener( TouchEvent.TOUCH_END, onTouchEnd, useCapture );
			
			delete _targets[target];
		}
		
		
		protected function init():void {
			target.addEventListener( TouchEvent.TOUCH_BEGIN, onTouchBegin );
			target.addEventListener( TouchEvent.TOUCH_MOVE, onTouchMove );
			target.addEventListener( TouchEvent.TOUCH_END, onTouchEnd );			
		}

		private function onTouchBegin( event:TouchEvent ):void
		{
			touchPoints[event.touchPointID] = new Point( event.localX, event.localY );
		}
		
		private function onTouchMove( event:TouchEvent ):void
		{
			touchPoints[event.touchPointID] = new Point( event.localX, event.localY );			
		}

		private function onTouchEnd( event:TouchEvent ):void
		{			
			delete touchPoints[event.touchPointID];			
		}
	}
}
