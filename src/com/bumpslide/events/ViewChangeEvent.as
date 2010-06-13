package com.bumpslide.events {
	import flash.events.Event;	

	/**
	 * Transtion In/Out Events
	 * 
	 * Note: These should not be bubbled if you want ot support hiearchical views
	 * 
	 * @author David Knape
	 */
	public class ViewChangeEvent extends Event {

		public static const TRANSITION_OUT:String = "transitionOut";
		public static const TRANSITION_IN:String = "transitionIn";
		
		public static const TRANSITION_OUT_COMPLETE:String = "transitionOutComplete";
		public static const TRANSITION_IN_COMPLETE:String = "transitionInComplete";
		
		public function ViewChangeEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
		}

		override public function clone():Event {
			return new ViewChangeEvent( type, bubbles, cancelable );
		}
	}
}
