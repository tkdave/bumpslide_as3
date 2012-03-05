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

	import com.bumpslide.ui.Component;
	import com.bumpslide.ui.IResizable;
	import com.bumpslide.ui.Slider;

	import flash.display.MovieClip;


	/**
	 * Movie Clip SliderSkin
	 *
	 * @author David Knape
	 */
	public class BasicSliderSkin extends BasicSkin implements ISkin
	{

		public var handle:MovieClip;

		public var background:MovieClip;

		/**
		 * Best Practice: create a typed hostComponent getter for type safety
		 */
		public function get hostComponent():Slider {
			return _hostComponent as Slider;
		}


		override public function initHostComponent( host_component:ISkinnable ):void
		{
			super.initHostComponent( host_component );

			if (hostComponent == null) {
				throw new Error( 'SliderSkin is meant to be used with a Slider component.' );
			}

			background.buttonMode = true;
			handle.buttonMode = true;
			handle.mouseChildren = false;
		}


		override protected function draw():void
		{
			drawBack();
			drawHandle();
		}


		/**
		 * Draws the back of the slider.
		 */
		protected function drawBack():void
		{
			if (background == null || hostComponent==null) return;

			if (background is IResizable) {
				(background as IResizable).setSize( hostComponent.width, hostComponent.height );
			} else {
				background.height = hostComponent.height;
				background.width = hostComponent.width;
			}
		}


		/**
		 * Draws the handle of the slider.
		 */
		protected function drawHandle():void
		{
			// trace('draw handle');

			if (handle == null || hostComponent==null) return;

			var hs:Number = hostComponent.getHandleSize();
			if (hostComponent.isVertical) {
				handle.height = hs;
				handle.width = hostComponent.width - hostComponent.padding.width;
				handle.x = hostComponent.padding.left;
				handle.y = hostComponent.getCalculatedHandlePosition();
			} else {
				handle.width = hs;
				handle.height = hostComponent.height - hostComponent.padding.height;
				handle.x = hostComponent.getCalculatedHandlePosition();
				handle.y = hostComponent.padding.top;
			}
			if (handle is Component) {
				Component( handle ).updateNow();
			}
		}
	}
}
