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

    import com.bumpslide.ui.BasicSkin;
    import com.bumpslide.ui.Box;
	import com.bumpslide.ui.Button;
	import com.bumpslide.ui.IResizable;
    import com.bumpslide.ui.ISkinnable;
    import com.bumpslide.ui.Label;
	import com.bumpslide.ui.skin.defaults.Style;
	import com.bumpslide.util.Align;
	import com.bumpslide.util.ObjectUtil;
	import flash.display.DisplayObject;
	import flash.text.TextFormatAlign;


	/**
	 * Programmatic button skin with a bunch of nice label placement logic.
	 * 
	 * @author David Knape
	 */
	public class BasicButtonSkin extends BasicSkin
	{
		public var background:DisplayObject;
		public var labelDisplay:Label;

		public function get hostComponent():Button {
			return _hostComponent as Button;
		}
		
		//return background as a box (not always applicable)
		public function get backgroundBox():Box {
			return background as Box;
		}
		
		protected function createBackground():void
		{
			background = add( Box, ObjectUtil.mergeProperties( Style.BUTTON_BACKGROUND_PROPS, { width:width, height:height } ) );
			
		}


		protected function createLabel():void
		{
			labelDisplay = add( Label, { textFormat: Style.BUTTON_TEXT_FORMAT } );
			labelDisplay.textAlign = TextFormatAlign.CENTER;
			labelDisplay.padding = hostComponent.padding;
			labelDisplay.updateNow();
		}


		override public function initHostComponent( host_component:ISkinnable ):void
		{
			super.initHostComponent( host_component );

			createBackground();
			createLabel();
		}
		
		override public function renderSkin( skinState:String ):void
		{
			try {
				this['_'+_hostComponent.skinState]();				
			} catch (e:Error) {
				try {
					this['_off']();
				} catch (e:Error) {
					//trace(e);
				}
			}
			invalidate();
		}


		override protected function draw():void
		{
			if (hostComponent == null) return;

			if (labelDisplay) {
				// If button has padding specified, apply it to label
				if (hostComponent.padding) {
					labelDisplay.padding = hostComponent.padding;
				}

				if (hostComponent.explicitWidth) {
					labelDisplay.maxLines = 1;
					labelDisplay.width = hostComponent.width;
					// labelDisplay.textAlign = TextFormatAlign.CENTER;
				}

				if (hostComponent.label != null && hostComponent.label != "") {
					labelDisplay.text = hostComponent.label;
					labelDisplay.visible = true;

					var backgroundWidth:Number;
					var backgroundHeight:Number;

					// If button has width explicitly set,
					// use that to size the label and background width
					if (hostComponent.explicitWidth) {
						labelDisplay.width = hostComponent.width;
						labelDisplay.maxLines = 1;
						labelDisplay.x = 0;

						backgroundWidth = hostComponent.width;
					} else {
						// otherwidth, just make the background as wide as the label (with padding)
						backgroundWidth = labelDisplay.actualWidth;
					}

					// If button has height explicitly set,
					// use that size the label and background height
					if (hostComponent.explicitHeight) {
						backgroundHeight = hostComponent.height;
						Align.middle( labelDisplay, backgroundHeight, labelDisplay.actualHeight );
					} else {
						// otherwidth, just make the background as tall as the label (with padding)
						backgroundHeight = labelDisplay.height;
					}

					// use the label width to determine the background width
					setBackgroundSize( backgroundWidth, backgroundHeight );
				} else {
					// No label
					labelDisplay.text = "";
					labelDisplay.visible = false;

					// set the background to the size of the component
					setBackgroundSize( hostComponent.width, hostComponent.height );
				}
			} else {
				setBackgroundSize( hostComponent.width, hostComponent.height );
			}
			if(background) background.visible = true;
		}


		protected function setBackgroundSize( w:Number, h:Number ):void
		{
			if (background == null) return;
			if (background is IResizable) {
				(background as IResizable).setSize( w, h );
			} else {
				background.width = w;
				background.height = h;
			}
		}
	}
}
