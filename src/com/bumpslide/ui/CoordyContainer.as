package com.bumpslide.ui 
{
	import com.somerandomdude.coordy.utils.LayoutTransitioner;
	import com.somerandomdude.coordy.layouts.twodee.Layout2d;

	import flash.display.DisplayObject;
	import flash.events.Event;

	/**
	 * Generic container to be used as HBox or Vbox in MXML
	 * 
	 * @author David Knape
	 */
	public class CoordyContainer extends Component 
	{		
		//protected var _layout:String = "horizontal";
		protected var _spacing:uint = 10;
		protected var _layout:Layout2d;

		
		public function CoordyContainer() {
			addEventListener( Event.ADDED, addedHandler );
			addEventListener( Event.REMOVED, removedHandler );
		}
		
		/**
		 * @private 
		 */
		protected function addedHandler(event:Event):void
		{
			var obj:DisplayObject = event.target as DisplayObject;
			if(layout==null || obj.parent!=this) {
				invalidate();
				return;
			}			
			if(!layout.linkExists(obj)) {
				layout.addToLayout( obj, false );
				invalidate();
			}
		}
		
		/**
		 * @private 
		 */	
		protected function removedHandler(event:Event):void
		{
			var obj:DisplayObject = event.target as DisplayObject;
			if(layout==null || obj.parent!=this) { 
				invalidate(); 
				return; 
			}			
			layout.removeNodeByLink(obj);
			invalidate();
		}

		
		override protected function draw():void {
			
			if(hasChanged('layout')) {
				//layout.nodes
			}
			
			if(layout) {				
				layout.width = width;
				layout.height = height;				
				layout.updateAndRender();
			}
			super.draw( );
		}

		
		public function get layout():Layout2d {
			return _layout;
		}
		
		
		public function set layout(new_layout:Layout2d):void {
			if(_layout==new_layout) return;
			if(_layout) {
				_layout.removeLinks();
				_layout.removeAllNodes();
				for each (var child:DisplayObject in children) {
					new_layout.addToLayout( child, false );
				}
			}
			_layout = layout;
			invalidate('layout');
		}

		
		
		
				
//		override protected function draw():void
//		{
//			for each ( var child:DisplayObject in children ) {
//				child.x = child.y = 0;				
//			}
//			
//			switch( layout ) {				
//				case Direction.HORIZONTAL:
//					Align.hbox( children, spacing );
//					break;
//				case Direction.VERTICAL:
//					Align.vbox( children, spacing );
//					break;
//			}			
//			super.draw();
//		}
		
//		
//		public function get layout():String {
//			return _layout;
//		}		
//		
//		/**
//		 * Layout direction
//		 */
//		[Inspectable(type="String",enumeration="horizontal,vertical")]
//		public function set layout(layout:String):void {
//			_layout = layout;
//			invalidate();
//		}		
		
		
//		public function get spacing():uint {
//			return _spacing;
//		}		
//		
//		public function set spacing(spacing:uint):void {
//			_spacing = spacing;
//			invalidate();
//		}

		
//		override public function get width():Number {
//			
//			return super.width;
//		}
	}
}