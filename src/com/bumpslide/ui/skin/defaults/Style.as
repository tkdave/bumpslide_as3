/**
 * Style constants used by the default programmatic skins
 */
 
package com.bumpslide.ui.skin.defaults
{
	import flash.filters.BitmapFilter;
	import flash.filters.BevelFilter;
	
	public class Style
	{
		
		public static var CORNER_RADIUS:Number = 0;
		
		public static var BACKGROUND:uint = 0xDDDDDD;
		public static var BACKGROUND_ALPHA:Number = 1;
		
		public static var BUTTON_OFF:uint = 0xDDDDDD;
		public static var BUTTON_OVER:uint = 0xEEEEEE;
		public static var BUTTON_DOWN:uint = 0xDDDDDD;
		public static var BUTTON_SELECTED:uint = 0x999999;
		
		public static var INPUT_TEXT:uint = 0x333333;
		public static var LABEL_TEXT:uint = 0x333333;
		public static var LABEL_TEXT_SELECTED:uint = 0xDDDDDD;
		
		public static var BEVEL_FILTER:BitmapFilter = new BevelFilter(1.1, 45, 0xFFFFFF, .5, 0x000000, .5, 1.2, 1.2, 1, 2);
		public static var BEVEL_FILTER_INSET:BitmapFilter = new BevelFilter(1.1, 225, 0xFFFFFF, .5, 0x000000, .5, 1.2, 1.2, 1, 2, 'inner');
	}
}