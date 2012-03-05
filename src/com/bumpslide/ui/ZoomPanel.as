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

	import com.bumpslide.ui.behavior.DragZoomBehavior;

	import flash.display.DisplayObject;
	import flash.events.MouseEvent;


	/**
	 * Provides pan and zoom functionality for 'zoomable' content
	 * 
	 * @author David Knape
	 */
	public class ZoomPanel extends Panel
	{

		public var zoomTweenEnabled:Boolean = true;
		public var panTweenEnabled:Boolean = true;

		public var dragZoomControl:DragZoomBehavior;

		protected var _dragZoomEnabled:Boolean = true;

		override protected function addChildren():void
		{
			super.addChildren();
			_holder.scrollRect = null;
			delayUpdate = false;
			addEventListener( MouseEvent.MOUSE_WHEEL, handleMouseWheel );
		}


		protected function handleMouseWheel( event:MouseEvent ):void
		{
			var n:Number = Math.round( event.delta / 2 );
			// tame that bitch
			if (n > 0) while (n--) zoomIn();
			else while (n++) zoomOut();
		}


		override protected function setContentSize( w:Number, h:Number ):void
		{
			if (zoomContent) {
				zoomContent.setSize( w, h );
			}
		}


		override public function set content( c:DisplayObject ):void {
			if (dragZoomControl) dragZoomControl.remove();

			var zoomableContent:ZoomableContent = new ZoomableContent();
			zoomableContent.content = c;

			super.content = zoomableContent;

			dragZoomEnabled = dragZoomEnabled;

			zoomableContent.updateNow();
		}


		public function get zoomContent():ZoomableContent {
			return content as ZoomableContent;
		}


		public function zoomIn():void
		{
			if (dragZoomControl) dragZoomControl.zoomIn();
		}


		public function zoomOut():void
		{
			if (dragZoomControl) dragZoomControl.zoomOut();
		}


		public function panTo( panX:Number, panY:Number ):void
		{
			if (dragZoomControl) dragZoomControl.panTo( panX, panY, panTweenEnabled );
		}


		public function panLeft( dist:Number = 64 ):void
		{
			if (dragZoomControl) dragZoomControl.panLeft( dist );
		}


		public function panRight( dist:Number = 64 ):void
		{
			if (dragZoomControl) dragZoomControl.panRight( dist );
		}


		public function panUp( dist:Number = 64 ):void
		{
			if (dragZoomControl) dragZoomControl.panUp( dist );
		}


		public function panDown( dist:Number = 64 ):void
		{
			if (dragZoomControl) dragZoomControl.panDown( dist );
		}


		public function get zoom():Number {
			if (zoomContent) return zoomContent.zoom;
			else return 1;
		}


		public function set zoom( zoom:Number ):void {
			if (dragZoomControl) dragZoomControl.zoomTo( zoom, zoomTweenEnabled );
		}


		public function refresh():void
		{
			if (zoomContent) zoomContent.refreshContentSize();
			invalidate();
		}


		public function reset():void
		{
			if (zoomContent) zoomContent.reset();
		}


		public function get dragZoomEnabled():Boolean {
			return _dragZoomEnabled;
		}


		public function set dragZoomEnabled( val:Boolean ):void {
			
			_dragZoomEnabled = val;
						
			if (content && val) {
				dragZoomControl = DragZoomBehavior.init( this, zoomContent );
			}
			
			if(!val && dragZoomControl) dragZoomControl.remove();
		}
	}
}
