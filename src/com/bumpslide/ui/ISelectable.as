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

	/**
	 * ISelectable
	 *
	 * @author David Knape
	 * @version SVN: $Id: $
	 */
	public interface ISelectable 
	{
		
		function set selected(val:Boolean):void;
		function get selected():Boolean;
	}
}
