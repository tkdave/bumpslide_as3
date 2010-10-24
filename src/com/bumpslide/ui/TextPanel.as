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

package com.bumpslide.ui
{

	import flash.text.TextFormat;

	/**	 * Simple Scrolling Text Panel	 * 	 * see ScrollPanel docs/samples for info on skinning	 *  	 * @author David Knape	 */
	public class TextPanel extends ScrollPanel
	{

		override protected function addChildren():void
		{
			super.addChildren();
			
			if (content == null) {
				var tb:Label = new Label();
				tb.textField.mouseEnabled = false;
				tb.textField.selectable = false;
				tb.x = -1;
				content = tb;
			}

			// bitmap caching of content sometimes messes up text fields
			// turn it off by default here
			_holder.cacheAsBitmap = false;
		}


		// Public reference to textbox content
		public function get textbox():Label {
			return content as Label;
		}


		public function get textFormat():TextFormat {
			return textbox.textFormat;
		}


		public function set textFormat( tf:TextFormat ):void {
			textbox.textFormat = tf;
			invalidate();
		}


		public function set text( s:String ):void {
			textbox.text = s;
			invalidate();
		}


		public function get text():String {
			return textbox.text;
		}


		public function set htmlText( s:String ):void {
			// content_txt.condenseWhite = true;
			textbox.htmlText = s;
			invalidate();
		}


		public function get htmlText():String {
			return textbox.htmlText;
		}
	}
}