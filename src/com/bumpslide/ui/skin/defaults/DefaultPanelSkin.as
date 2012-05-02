package com.bumpslide.ui.skin.defaults
{

	import com.bumpslide.ui.Box;
	import com.bumpslide.ui.Panel;
	import com.bumpslide.ui.Skin;

	/**
	 * The Panel Skin is really just the background skin
	 *
	 * @author David Knape
	 */
	public class DefaultPanelSkin extends Skin
	{

		private var background:Box;
		
		public function get hostComponent():Panel {
			return _hostComponent as Panel;
		}

		override protected function addChildren() : void
		{
			background = add( Box, Style.PANEL_BACKGROUND );
		}
		
		
		override protected function draw() : void
		{
			if(background && hostComponent) {
				background.visible = hostComponent.backgroundVisible;
				background.setSize( width, height );
			}
		}


	}
}
