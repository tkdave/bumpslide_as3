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
	 * DefaultSliderSkin2
	 *
	 * @author David Knape
	 * @version SVN: $Id: $
	 */
	public class DefaultSliderSkin2 extends BasicSliderSkin 
	{
		override protected function addChildren():void 
		{
			logEnabled = true;
			
			// Use panel to control padding around background art
			background = add( Panel, { 
				padding: new Padding( 5, 0), 
				content: create( Box, { 
					color: Style.BACKGROUND, 
					fillAlpha: Style.BACKGROUND_ALPHA, 
					cornerRadius:Style.CORNER_RADIUS,
					filters: [Style.BEVEL_FILTER_INSET]
				}) 
			});
			
			handle = add( Button );
			handle.add( PixelIcon, { 
				data: "  -, -,-,  -, -,-,  -, -,-", 
				color: Style.LABEL_TEXT, alignH: "center", alignV: "middle" 
			});
		}
		
		override public function initHostComponent(host_component:ISkinnable):void 
		{
			super.initHostComponent(host_component);
			hostComponent.fixedHandleSize = 16;
		}
	}
}