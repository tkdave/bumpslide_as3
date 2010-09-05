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
	import com.bumpslide.ui.PixelIcon;
	import com.bumpslide.data.type.Padding;
	import com.bumpslide.ui.Box;
	import com.bumpslide.ui.Button;
	import com.bumpslide.ui.Panel;
	import com.bumpslide.ui.skin.BasicSliderSkin;
	import com.bumpslide.ui.skin.ISkinnable;

	/**
	 * DefaultSliderSkin
	 *
	 * @author David Knape
	 * @version SVN: $Id: $
	 */
	public class DefaultSliderSkin extends BasicSliderSkin 
	{
		override protected function addChildren():void 
		{
			//logEnabled = true;
			
			// Use panel to control padding around background art
			background = add( Panel, { 
				padding: Style.SLIDER_BACKGROUND_PADDING, 
				backgroundVisible: false,
				content: create( Box, { 
					backgroundColor: Style.PANEL_BACKGROUND_COLOR, 
					cornerRadius:Style.BUTTON_CORNER_RADIUS,
					filters: [Style.BEVEL_FILTER_INSET]
				}) 
			});
			
			handle = add( Button, { icon: new PixelIcon("  -, -,-,  -, -,-,  -, -,-", Style.BUTTON_LABEL) } );			
		}
		
		override public function initHostComponent(host_component:ISkinnable):void 
		{
			super.initHostComponent(host_component);
			hostComponent.fixedHandleSize = 16;
		}
	}
}