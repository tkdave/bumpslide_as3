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
package com.bumpslide.util
{

	import com.bumpslide.ui.Box;
	import flash.display.*;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.geom.Transform;

	/**	* Some Bitmap and image-related utility functions	* 	* In as2, we had image smoothing stuff here.  For as3, just set bmp.smoothing=true	* where bmp = (loader.content as Bitmap)	* 
	 * Now includes support for Flex assets. But, we do it dynamically, so there are
	 * still no flex dependencies.
	 * 	* @author David Knape  	*/
	public class ImageUtil
	{

		/**		* Resizes an image or rectangle to fit within a bounding box		* while preserving aspect ratio.  The third parameter is optional.		* AllowStretching allows the image bounds to be stetched beyond the 		* original size. By default this is off. We use this most often for sizing 		* dynamically loaded JPG's, and we don't want them to be stetched larger 		*  		* @param	original - image size as a rectangle, max dimensions if allowStetching is left to false		* @param	bounds - the target size and/or available space for displaying the image		* @param	allowStetching - default is false		*/
		static public function resizeRect( original:Rectangle, bounds:Rectangle, allowStretching:Boolean = true ) : Rectangle
		{
			if(original==null || original.width==0 || original.height==0) return new Rectangle();
			var size:Rectangle = original.clone();
			var aspectRatio:Number = original.width / original.height;
			// first we size based on width
			// check for max width, resize if necessary
			if(allowStretching || size.width > bounds.width) {
				size.width = bounds.width;
				size.height = size.width / aspectRatio;
			}
			// after size by width, check height
			// make it even smaller if necessary
			if(size.height > bounds.height) {
				size.height = bounds.height;
				size.width = size.height * aspectRatio;
			}
			return size;
		}


		/**
		 * Resizes a display object to fit inside a box width dimensions maxWidth and maxHeight
		 */
		static public function resize( img:DisplayObject, maxWidth:Number, maxHeight:Number, allowStretching:Boolean = true ):void
		{
			if(img == null || maxWidth <= 0 || maxHeight <= 0) {
				// fail gracefully
				return;
			}
			
			reset(img);

			var newSize:Rectangle = ImageUtil.resizeRect( ImageUtil.getSize( img ), new Rectangle( 0, 0, maxWidth, maxHeight ), allowStretching );

			img.width = newSize.width;
			img.height = newSize.height;
		}


		/**         * Crops display object using a scrollrect - stretches to fill rect defined by width and height         */
		static public function crop( img:DisplayObject, w:Number, h:Number, centered:Boolean = true ) : void
		{
			if(img == null || w <= 0 || h <= 0) {
				// fail gracefully
				return;
			}
			
			reset(img);
			
			// Original Size
			var size:Rectangle = ImageUtil.getSize( img );
		
			// Original Aspect Ratio
			var aspect_ratio:Number = size.width / size.height;
			
			// Begins as the target crop size, and becomes the calculated actual image size (before cropping)
			var target_size:Rectangle = new Rectangle( 0, 0, w, h );
			
			// The target aspect ratio
			var target_aspect_ratio:Number = w / h;

			if(aspect_ratio > target_aspect_ratio) {
				
				// We are wider than target, use target height, and size width to match original aspect ratio
				// edges will be cropped on the sides
				
				target_size.width = target_size.height * aspect_ratio;
				
			} else {
				
				// We are narrow, use target width, and size height to match original aspect ratio
				// edges will be cropped on the top and bottom
				
				target_size.height = target_size.width / aspect_ratio;
			}
			
			var scale:Number = target_size.width/size.width;
			
			img.scaleX = img.scaleY = scale;
			
			// the scroll rect we use for cropping 
			var scroll_rect:Rectangle = new Rectangle( 0, 0, w/scale, h/scale );
					
			// center scrollRect in image (crop to fit)
			if(centered) {
				scroll_rect.x = ( (target_size.width - w) / scale / 2 );
				scroll_rect.y = ( (target_size.height - h) / scale / 2 );
			}
			
			img.scrollRect = scroll_rect;
		}
		
		
		/**
		 * Remove any crop or scale performed by this class
		 */
		static public function reset( img:DisplayObject ):void {
			/*
			if(img is Loader) {
				try {
					img = (img as Loader).content;
				} catch (error:Error) {
				}
			}*/
			
			img.scaleX = img.scaleY = 1.0;
			img.scrollRect = null;
		}


		static public function getSize( img:DisplayObject ) : Rectangle
		{			
			if(img==null) return new Rectangle();
			
			if(isFlexAsset( img )) {
				return new Rectangle( 0, 0, img['measuredWidth'], img['measuredHeight'] );
			} else {
				return getFullBounds( img );
			}
		}
		
		/**
		 * This function works like DisplayObject.getBounds(), except it will find the full
		 * bounds of any display object, even after its scrollRect has been set.
		 *
		 * http://usecake.com/lab/find-the-height-and-width-of-a-sprite-with-a-scrollrect.html
		 * 
		 * @param displayObject - a display object that may have a scrollRect applied
		 * @return a rectangle describing the dimensions of the unmasked content
		 */
		static public function getFullBounds( displayObject:DisplayObject ):Rectangle
		{
			var bounds:Rectangle, transform:Transform,
			toGlobalMatrix:Matrix, currentMatrix:Matrix;

			transform = displayObject.transform;
			currentMatrix = transform.matrix;
			toGlobalMatrix = transform.concatenatedMatrix;
			toGlobalMatrix.invert();
			transform.matrix = toGlobalMatrix;

			bounds = transform.pixelBounds.clone();

			transform.matrix = currentMatrix;

			return bounds;
		}


		static public function isFlexAsset( img:DisplayObject ) : Boolean
		{
			var is_flex:Boolean = false;
			try {
				is_flex = img['measuredHeight'] != null && img['setActualSize'] != null;
			} catch (e:Error) {
			}
			return is_flex;
		}


		/**         * Get bmp snapshot         */
		static public function getSnapshot( mc:DisplayObject ):BitmapData
		{
			var img:DisplayObject = mc;
			if(mc is Loader) {
				try {
					img = (mc as Loader).content;
				} catch (error:Error) {
				}
			}
			if(img == null || img.width == 0 || img.height == 0)
				return new BitmapData(1,1,true,0x0000000);

			var w:Number;
			var h:Number;

			// support flex bitmaps
			if(isFlexAsset(img)) {
				w = img['measuredWidth'];
				h = img['measuredHeight'];
			} else {
				w = img.width;
				h = img.height;
			}
			var bmp:BitmapData = new BitmapData( w, h, true, 0x00000000 );
			bmp.draw( mc );
			return bmp;
		}
	}
}