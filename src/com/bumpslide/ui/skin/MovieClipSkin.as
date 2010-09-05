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
	import flash.display.MovieClip;

	/**
	 * Base class for MovieClip skins
	 * 
	 * Each skin state should be represented as a frame in a movie clip
	 * @author David Knape
	 */
	public class MovieClipSkin extends MovieClip implements ISkin 
	{	

		protected var _host:ISkinnable;

		
		/**
		 * When state changes, go to a new frame
		 * 
		 * Override this behavior for more advanced skins that need transitions and such
		 */	
		public function renderSkin( skinState:String ):void
		{
			gotoAndStop(skinState);
		}

		
		public function initHostComponent( host:ISkinnable ):void 
		{
			_host = host;
		}

		
		public function destroy( ):void 
		{
			// bye bye
		}

		
		/**
		 * code in movie clips can reference this.hostComponent which is loosely typed
		 * for flexibility
		 */
		public function hostComponent():* 
		{
			return _host;
		}
	}
}
