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
	/**
	 * @author David Knape
	 */
	public class ArrayUtil {
				
		/**
		 * Shuffles an array (modifies original)
		 */
		static public function shuffle( a:Array ):void {			
			var len:uint = a.length;
			var n:uint;
			var i:uint;
			var el:*;
			for (i=0; i<len; i++) {
				el = a[i];
				n = Math.floor( Math.random() * len );
				a[i] = a[n];
				a[n] = el;
			}		
		}
		
	}
}
