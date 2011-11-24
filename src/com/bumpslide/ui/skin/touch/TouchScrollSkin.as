package com.bumpslide.ui.skin.touch
{

	import com.bumpslide.ui.Box;
	import com.bumpslide.ui.skin.BasicSliderSkin;


	/**
	 * TouchScrollSkin
	 *
	 * @author David Knape
	 */
	public class TouchScrollSkin extends BasicSliderSkin
	{
		
		override protected function addChildren():void 
		{
			//logEnabled = true;
			
			// Use panel to control padding around background art
			background = add( Box, { backgroundAlpha: 0 }); 
			
			handle = new Box( 0x666666, 10, 10, 0, 0, 5, 1, 0xffffff );
			Box(handle).borderPixelHinting = true;
			handle.alpha = .5;
			addChild( handle );
		}
	}
}
