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
	import flash.display.BitmapData;

	/**
	 * A Box
	 * 
	 * This is resizable box that is useful for quick drawing and also
	 * serves as a simple component demonstration.
	 */
	public class Box extends Component implements IGridItem {
		
		protected static const VALID_STYLE:String = "validStyle";
		
		protected var _color:Number = 0;
		protected var _cornerRadius:Number = 0;
		protected var _tileBitmap:BitmapData;
		
		protected var _fillAlpha:Number = 1;
		
		protected var _borderWidth:int = -1;
		protected var _borderColor:uint = 0x000000;		protected var _borderAlpha:Number = 1;
		protected var _centerOrigin:Boolean = false;
		protected var _borderPixelHinting:Boolean = true;
		
		
		public function Box( color:Number = 0, width:Number = 64, height:Number = 64, x:Number = 0, y:Number = 0, corner_radius:Number = 0, border_width:Number=-1, border_color:uint=0x000000 ) {
			super();	
						
			delayUpdate = false;		
			_color = color;		
			_cornerRadius = corner_radius;	
			_borderWidth = border_width;
			_borderColor = border_color;
			
			this.x = x;
			this.y = y;
			setSize(width, height);	
		}

		
		override protected function init():void 
		{
			log('init');
			super.init();
		}

		
		override protected function draw():void {
			super.draw();
			
			graphics.clear();
			graphics.beginFill(color, fillAlpha);	
			if(borderWidth>=0) {
				graphics.lineStyle( borderWidth, borderColor, borderAlpha, borderPixelHinting);
			}		
			if(_tileBitmap) {
				graphics.beginBitmapFill(_tileBitmap);
			}			
			drawShape();
			graphics.endFill();	
			
			validate(VALID_STYLE);
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
			color = v;
		}            

		public function set gridIndex(v:int):void {
			_gridIndex = v; 
		}   

		public function get gridItemData():* {
			return color;			
		}

		public function get gridIndex():int {
			return _gridIndex;
		}
		
		
		//--------------------------------------
		// GETTERS / SETTERS
		//--------------------------------------
		
		public function set color(val:*):void {
			//log('color set to ' + val );
			if(isNaN(val)) val=parseInt(val, 16);
			_color = val;
			invalidate(VALID_STYLE);
		}

		public function get color():uint {
			return _color;
		}
		
		public function set cornerRadius(val:Number):void {
			_cornerRadius = val;
			invalidate(VALID_STYLE);
		}

		public function get cornerRadius():Number {
			return _cornerRadius;
		}
		
		public function get fillAlpha():Number {
			return _fillAlpha;
		}
		
		public function set fillAlpha(fillAlpha:Number):void {
			_fillAlpha = fillAlpha;
			invalidate(VALID_STYLE);
		}
		
		public function get borderWidth():int {
			return _borderWidth;
		}
		
		public function set borderWidth(borderWidth:int):void {
			_borderWidth = borderWidth;
			invalidate(VALID_STYLE);
		}
		
		public function get borderColor():uint {
			return _borderColor;
		}
		
		public function set borderColor(val:*):void {
			if(isNaN(val)) val=parseInt(val, 16);
			_borderColor = val;
			invalidate(VALID_STYLE);
		}
		
		public function get borderAlpha():Number {
			return _borderAlpha;
		}
		
		public function set borderAlpha(borderAlpha:Number):void {
			_borderAlpha = borderAlpha;
			invalidate(VALID_STYLE);
		}

		public function get tileBitmap():BitmapData {
			return _tileBitmap;
		}

		public function set tileBitmap(bitmap_data:BitmapData):void {
			_tileBitmap = bitmap_data;
			invalidate(VALID_STYLE);
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
	}
}