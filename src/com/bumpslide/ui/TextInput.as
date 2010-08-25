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
	 * @author David Knape
	 * @version SVN: $Id: $
	 */
	public class TextInput extends Component 
	{
		static public var DefaultSkinClass:Class = DefaultTextInputSkin;

		public var input_txt:TextField;
		public var hint_txt:TextField;		
		
		private var _text:String="";
		private var _hintText:String="";

		
		public function TextInput( text:String="", hintText:String="") 
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
			if(skin==null && skinClass==null && input_txt==null) {
				skinClass = DefaultSkinClass;
			}
			if(!explicitWidth) {
				width = 200;
			}
		}
		
		override protected function initSkin():void 
		{
			super.initSkin();
			
			if(input_txt==null) input_txt = getSkinPart('input_txt');
			if(hint_txt==null) hint_txt = getSkinPart('hint_txt');
			
			if(input_txt!=null) {		
				input_txt.addEventListener(Event.CHANGE, handleTextInput);
				input_txt.addEventListener(FocusEvent.FOCUS_IN, handleTextBoxFocusIn);
				input_txt.addEventListener(FocusEvent.FOCUS_OUT, handleTextBoxFocusOut);
			}			
			
			addEventListener( MouseEvent.MOUSE_DOWN, handleMouseDown );
			
			skinState = 'normal';
		}

		
		override protected function destroySkin():void 
		{
			
			
			if(input_txt!=null) {		
				input_txt.removeEventListener(Event.CHANGE, handleTextInput);
				input_txt.removeEventListener(FocusEvent.FOCUS_IN, handleTextBoxFocusIn);
				input_txt.removeEventListener(FocusEvent.FOCUS_OUT, handleTextBoxFocusOut);
			}	
			
			removeEventListener( MouseEvent.MOUSE_DOWN, handleMouseDown );
			
			super.destroySkin();
		}

		
		private function handleMouseDown(event:MouseEvent):void 
		{
			if(input_txt && stage.focus!=input_txt) stage.focus = input_txt;
		}

		
		override protected function commitProperties():void 
		{
			super.commitProperties();
			
			if(hasChanged('text') && input_txt) input_txt.text = text;
			if(hasChanged('hintText') && hint_txt) hint_txt.text = hintText;
			
			
		}

		
		protected function handleTextInput(event:Event):void {
			if(input_txt) _text = input_txt.text;
			dispatchEvent( event );
		}
		
		/**
		 * When text box receives focus, hide the hint text
		 */
		protected function handleTextBoxFocusIn(event:FocusEvent):void {
			skinState='focused';
		}

		protected function handleTextBoxFocusOut(event:FocusEvent):void {
			skinState='normal';
		}
		
		public function get text():String {
			return _text;
		}
		
		
		public function set text(val:String):void {
			_text = val;
			invalidate('text');
		}
		
		public function get hintText():String {
			return _hintText;
		}
		
		
		public function set hintText(val:String):void {
			_hintText = val;
			invalidate('hintText');
		}
		
		override public function get height():Number {
			return actualHeight;
		}
	}
}
