package com.bumpslide.ui.skin.defaults 
{
	import com.bumpslide.ui.Box;
	import com.bumpslide.ui.Button;
	import com.bumpslide.ui.Label;
	import com.bumpslide.ui.skin.BasicSkin;
	import com.bumpslide.util.Align;

	/**
	 * Programmatic button skin with a bunch of nice label placement logic.
	 * 
	 * @author David Knape
	 */
	public class DefaultButtonSkin extends BasicSkin
	{

		public var background:Box;
		public var labelDisplay:Label;


		public function get hostComponent():Button {
			return _hostComponent as Button;	
		}

		/**
		 * Create a background box and a label
		 */		
		override protected function addChildren():void 
		{
			background = add(Box, { cornerRadius: Style.BUTTON_CORNER_RADIUS, filters: [Style.BEVEL_FILTER] });
			labelDisplay = add(Label);
		}
		
		/**
		 * 
		 */
		override public function renderSkin( skinState:String ):void 
		{
			// call skin state functions (ex: '_over', '_down', '_selected')
			super.renderSkin(skinState);
			
			if(hostComponent == null) return;
			
			// If button has padding specified, apply it to label
			if(hostComponent.padding) {
				labelDisplay.padding = hostComponent.padding;
			}
			
			if(hostComponent.explicitWidth) {
				labelDisplay.width = hostComponent.width;
			}						
			
			if(hostComponent.label != null && hostComponent.label != "") {
				
				labelDisplay.text = hostComponent.label;
				labelDisplay.visible = true;
				
				var backgroundWidth:Number;
				var backgroundHeight:Number;
				
				// If button has width explicitly set,
				// use that to size the label and background width
				if(hostComponent.explicitWidth) {
					backgroundWidth = hostComponent.width;
					if(hostComponent.centerLabel) {
						labelDisplay.width = 0;
						Align.center( labelDisplay, hostComponent.width );
					} else {
						labelDisplay.width = hostComponent.width;
						labelDisplay.x = 0;
					}
				} else {
					// otherwidth, just make the background as wide as the label (with padding)
					backgroundWidth = labelDisplay.actualWidth;
				}
				
				// If button has height explicitly set,
				// use that size the label and background height
				if(hostComponent.explicitHeight) {
					backgroundHeight = hostComponent.height;
					Align.middle(labelDisplay, hostComponent.height, labelDisplay.height);
				} else {
					// otherwidth, just make the background as tall as the label (with padding)
					backgroundHeight = labelDisplay.height;
				}
				
				// use the label width to determine the background width
				background.setSize(backgroundWidth, backgroundHeight);
			} else {
				
				// No label
				labelDisplay.text = "";
				labelDisplay.visible = false;
				
				
				// set the background to the size of the component
				background.setSize(hostComponent.width, hostComponent.height);
			}
		} 		

		
		public function _off():void 
		{
			background.backgroundColor = Style.BUTTON_OFF;
			labelDisplay.textField.textColor = Style.BUTTON_LABEL;
			alpha = 1.0;
		}

		
		public function _over():void 
		{
			background.backgroundColor = Style.BUTTON_OVER;
			
			labelDisplay.textField.textColor = Style.BUTTON_LABEL;
			alpha = 1.0;
		}

		
		public function _down():void 
		{
			background.backgroundColor = Style.BUTTON_DOWN;	
			labelDisplay.textField.textColor = Style.BUTTON_LABEL;
			alpha = 1.0;
		}

		
		public function _selected():void 
		{
			background.backgroundColor = Style.BUTTON_SELECTED;
			labelDisplay.textField.textColor = Style.BUTTON_LABEL_OVER;
			alpha = 1.0;
		}

		
		public function _disabled():void 
		{
			background.backgroundColor = Style.BUTTON_OFF;
			labelDisplay.textField.textColor = Style.BUTTON_LABEL;
			alpha = .5;
		}
	}
}
