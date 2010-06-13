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
 
package com.bumpslide.ui {
	import com.bumpslide.ui.Component;

	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.geom.Rectangle;		

	/**
	 * @author David Knape
	 */
	public class ZoomableContent extends Component implements IZoomable {

		// the content we are zooming/panning
		protected var _content:DisplayObject;
		// native height/width of content at 100%
		protected var _contentWidth:Number;		protected var _contentHeight:Number;
		// internal pan/zoom state
		protected var _zoom:Number = 1;
		protected var _panX:Number = 0;
		protected var _panY:Number = 0;
		private var viewPort:Rectangle;

		/**
		 * Cache as bitmap to improve performance with scrollRect
		 */
		override protected function addChildren():void {
			//cacheAsBitmap = true;
			viewPort = new Rectangle();
		}

		/**
		 * Reset to defaults
		 */
		public function reset():void {
			panX = 0; 
			panY = 0;
			zoom = 1;
		}	

		/**
		 * Since content is behind a scrollRect, we can't get it's actual size.
		 * This function yanks it off the display list, measures it, and puts it back
		 */
		public function refreshContentSize():void {
			if(content) {				
				if(contains(content)) removeChild(content);
				content.visible = true;
				content.scaleX = content.scaleY = 1;
				_contentWidth = content.width;
				_contentHeight = content.height;
				//trace('_contentWidth: ' + (_contentWidth));
				
				addChild(content);
			}
			invalidate();
		}

		override protected function draw():void {
			if(!content) return;	
					
			content.scaleX = content.scaleY = zoom; //Math.round( zoom / .1 ) * .1; 
			//trace('[ZoomableContent] draw() scale = ' + content.scaleX);
			
			viewPort.x = (_contentWidth * zoom - width) / 2 + panX * zoom ;
			viewPort.y = (_contentHeight * zoom - height) / 2 + panY * zoom ;
			
			viewPort.width = width;
			viewPort.height = height;
			scrollRect = viewPort;
			
			super.draw();		
		}


		public function get content():DisplayObject {
			return _content;
		}

		public function set content(content:DisplayObject):void {
			if(_content) destroyChild(_content);
			_content = content;
			reset();
			
			if(content != null && (content is Loader)) {
				(content as Loader).contentLoaderInfo.addEventListener(Event.INIT, eventDelegate(refreshContentSize));
			}
			refreshContentSize();
		}

		public function get zoom():Number {
			return _zoom;
		}

		public function set zoom(z:Number):void {
			_zoom = z;
			invalidate();
		}

		public function get panX():Number {
			return _panX;
		}

		public function set panX(x:Number):void {
			_panX = x;
			invalidate();
		}

		public function get panY():Number {
			return _panY;
		}		

		public function set panY(y:Number):void {
			_panY = y;
			invalidate();
		}
	}
}
