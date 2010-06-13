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

		public var textBox:Label;


		
		override protected function addChildren():void 
		{
			background = add(Box, { cornerRadius: Style.CORNER_RADIUS, filters: [Style.BEVEL_FILTER] });
			textBox = add(Label);
		}

		
		public function get hostComponent():Button {
			return _hostComponent as Button;
		}

		
		override public function renderSkin( skinState:String ):void 
		{
			super.renderSkin(skinState);
			
			if(hostComponent == null) return;
			
			if(hostComponent.padding) {
				textBox.padding = hostComponent.padding;
			}
			
			// If we are sizing the button based on the label size,
			// we can't have the label size be undefined
			// force it to a single line
			if(!hostComponent.explicitWidth) {
				textBox.multiline = false;
			}
			
			textBox.text = hostComponent.label;
						
			
			if(hostComponent.label != null && hostComponent.label != "") {
			
				var w:Number;
				var h:Number;
				
				// Label Button
			
				// If button has width explicitly set,
				// use that to size the label and background width
				if(hostComponent.explicitWidth) {
					w = textBox.width = hostComponent.width;
					Align.center(textBox, hostComponent.width, textBox.actualWidth);
				} else {
					w = textBox.actualWidth;
				}
				
				if(hostComponent.explicitHeight) {
					h = hostComponent.height;
					Align.middle(textBox, hostComponent.height, textBox.height);
				} else {
					h = textBox.height;
				}
				
				// use the label width to determine the background width
				background.setSize(w, h);
			} else {
				
				// No label
				
				// set the background to the size of the component
				background.setSize(hostComponent.width, hostComponent.height);
			}
		} 		

		
		public function _off():void 
		{
			background.color = Style.BUTTON_OFF;
			textBox.content_txt.textColor = Style.LABEL_TEXT;
			alpha = 1.0;
		}

		
		public function _over():void 
		{
			background.color = Style.BUTTON_OVER;
			
			textBox.content_txt.textColor = Style.LABEL_TEXT;
			alpha = 1.0;
		}

		
		public function _down():void 
		{
			background.color = Style.BUTTON_DOWN;	
			textBox.content_txt.textColor = Style.LABEL_TEXT;
			alpha = 1.0;
		}

		
		public function _selected():void 
		{
			background.color = Style.BUTTON_SELECTED;
			textBox.content_txt.textColor = Style.LABEL_TEXT_SELECTED;
			alpha = 1.0;
		}

		
		public function _disabled():void 
		{
			background.color = Style.BUTTON_OFF;
			textBox.content_txt.textColor = Style.LABEL_TEXT;
			alpha = .5;
		}
	}
}
