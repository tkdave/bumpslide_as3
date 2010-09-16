package com.bumpslide.ui 
{
	import com.bumpslide.events.UIEvent;
	import com.bumpslide.data.constant.Direction;
	import com.bumpslide.util.Align;

	import flash.display.DisplayObject;
	import flash.events.Event;

	/**
	 * Generic container to be used as HBox or Vbox in MXML
	 * 
	 * @author David Knape
	 */
	public class Container extends Component 
	{		
		protected var _layout:String = Direction.HORIZONTAL;

		protected var _spacing:Number = 10;

		private var _backgroundVisible:Boolean = false;
		
		public function Container() {
			//backgroundAlpha = 0;
			super();
		}


		
		override protected function addChildren():void
		{
			super.addChildren();
			
			addEventListener( Event.ADDED, handleChildAddedOrRemoved );
			addEventListener( Event.REMOVED, handleChildAddedOrRemoved );
			addEventListener( Component.EVENT_DRAW, handleRedraw );
			
			callLater( 100, invalidate );	
		}

		
		private function handleChildAddedOrRemoved(event:Event):void {
			if(event.target==boundsShape) return;
			invalidate();
		}

		
		private function handleRedraw(event:UIEvent):void {
			if(event.target.parent==this) updateNow();
		}

		
//		override protected function drawShape():void {
//			if(backgroundVisible) super.drawShape();
//		}

		protected function childFilter( item:*, index:int, array:Array ):Boolean {
			return item!=boundsShape;
		}
		
		override public function layoutChildren():void {
			
			var kids:Array = children.filter( childFilter );
			
			for each ( var child:DisplayObject in kids ) {
				child.x = child.y = 0;
			}
			
			switch( layout ) {				
				case Direction.HORIZONTAL:
					Align.hbox( kids, spacing );
					break;
				case Direction.VERTICAL:
					Align.vbox( kids, spacing );
					break;
			}			
			
		}

		
		
		public function get layout():String {
			return _layout;
		}		
		
		/**
		 * Layout direction
		 * 
		 * 
		 */
		[Inspectable(type="String",enumeration="horizontal,vertical")]
		public function set layout(layout:String):void {
			_layout = layout;
			invalidate();
		}		
		
		public function get spacing():Number {
			return _spacing;
		}		
		
		public function set spacing(spacing:Number):void {
			_spacing = spacing;
			invalidate();
		}
		
		override public function get height() : Number {
			return explicitHeight ? super.height : actualHeight;
		}
		
		override public function get width() : Number {
			return explicitWidth ? super.width : actualWidth;
		}
		
		
		public function get backgroundVisible():Boolean {
			return _backgroundVisible;
		}
		
		
		public function set backgroundVisible(backgroundVisible:Boolean):void {
			_backgroundVisible = backgroundVisible;
			invalidate();
		}
	}
}
