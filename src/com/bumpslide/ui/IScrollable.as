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

package com.bumpslide.ui {		/**	 * Scrollable Interface Used by Slider Component	 * 	 * @see Slider.scrollTarget	 * 	 * @author David Knape	 */	public interface IScrollable {				/**		 * Returns total size of scroll content		 */	    function get totalSize () : Number ;	    	    /**	     * Returns viewport size	     */	    function get visibleSize () : Number ;	    	    /**	     * Returns current scroll position	     */	    function get scrollPosition () : Number ;	    	    /**	     * Set current scroll position	     */	    function set scrollPosition ( scrollOffset:Number ) : void;	
		
		/**
		 * Orientation - horizontal or vertical		 */
		function get orientation():String;
		 
		/**
		 * Convert from native scrollPosition units to pixels
		 * This is needed for drag scroll implementations		 */
		function get pixelsPerUnit():Number;
		 	}}