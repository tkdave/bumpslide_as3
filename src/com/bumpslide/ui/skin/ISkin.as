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

package com.bumpslide.ui.skin 
{
	/**
	 * Interface for component skins
	 * 
	 * @author David Knape
	 */
	public interface ISkin
	{	
		
		/**
		 * Init Host
		 */
		function initHostComponent( host_component:ISkinnable ):void;
		
		
		/**
		 * State has changed.  Update display list.
		 */
		function renderSkin( skinState:String ):void;
		
		
		/**
		 * Take down children
		 */
		function destroy():void;
		
		
	}
}
