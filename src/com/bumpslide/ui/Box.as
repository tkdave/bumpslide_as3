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

	import com.bumpslide.data.type.Gradient;
	import com.bumpslide.ui.skin.defaults.Style;

	import flash.display.BitmapData;
	import flash.display.GradientType;

	/**
	 * A Box
	 * 
	 * This is resizable box that is useful for quick drawing and also
	 * serves as a simple component demonstration.
	 */
	public class Box extends Component implements IGridItem {
		
		protected var _backgroundColor:Number = 0;
		protected var _backgroundAlpha:Number = 1;
		protected var _borderSize:int = -1;
		protected var _borderColor:uint = 0x000000;
		protected var _borderAlpha:Number = 1;
		protected var _borderPixelHinting:Boolean = Style.BORDER_PIXEL_HINTING;
		protected var _cornerRadius:Number = 0;
		protected var _tileBitmap:BitmapData;
		protected var _centerOrigin:Boolean = false;
		protected var _gradientFill:Gradient = null;
		
		public function Box( color:Number=0xdddddd, width:Number = 64, height:Number = 64, x:Number = 0, y:Number = 0, corner_radius:Number = 0, border_width:Number=-1, border_color:uint=0x000000) {
			super();
			_backgroundColor = color;		
			_cornerRadius = corner_radius;	
			_borderSize = border_width;
			_borderColor = border_color;
			
			this.x = x;
			this.y = y;
			
			delayUpdate = false;
			
			setSize(width, height);	
		}

		
		override protected function initSize():void {
			super.initSize( );
		}

		
		override protected function init():void 
		{
			log('init');
			super.init();
		}

		
		override protected function draw():void {
			super.draw();
			
			graphics.clear();
			if(borderWidth>=0) {
				graphics.lineStyle( borderWidth, borderColor, borderAlpha, borderPixelHinting);
			}		
			if(_tileBitmap) {
				graphics.beginBitmapFill(_tileBitmap);
			} else if(_gradientFill) {
				_gradientFill.beginFill(graphics,width, height);
			} else {
				graphics.beginFill(backgroundColor, backgroundAlpha);
			}
			drawShape();
			graphics.endFill();	
			
		}    
		
		protected function drawShape() : void {
			if(centerOrigin) {
				graphics.drawRoundRect(-width/2, -height/2, width, height, cornerRadius*2, cornerRadius*2);
			} else {
				graphics.drawRoundRect(0, 0, width, height, cornerRadius*2, cornerRadius*2);
			}
			
		}
		
		//---------------------------------------------
		// IGridItem implementation   
		//  - when used as a grid item, 
		//    the item data is interpretted as color
		//--------------------------------------------- 
		
		protected var _gridIndex:int;

		public function set gridItemData( v:* ):void {
			backgroundColor = v;
		}            

		public function set gridIndex(v:Number):void {
			_gridIndex = v; 
		}   

		public function get gridItemData():* {
			return backgroundColor;			
		}

		public function get gridIndex():Number {
			return _gridIndex;
		}
		
		
		//--------------------------------------
		// GETTERS / SETTERS
		//--------------------------------------
		
		public function set backgroundColor(val:*):void {
			//log('color set to ' + val );
			if(isNaN(val)) val=parseInt(val, 16);
			_backgroundColor = val;
			invalidate();
		}

		public function get backgroundColor():uint {
			return _backgroundColor;
		}
		
		public function set cornerRadius(val:Number):void {
			_cornerRadius = val;
			invalidate();
		}

		public function get cornerRadius():Number {
			return _cornerRadius;
		}
		
		public function get backgroundAlpha():Number {
			return _backgroundAlpha;
		}
		
		public function set backgroundAlpha(alpha:Number):void {
			_backgroundAlpha = alpha;
			invalidate();
		}
		
		public function get borderWidth():int {
			return _borderSize;
		}
		
		public function set borderWidth(borderWidth:int):void {
			_borderSize = borderWidth;
			invalidate();
		}
		
		public function get borderColor():uint {
			return _borderColor;
		}
		
		public function set borderColor(val:*):void {
			if(isNaN(val)) val=parseInt(val, 16);
			_borderColor = val;
			invalidate();
		}
		
		public function get borderAlpha():Number {
			return _borderAlpha;
		}
		
		public function set borderAlpha(borderAlpha:Number):void {
			_borderAlpha = borderAlpha;
			invalidate();
		}

		public function get tileBitmap():BitmapData {
			return _tileBitmap;
		}

		public function set tileBitmap(bitmap_data:BitmapData):void {
			_tileBitmap = bitmap_data;
			invalidate();
		}
		
		public function get centerOrigin():Boolean {
			return _centerOrigin;
		}
		
		public function set centerOrigin(centerOrigin:Boolean):void {
			_centerOrigin = centerOrigin;
			invalidate();
		}
		
		public function get borderPixelHinting():Boolean {
			return _borderPixelHinting;
		}
		
		public function set borderPixelHinting(borderPixelHinting:Boolean):void {
			_borderPixelHinting = borderPixelHinting;
			invalidate();
		}


		public function get gradientFill():Gradient {
			return _gradientFill;
		}

		public function set gradientFill( gradientFill:Gradient ):void {
			_gradientFill = gradientFill;
			invalidate();
		}
	}
}