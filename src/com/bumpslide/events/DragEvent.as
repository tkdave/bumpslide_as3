package com.bumpslide.events {
	import flash.geom.Point;	
	import flash.events.Event;
	
	/**
	 * Drag Event dispatched by the Bumpslide DragBehavior
	 * 
	 * @author David Knape
	 */
	public class DragEvent extends Event {

		public static var EVENT_DRAG_START:String = "bumpslideDragStart";		public static var EVENT_DRAG_MOVE:String = "bumpslideDragMove";		public static var EVENT_DRAG_STOP:String = "bumpslideDragStop";
		
		// location of drag target when drag was started		public var start:Point;
		
		// current location of drag target relative to drag start		public var delta:Point;
		
		// current location of drag target
		public var current:Point;
		
		// distance dragged on this move
		public var velocity:Point;
				
		public function DragEvent(type:String, sprite_start:Point, current_loc:Point, drag_velocity:Point=null) {
			super(type, true, true);
			start = sprite_start;
			current = current_loc!=null ? current_loc : start.clone();
			delta = current.subtract( start );
			velocity = drag_velocity;
		}
		
		
	}
}
