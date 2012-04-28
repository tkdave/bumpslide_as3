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

package com.bumpslide.ui
{
	import com.bumpslide.ui.IResizable;
	import flash.display.DisplayObject;

	/**
	 * Interface for skinnable components
	 * 
	 * Skins don't have to be ISkin.  They just get a few nice hooks if they do.
	 * 
	 * @author David Knape
	 */
	public interface ISkinnable extends IResizable
	{
		function set skinClass(c:Class):void;
		function get skinClass():Class;
		
		function set skinState(s:String):void;
		function get skinState():String;
		
		function set skin(mc:DisplayObject):void;
		function get skin():DisplayObject;	
		
			
	}
}
