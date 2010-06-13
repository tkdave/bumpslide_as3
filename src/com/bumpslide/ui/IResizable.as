/**
 * This code is part of the Bumpslide Library by David Knape
 * http://bumpslide.com/
 * 
 * Copyright (c) 2006, 2007, 2008 by Bumpslide, Inc.
 * 
 * Released under the open-source MIT license.
 * http://www.opensource.org/licenses/mit-license.php
 * see LICENSE.txt for full license terms
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
