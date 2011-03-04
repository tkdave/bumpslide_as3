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
	
	/**
	 * Quite ridiculous, actually
	 * 
	 * example:
	 * 
	 * // arrow
	 * addChild( new PixelIcon( ['  * ', 
	 *                           ' *', 	 *                           '********', 	 *                           ' *', 
	 *                           '  * '] ) );
	 * 
	 * @author David Knape
	 */
	public class PixelIcon extends Component {

		private var _data:Array;
		private var _color:Number;
		
		public function PixelIcon(icon_data:*=null, pixel_color:Number=0x000000) {
			color = pixel_color;
			if(icon_data!=null) data = icon_data;
			super();
		}
		
		/**
		 * Pixel data as an array of strings
		 */
		public function set data(data:*):void {
			if(data is String) {
				_data = String(data).split(',');
			} else if (data is Array) {
				_data = data;
			}
			invalidate();
		}
		
		public function set color(val:*):void {
			if(isNaN(val)) val=parseInt(val, 16);
			_color = val;
			invalidate();
		}

		
		override public function get width():Number {
			return actualWidth;
		}
		
		override public function get height():Number {
			return actualHeight;
		}

		
		override protected function draw() : void {
			if(_data==null) return;
			graphics.clear();
			graphics.beginFill(_color, 1);
			var num_rows:int = _data.length;
			for ( var row:int=0; row<num_rows; ++row) {
				var num_columns:int = String(_data[row]).length;
				for(var col:int=0; col<num_columns; ++col) {
					if((_data[row] as String).charAt(col)!=" ") graphics.drawRect(col, row, 1, 1);
				}
			}
			graphics.endFill();
			cacheAsBitmap = true;
			super.draw();
		}
	}
}
