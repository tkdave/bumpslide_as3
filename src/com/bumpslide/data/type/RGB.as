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

package com.bumpslide.data.type {	import flash.geom.Vector3D;
	/**	 * RGB Data type	 * 	 * Original Version Here:	 * http://library.sfug.ch/trac/browser/trunk/as3/ch/sfug/util/RGB.as	 * 	 * Released under the zlib/libpng license:	 * http://www.opensource.org/licenses/zlib-license.php	 */		public class RGB {				private var r:int;		private var g:int;		private var b:int;		/**		 * creates a rgb object with default value ( 0, 0, 0 ) which is black.		 */		public function RGB( rVal:int = 0, gVal:int = 0, bVal:int = 0 ) {			red = rVal;			blue = bVal;			green = gVal;		}				/**		 * returns a rgb object from a hex string like: "#123456"		 */		public static function createFromHEX( hexVal:String ):RGB {			if( hexVal.length == 7 ) {				var color:RGB = new RGB();				color.red = int( "0x" + hexVal.substr( 1, 2 ) );				color.green = int( "0x" + hexVal.substr( 3, 2 ) );				color.blue = int( "0x" + hexVal.substr( 5, 2 ) );			} else {				throw new Error( "the hex parameter to create an rgb object has to be in the form like: #123456 not: " + hexVal );			}			return color;		}						/**		 * creates a rgb object from a color number which can be between 0 and 16777215 ( 0xFFFFFF )		 */		public static function createFromNumber( val:Number ):RGB {			if( !isNaN( val ) && val >= 0 && val <= 0xFFFFFF ) {				var color:RGB = new RGB();				color.red = val >> 16 & 0xFF;				color.green = val >> 8 & 0xFF;				color.blue = val & 0xFF;							} else {				throw new Error( "the number parameter to create an rgb object has to be between 0 and 0xFFFFFF not: " + val );			}						return color;		}						/**		 * returns a copy of the rgb object		 */		public function clone():RGB {			return new RGB( red, green, blue);		}						/**		 * returns true if the rgb object to compare has the same colorvalue as the current.		 */		public function equals( compare:RGB ):Boolean {			return number == compare.number;		}				/**		 * sets the single color values ( 0 - 255 )		 */		public function set red( val:int ):void {			if( !isNaN( val ) ) r = Math.max( Math.min( val, 255 ), 0 );		}		public function set green( val:int ):void {			if( !isNaN( val ) ) g = Math.max( Math.min( val, 255 ), 0 );		}		public function set blue( val:int ):void {			if( !isNaN( val ) ) b = Math.max( Math.min( val, 255 ), 0 );		}				/**		 * returns the single color values ( 0 - 255 )		 */		public function get red():int {			return r;		}		public function get green():int {			return g;			}		public function get blue():int {			return b;			}		/**		 * returns the rgb value as a 16mio number		 */		public function get number():uint {			return (r << 16 | g << 8 | b);		}		/**		 * returns the hex code as a string		 */		public function get hex():String {			return "0x" + red.toString( 16 ) + green.toString( 16 ) + blue.toString( 16 );		}				public function toString() : String{			return 'RGB('+red+','+green+','+blue+')';
		}

		/**
		 * Interpolate from one color to another. val is 0 to 1.0;
		 */
		public static function interpolate( rgb1:RGB, rgb2:RGB, val:Number ):RGB
		{
			return new RGB( (rgb2.red - rgb1.red ) * val + rgb1.red,  (rgb2.green - rgb1.green ) * val + rgb1.green, (rgb2.blue - rgb1.blue ) * val + rgb1.blue);
		}
	}                    }