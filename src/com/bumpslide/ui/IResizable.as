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
	 * @author David Knape
	 */
	public interface IResizable {
		function setSize( w:Number, h:Number ) : void;
		function get width():Number;
		function get height():Number;
		function set width(val:Number):void;
		function set height(val:Number):void;
	}
}
