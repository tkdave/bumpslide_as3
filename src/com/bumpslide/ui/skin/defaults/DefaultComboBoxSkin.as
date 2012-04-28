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

	import com.bumpslide.ui.Button;
	import com.bumpslide.ui.PixelIcon;
	import com.bumpslide.ui.BasicSkin;


	/**
	 * DefaultComboBoxSkin
	 *
	 * @author David Knape
	 */
	public class DefaultComboBoxSkin extends BasicSkin
	{
		public var arrowIcon:Array = [ '*****', ' ***', '  *' ];
		public var icon:PixelIcon;
		private var background:Button;

		override protected function addChildren():void
		{
			background = new Button( 100, 20, 0, 0, 'Select...' );
			icon = new PixelIcon( arrowIcon );
			addChild( icon );
		}


		protected function createBackground():void
		{
			if (background == null) {
				background = new Button();
				background.setSize( width, height );
				addChild( background );

				// we're in code-only mode, so draw an icon
				icon = new PixelIcon( [ '*****', ' ***', '  *' ] );
				addChild( icon );
			}
		}


		override public function renderSkin( skinState:String ):void
		{
			super.renderSkin( skinState );
		}
	}
}
