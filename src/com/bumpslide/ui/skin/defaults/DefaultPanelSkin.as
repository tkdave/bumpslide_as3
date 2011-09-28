package com.bumpslide.ui.skin.defaults
{

	import com.bumpslide.ui.Box;
	import com.bumpslide.ui.Panel;
	import com.bumpslide.ui.skin.BasicSkin;

	/**
	 * DefaultPanelSkin
	 *
	 * @author David Knape
	 */
	public class DefaultPanelSkin extends BasicSkin
	{

		private var background:Box;
		
		public function get hostComponent():Panel {
			return _hostComponent as Panel;
		}

		override protected function addChildren() : void
		{
			background = add( Box );
			background.backgroundColor = Style.PANEL_BACKGROUND_COLOR;
			background.cornerRadius = Style.PANEL_CORNER_RADIUS;
			background.filters = [ Style.BEVEL_FILTER_INSET ];
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
