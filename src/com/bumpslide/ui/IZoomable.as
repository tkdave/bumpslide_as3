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

package com.bumpslide.ui {

	/**
	 * Interface for Zoomable content
	 * 
	 * panX and panY are measured in pixels of content at zoom level 1
	 * pan (0,0) is centered
	 * zoom is the same as xscale/yscale of content
	 * 
	 * @author David Knape
	 */
	public interface IZoomable {
		
		// set current zoom level without changing position
		function set zoom( z:Number ) : void;
		
		// get current zoom level 
		function get zoom() : Number;
		
		// set x pan location
		function set panX(x:Number) : void;
		
		// get x pan location
		function get panX() : Number;
		
		// set y pan location
		function set panY(y:Number) : void;
		
		// get y pan location
		function get panY() : Number;
		
		 // set the dimensions of the views rect (mask)
		function setSize(w:Number, h:Number) : void; 
		
		// get width of viewing window
		function get width () : Number;
		
		// get height of viewing window
		function get height () : Number;
			
	}
}
