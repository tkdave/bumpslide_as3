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
