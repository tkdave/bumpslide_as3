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

package com.bumpslide.ui.skin.defaults 
{

	import com.bumpslide.ui.skin.BasicButtonSkin;

	/**
	 * Default button skin with colors defined in Style constants
	 * 
	 * @author David Knape
	 */
	public class DefaultButtonSkin extends BasicButtonSkin
	{	
		
		public function _off():void 
		{
			backgroundBox.backgroundColor = Style.BUTTON_OFF;
			labelDisplay.textField.textColor = Style.BUTTON_LABEL;
			alpha = 1.0;
		}

		
		public function _over():void 
		{
			backgroundBox.backgroundColor = Style.BUTTON_OVER;
			labelDisplay.textField.textColor = Style.BUTTON_LABEL_OVER;
			alpha = 1.0;
		}

		
		public function _down():void 
		{
			backgroundBox.backgroundColor = Style.BUTTON_DOWN;	
			labelDisplay.textField.textColor = Style.BUTTON_LABEL_OVER;
			alpha = 1.0;
		}

		
		public function _selected():void 
		{
			backgroundBox.backgroundColor = Style.BUTTON_SELECTED;
			labelDisplay.textField.textColor = Style.BUTTON_LABEL_OVER;
			alpha = 1.0;
		}

		
		public function _disabled():void 
		{
			backgroundBox.backgroundColor = Style.BUTTON_OFF;
			labelDisplay.textField.textColor = Style.BUTTON_LABEL;
			alpha = .5;
		}
	}
}
