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

	import com.bumpslide.ui.Box;
	import com.bumpslide.ui.TextInput;

	import flash.text.TextField;

	import com.bumpslide.ui.Label;
	import com.bumpslide.ui.BasicSkin;


	/**
	 * Default Skin for TextInput Component
	 *
	 * @author David Knape
	 */
	dynamic public class DefaultTextInputSkin extends BasicSkin
	{

		private var background:Box;

		private var inputText:Label;
		private var hintText:Label;

		// Skin parts 
		// (TextInput is just looking for the text fields)
		public var input_txt:TextField;

		public var hint_txt:TextField;

		public function get hostComponent():TextInput {
			return _hostComponent as TextInput;
		}


		override protected function addChildren():void
		{
			if (this['_background'] == null) {
				background = add( Box, Style.INPUT_BACKGROUND_PROPS );
			} else {
				background = this['_background'];
			}
			background.buttonMode = true;
			
			inputText = add( Label, { editable: true, maxLines: 1, selectable: true, padding: Style.INPUT_PADDING, textFormat: Style.INPUT_TEXT_FORMAT } );
			hintText = add( Label, { alpha: .5, maxLines: 1, padding: Style.INPUT_PADDING, textFormat: Style.INPUT_TEXT_FORMAT } );

			input_txt = inputText.textField;
			hint_txt = hintText.textField;
		}


		override protected function draw():void
		{
			if (hasChanged( VALID_SIZE )) {
				inputText.width = hostComponent.width;
				hintText.width = hostComponent.width;
				background.setSize( hostComponent.width, inputText.height );
			}
			
			input_txt.text = hostComponent.text;
			hint_txt.text = hostComponent.hintText;
		}
		
		
		override public function renderSkin( skinState:String ):void
		{
			super.renderSkin( skinState );
			
			input_txt.text = hostComponent.text;
			hint_txt.text = hostComponent.hintText;
		}


		public function _focused():void
		{
			hintText.visible = false;
			inputText.visible = true;

			background.backgroundColor = Style.INPUT_FOCUS_BACKGROUND;
			background.borderColor = Style.INPUT_FOCUS_BORDER;
			background.filters = [ Style.BEVEL_FILTER_INSET, Style.FOCUS_FILTER ];
		}


		public function _normal():void
		{
			hintText.color = Style.INPUT_TEXT_HINT;
			inputText.color = Style.INPUT_TEXT;

			hintText.bold = false;
			inputText.bold = false;

			hintText.visible = hostComponent.text == null || hostComponent.text.length == 0;
			inputText.visible = true;//!hintText.visible;

			background.backgroundColor = Style.INPUT_BACKGROUND;
			background.borderColor = Style.INPUT_BORDER;
			background.filters = [ Style.BEVEL_FILTER_INSET ];
		}
	}
}
