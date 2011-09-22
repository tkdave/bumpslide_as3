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

package com.bumpslide.util {
	
	import flash.utils.describeType;

	/**
	 * Object Dumper (AS3)
	 * 
	 * This code was not written by David Knape, but he found it useful to keep around, 
	 * and it has been modified from it's original in various ways.
	 * 
	 * The original version can be found at http://qops.blogspot.com/2007/06/dump-as3.html
	 */ 
	public class Dump {

		// trace
		public static function Trace(o:Object):void {
			trace(object(o));
		}

		// return the result string
		public static function object(o:Object):String {
			str = "";
			dump(o);
			// remove the lastest \n
			str = str.slice(0, str.length - 1);
			return str;
		}
		
		private static var n:int = 0;
		private static var str:String;

		private static function dump(o:Object):void {
			if(n > 5) {
				str += "...recusion_limit..." + "\n"; 
				return;
			}
			n++;
			var type:String = describeType(o).@name;
			if(type == 'Array') {
				dumpArray(o);
			} else if (type == 'Object') {
				dumpObject(o);
			} else {
				appendStr(o);
			}
			n--;
		}

		private static function appendStr(s:Object):void {
			str += s + '\n';
		}

		private static function dumpArray(a:Object):void {
			var type:String;
			for (var i:String in a) {
				type = describeType(a[i]).@name;
				if (type == 'Array' || type == 'Object') {
					appendStr(getSpaces() + "[" + i + "]:");
					dump(a[i]);
				} else {
					appendStr(getSpaces() + "[" + i + "]:" + a[i]);
				}
			}
		}

		private static function dumpObject(o:Object):void {
			var type:String;
			for (var i:String in o) {
				if (type == 'Array' || type == 'Object') {
					appendStr(getSpaces() + i + ":");
					dump(o[i]);
				} else {
					appendStr(getSpaces() + i + ":" + o[i]);
				}
			}
		}

		private static function getSpaces():String {
			var s:String = "";
			for(var i:int = 1;i < n; i++) {
				s += "  ";
			}
			return s;
		}
	}
}