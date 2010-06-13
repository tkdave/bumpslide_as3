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
 
package com.bumpslide.ui 
{
	import com.bumpslide.data.type.Padding;
	import com.bumpslide.events.UIEvent;

	import flash.events.Event;
	import flash.system.LoaderContext;
	import flash.utils.Timer;

	/**
	 * GridItem that loads an image using the gridItemData as a URL
	 *  
	 * @author David Knape
	 */
	public class ThumbnailItem extends GridItem {

		public var image:Image;
		public var border:Box;
		public var fill:Box;
		
		protected var _borderColor:Number = 0x999999;
		protected var _fillColor:Number = 0xdddddd;
		protected var _borderThickness:Number = 1;
		protected var _margin:Number = 0;		
		protected var _pendingLoad:Timer;
		protected var _padding:Padding;

		
		/**
		 * Creates border, fill, and image clips
		 */
		override protected function addChildren():void {
			//delayUpdate = false;
			cacheAsBitmap = true;
			
			if(_padding==null) _padding = new Padding( 3 );
			
			// add children
			border = addChild( new Box(_borderColor) ) as Box;
			fill = addChild( new Box(_fillColor) ) as Box; 
			image = addChild( new Image() ) as Image;
			
			// configure image to fade in and crop
			image.fadeOnLoad = true;     
			image.scaleMode = Image.SCALE_CROP;
			image.addEventListener(Image.EVENT_LOADED, onImageLoaded);
		}
		
		/**
		 * Always unload images in your destroy method
		 */
		override public function destroy():void {
			//removeEventListener( Event.ENTER_FRAME, doLoad );
			cancelCall( _pendingLoad );
			image.unload();			
			super.destroy();
		}

		/**
		 * Updates everything that isn't related to gridItemData
		 */
		override protected function draw():void {	
			log('draw '+height+','+width);		
			// update border and fill color
			border.color = borderColor;
			fill.color = fillColor;
			
			border.visible = (borderThickness>0);
			 
			// position the boxes
			border.move(margin, margin);
			fill.move(margin + borderThickness, margin + borderThickness); 
			image.move(margin + borderThickness + padding.left, margin + borderThickness + padding.top);
			
			// update sizes
			border.setSize(width - 2 * border.x, height - 2 * border.y);
			fill.setSize(width - 2 * fill.x, height - 2 * fill.y);
			image.setSize(width - 2 * image.x, height - 2 * image.y);
			
			super.draw();
		}
		
		/**
		 * Update things tied to gridItemData
		 */
		override protected function drawGridItem():void {			
			cancelCall( _pendingLoad );
			image.unload();  
			_pendingLoad = callLater( 200, doLoad );
		}	

		
		override protected function clearGridItem():void
		{
			cancelCall( _pendingLoad );
			image.unload();
			super.clearGridItem();
		}

		
		/**
		 * Load the image
		 */
		protected function doLoad(e:Event=null) : void {
			//removeEventListener( Event.ENTER_FRAME, doLoad );
			image.load( url, 1, new LoaderContext(true) );  		
		}
		
		/**
		 * Auto-size to match image once it is loaded if image is not set to resize or crop
		 */
		protected function onImageLoaded(event:UIEvent):void {
			//queue.remove( _pendingLoad );
			log('image loaded '+image.actualWidth +','+image.actualHeight);			
			if(image.scaleMode== Image.SCALE_NONE) {
				setSize(image.actualWidth + padding.width, image.actualHeight + padding.height);
			}      
			alpha = 1;
		}

//		override public function _over():void {
//			FTween.ease( image, 'alpha', .8);
//		}
//
//		override public function _off():void {
//			FTween.ease( image, 'alpha', 1);
//		}
//
//		override public function _down():void {
//			FTween.ease( image, 'alpha', .7);
//		}

		//------------------------
		// Getters/Setters
		//------------------------
		public function get loaded():Boolean {
			return image.loaded;
		}
		public function get fillColor():Number {
			return _fillColor;
		}
		public function set fillColor(fillColor:Number):void {
			_fillColor = fillColor;
			invalidate();
		}

		public function get borderColor():Number {
			return _borderColor;
		}

		public function set borderColor(borderColor:Number):void {
			_borderColor = borderColor;
			invalidate();
		}
		public function get padding():Padding {
			return _padding;
		}
		
		public function set padding ( p:* ) : void {
			if(p is Padding) _padding = (p as Padding).clone();
			else _padding = Padding.fromString( String(p) );
			invalidate();
		}

		public function get margin():Number {
			return _margin;
		}

		public function set margin(margin:Number):void {
			_margin = margin;
			invalidate();
		}

		public function get borderThickness():Number {
			return _borderThickness;
		}

		public function set borderThickness(borderThickness:Number):void {
			_borderThickness = borderThickness;
			invalidate();
		}
		
		public function get url():String {
			return gridItemData;
		}
		
	}
}
