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

		public function Container( layout:String = 'horizontal', spacing:Number=10 )
		{
			this.layout = layout;
			this.spacing = spacing;
			super();
		}


		override protected function addChildren():void
		{
			super.addChildren();

			addEventListener( Event.ADDED, handleChildAddedOrRemoved );
			addEventListener( Event.REMOVED, handleChildAddedOrRemoved );
			// addEventListener( Component.EVENT_DRAW, handleRedraw );
			addEventListener( Component.EVENT_SIZE_CHANGED, handleChildSizeChange );

			callLater( 100, invalidate );
		}


		private function handleChildAddedOrRemoved( event:Event ):void
		{
			invalidate();
		}


		private function handleChildSizeChange( event:UIEvent ):void
		{
			var child:DisplayObject = event.target as DisplayObject;
			if (child.parent == this) {
				// trace('[Container] handle child size change', event.target);
				event.stopPropagation();
				invalidate( VALID_SIZE );
				updateNow();
			}
		}

		override public function layoutChildren():void
		{
			var kids:Array = children;

			for each ( var child:DisplayObject in kids ) {
				child[ layout == Direction.HORIZONTAL ? 'x' : 'y' ] = 0;
			}

			switch( layout ) {
				case Direction.HORIZONTAL:
					Align.hbox( kids, spacing );
					break;
				case Direction.VERTICAL:
					Align.vbox( kids, spacing );
					break;
			}
			
			super.layoutChildren();
		}


		public function get layout():String {
			return _layout;
		}


		/**
		 * Layout direction ('horizontal' or 'vertical')
		 */
		[Inspectable(type="String",enumeration="horizontal,vertical")]
		public function set layout( layout:String ):void {
			_layout = layout;
			invalidate();
		}


		public function get spacing():Number {
			return _spacing;
		}


		[Inspectable]
		public function set spacing( spacing:Number ):void {
			_spacing = spacing;
			invalidate();
		}


		override public function get height():Number {
			return explicitHeight ? super.height : actualHeight;
		}


		override public function get width():Number {
			return explicitWidth ? super.width : actualWidth;
		}


		public function get backgroundVisible():Boolean {
			return _backgroundVisible;
		}


		public function set backgroundVisible( backgroundVisible:Boolean ):void {
			_backgroundVisible = backgroundVisible;
			invalidate();
		}
	}
}
