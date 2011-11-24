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
	import com.bumpslide.ui.skin.BasicSkin;


	/**
	 * Default Skin for TextInput Component
	 *
	 * @author David Knape
	 */
	dynamic public class DefaultTextInputSkin extends BasicSkin
	{
		public var inputText:Label;
		public var hintText:Label;
		
		// Skin parts (TextInput is just looking for the text fields)
		public var input_txt:TextField;
		public var hint_txt:TextField;
		private var background:Box;

		public function get hostComponent():TextInput {
			return _hostComponent as TextInput;
		}


		override protected function addChildren():void
		{
			if (this['_background'] == null) {
				background = addChild( new Box( 0xffffff, 1, 1, 0, 0, Style.BUTTON_CORNER_RADIUS, 1, 0xaaaaaa ) ) as Box;
				background.filters = [ Style.BEVEL_FILTER_INSET ];
			} else {
				background = this['_background'];
			}
			background.buttonMode = true;

			inputText = add( Label, { editable:true, maxLines:1, selectable:true, padding:5 } );
			hintText = add( Label, { alpha:.5, maxLines:1, padding:5 } );

			input_txt = inputText.textField;
			hint_txt = hintText.textField;
		}


		override public function renderSkin( skinState:String ):void
		{
			super.renderSkin( skinState );

			inputText.width = hostComponent.width;
			hintText.width = hostComponent.width;
			background.setSize( hostComponent.width, inputText.height );
		}


		public function _focused():void
		{
			// Should this logic be in the component? 
			// Reflex says it goes in the Behavior
			// Maybe we should put it in an observable view-model
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
						
			// Should this logic be in the component?
			hintText.visible = hostComponent.text == null || hostComponent.text.length == 0;
			inputText.visible = !hintText.visible;

			background.backgroundColor = Style.INPUT_BACKGROUND;
			background.borderColor = Style.INPUT_BORDER;
			background.filters = [ Style.BEVEL_FILTER_INSET ];
		}


		override protected function draw():void
		{
			inputText.width = hostComponent.width;
			hintText.width = hostComponent.width;
		}
	}
}
