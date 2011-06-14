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
 
 package com.bumpslide.util
{

	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
	/**
	 * DisplayUtil
	 *
	 * @author David Knape, http://bumpslide.com/
	 */
	public class DisplayUtil
	{
		/**
		 * changes the color of a movieclip
		 */
		static public function colorize( mc:DisplayObject, color:uint ):void
		{
			var current_alpha:Number = mc.alpha;
			if (isNaN( color )) {
				mc.transform.colorTransform = null;
			} else {
				var ct:ColorTransform = new ColorTransform();
				ct.color = color;
				mc.transform.colorTransform = ct;
			}
			mc.alpha = current_alpha;
		}
	}
}
