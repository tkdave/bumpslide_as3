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

package com.bumpslide.ui.skin.defaults
{

	import com.bumpslide.data.type.Padding;

	import flash.filters.BevelFilter;
	import flash.filters.BitmapFilter;
	import flash.filters.DropShadowFilter;
	import flash.text.TextFormat;

	/**
	 * Style constants used by the default programmatic skins
	 */
	public class Style
	{	
		// Default Panel Styles
		public static var PANEL_BACKGROUND_COLOR:Number = 0xEEEEEE;
		public static var PANEL_PADDING:Number = 5;
		public static var PANEL_CORNER_RADIUS:Number = 0;
		
		// Default Button Styles
		public static var BUTTON_OFF:uint = 0xDDDDDD;
		public static var BUTTON_OVER:uint = 0xEEEEEE;
		public static var BUTTON_DOWN:uint = 0xDDDDDD;
		public static var BUTTON_SELECTED:uint = 0x999999;
		public static var BUTTON_LABEL:uint = 0x333333;
		public static var BUTTON_LABEL_OVER:uint = 0xDDDDDD;
		public static var BUTTON_CORNER_RADIUS:Number = 0;
		
		// Default Input Styles
		public static var INPUT_BORDER:uint = 0xDDDDDD;
		public static var INPUT_FOCUS_BORDER:uint = 0x999999;		
		public static var INPUT_BACKGROUND:uint = 0xF8F8F8;
		public static var INPUT_FOCUS_BACKGROUND:uint = 0xFFFFFF;		
		public static var INPUT_TEXT:uint = 0x333333;
		public static var INPUT_TEXT_HINT:uint = 0xAAAAAA;
		
		// Default Label Text Format
		public static var LABEL_TEXT_FORMAT:TextFormat = new TextFormat('Arial', 10, 0x333333);
		public static var LABEL_FONT_EMBEDDED:Boolean = false;
		
		// Some Filters
		public static var FOCUS_FILTER:BitmapFilter = null; //new GlowFilter( 0xAAAAAA, 1, 2, 2, 10, 2);
		public static var BEVEL_FILTER:BitmapFilter = new BevelFilter(1.2, 45, 0xFFFFFF, .5, 0x000000, .5, 1.2, 1.2, 1, 2);
		public static var BEVEL_FILTER_INSET:BitmapFilter = new BevelFilter(1.4, 225, 0xDDDDDD, .5, 0x333333, .5, 1.4, 1.4, 1, 2, 'inner');
		public static var DROPSHADOW_FILTER:BitmapFilter = new DropShadowFilter(2, 45, 0, .3, 6, 6, 1, 2);

		public static var SCROLLBAR_GAP:Number = 4;
		public static var SCROLLBAR_WIDTH:Number = 16;
		
		public static var SLIDER_BACKGROUND_PADDING:Padding=new Padding( 5, 0); // Slider Track

	
	}
}