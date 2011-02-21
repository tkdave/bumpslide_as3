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

	import com.bumpslide.ui.skin.defaults.DefaultTextInputSkin;

	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	[Event(name='change',type='flash.events.Event')]
	/**
	 * TextInput Component
	 *
	 * Supports Programattic of Flash Skinning
	 * 
	 * 
	 * @author David Knape
	 */
	public class TextInput extends Component
	{

		static public var DefaultSkinClass:Class = DefaultTextInputSkin;

		public var input_txt:TextField;

		public var hint_txt:TextField;

		private var _text:String = "";

		private var _hintText:String = "";

		public function TextInput( text:String = "", hintText:String = "" )
		{
			this.text = text;
			this.hintText = hintText;
		}


		/**
		 * Define default skin in postConstruct so that we don't override 
		 * properties set in MXML
		 */
		override protected function postConstruct():void
		{
			super.postConstruct();
			if (skin == null && skinClass == null && input_txt == null) {
				skinClass = DefaultSkinClass;
			}
			if (!explicitWidth) {
				width = 200;
			}
		}


		override protected function initSkinParts():void
		{
			super.initSkinParts();

			if (input_txt == null) input_txt = getSkinPart( 'input_txt' );
			if (hint_txt == null) hint_txt = getSkinPart( 'hint_txt' );

			if (input_txt != null) {
				input_txt.addEventListener( Event.CHANGE, handleTextInput );
				input_txt.addEventListener( FocusEvent.FOCUS_IN, handleTextBoxFocusIn );
				input_txt.addEventListener( FocusEvent.FOCUS_OUT, handleTextBoxFocusOut );
			}

			addEventListener( MouseEvent.MOUSE_DOWN, handleMouseDown );

			skinState = 'normal';
		}


		override protected function destroySkin():void
		{
			if (input_txt != null) {
				input_txt.removeEventListener( Event.CHANGE, handleTextInput );
				input_txt.removeEventListener( FocusEvent.FOCUS_IN, handleTextBoxFocusIn );
				input_txt.removeEventListener( FocusEvent.FOCUS_OUT, handleTextBoxFocusOut );
			}

			removeEventListener( MouseEvent.MOUSE_DOWN, handleMouseDown );

			super.destroySkin();
		}


		private function handleMouseDown( event:MouseEvent ):void
		{
			if (input_txt && stage.focus != input_txt) stage.focus = input_txt;
		}


		override protected function commitProperties():void
		{
			super.commitProperties();

			if (hasChanged( 'text' ) && input_txt) {
				input_txt.text = text;
				dispatchEvent( new Event( Event.CHANGE ) );
			}
			if (hasChanged( 'hintText' ) && hint_txt) hint_txt.text = hintText;
		}


		protected function handleTextInput( event:Event ):void
		{
			if (input_txt) _text = input_txt.text;
			dispatchEvent( event );
		}


		/**
		 * When text box receives focus, hide the hint text
		 */
		protected function handleTextBoxFocusIn( event:FocusEvent ):void
		{
			skinState = 'focused';
		}


		protected function handleTextBoxFocusOut( event:FocusEvent ):void
		{
			skinState = 'normal';
		}


		[Bindable(name='change')]
		public function get text():String {
			return _text;
		}


		public function set text( val:String ):void {
			_text = val;
			invalidate( 'text' );
		}


		public function get hintText():String {
			return _hintText;
		}


		public function set hintText( val:String ):void {
			_hintText = val;
			invalidate( 'hintText' );
		}


		override public function get height():Number {
			return actualHeight;
		}
	}
}
