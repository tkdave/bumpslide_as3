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

	import com.bumpslide.ui.Button;
	
	

	import mx.core.SpriteAsset;

	/**
	 * ImageButtonSkin
	 *
	 * @author David Knape
	 * @version SVN: $Id: $
	 */
	public class ImageButtonSkin extends BasicSkin
	{

		[Embed(source="/assets/button_bg.png",scaleGridTop="5", scaleGridLeft="5", scaleGridRight="35",  scaleGridBottom="17")]
		private var embeddedImage:Class;

		private var background:SpriteAsset;
		
		/**
		 * Assume host component is a button
		 */
		public function get hostComponent():Button {
			return _hostComponent as Button;
		}
		
		override public function initHostComponent( host_component:ISkinnable ):void
		{
			super.initHostComponent( host_component );
			background = new embeddedImage() as SpriteAsset;
			addChild( background );
		}


		override public function renderSkin( skinState:String ):void
		{
			super.renderSkin( skinState );

			background.width = hostComponent.width;
			background.height = hostComponent.height;
		}


		public function _over():void
		{
			alpha = .8;
		}


		public function _off():void
		{
			alpha = 1.0;
		}


		public function _down():void
		{
			alpha = .8;
		}


		public function _disabled():void
		{
			alpha = .5;
		}
	}
}
