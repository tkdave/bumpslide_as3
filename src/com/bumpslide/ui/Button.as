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

package com.bumpslide.ui {	import com.bumpslide.data.constant.Position;	import com.bumpslide.data.type.Padding;	import com.bumpslide.ui.skin.defaults.DefaultButtonSkin;	import com.bumpslide.ui.skin.defaults.Style;	import com.bumpslide.util.Delegate;	import flash.events.Event;	import flash.events.FocusEvent;	import flash.events.KeyboardEvent;	import flash.events.MouseEvent;	import flash.ui.Keyboard;	import flash.ui.Multitouch;	import flash.utils.Timer;	/**	 * Base Class for Buttons	 * 	 * This is a generic button with disabled and selected states.	 * By default, setting this class as the base class for your buttons	 * will work as expected if you mark your frames with	 * 'off', 'over', 'down', 'selected', and 'disabled'	 * 	 * Alternatively, you can override the protected display/skin methods:	 * _off, _over, _down, _selected, and _disabled to do what you want.  	 * 	 * @author David Knape	 */	public class Button extends Component implements ISelectable, IGridItem {
		static public var DefaultSkinClass:Class = DefaultButtonSkin;		public static var DefaultPadding : String = "5 10";
		static public const STATE_OFF:String = 'off';		static public const STATE_OVER:String = 'over';		static public const STATE_SELECTED:String = 'selected';		static public const STATE_DISABLED:String = 'disabled';		static public const STATE_DOWN:String = 'down';		public static const EVENT_UPDATE:String = "buttonUpdate";  				protected var _isSelected:Boolean = false;		protected var _isMouseOver:Boolean = false;		protected var _isMouseDown:Boolean = false;		protected var _hasFocus:Boolean = false;  				protected var _focusStateEnabled:Boolean = false;		protected var _rollOutDelay:Number = 0;		protected var _rollOutTimer:Timer;		protected var _toggle:Boolean = false;		protected var _selectOnClick:Boolean = false;
		protected var _label:String;				protected var _padding:Padding;				// icon image 		public var iconImage:Image;				// the icon (fed to iconImage.source)		// display object, class, or url		private var _icon:*;  		
		private var _iconAlignH:String = Position.CENTER;
		private var _iconAlignV:String = Position.MIDDLE;
						public function Button( width:Number=-1, height:Number=-1, x:Number=0, y:Number=0, lbl:String="", defaultClickHandler:Function=null) {			
			super();
			
			if(width!=-1) this.width = width;
			if(height!=-1) this.height = height;
						if(x!=0) this.x = x;			if(y!=0) this.y = y;			if(lbl!="") label = lbl;			if(defaultClickHandler!=null) {				addEventListener( MouseEvent.CLICK, defaultClickHandler );			}		}				/**		 * Component initialization (provides initButton hook)		 */		override protected function init():void {			stop();			initButton();							super.init();		}		/**		 * Define default skin in postConstruct so that we don't override 		 * properties set in MXML		 */		override protected function postConstruct():void 		{
			super.postConstruct();						initDefaultSkin();
		}
		
		protected function initDefaultSkin():void {
			if(padding==null){
				padding = Style.BUTTON_PADDING;
			}
			if(skin==null && skinClass==null) {
				skinClass = DefaultSkinClass;
				//trace('using default skin '+skin);
			}
		}
				override protected function initSize():void {			super.initSize();			minHeight = 4;			minWidth = 4;		}
		/**		 * Initialized button event handlers		 */		protected function initButton():void {						buttonMode = true;			mouseChildren = false;			focusRect = false;			delayUpdate = true;						addEventListener(MouseEvent.ROLL_OVER, handleRollOver);        				addEventListener(MouseEvent.ROLL_OUT, handleRollOut);  			addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);			addEventListener(MouseEvent.CLICK, handleClick, false, 999);			addEventListener(FocusEvent.FOCUS_IN, handleFocusIn);			addEventListener(FocusEvent.FOCUS_OUT, handleFocusOut);						// render children when they are added (needed for certain frame-based state changes)			//addEventListener(Event.ADDED, render);		}
		/**		 * Update skin state based on other properties of this component prior to drawing the skin		 */ 		override protected function commitProperties():void {				if(!enabled) {				_skinState = STATE_DISABLED;			} else if (mousePressed) {				_skinState = STATE_DOWN;			} else if (selected) {				_skinState = STATE_SELECTED;			}  else if (mouseOver || (hasFocus && focusStateEnabled)) {				_skinState = STATE_OVER;			} else {				_skinState = STATE_OFF;			}			delayUpdate = false; 		}		//-----------------------		// MOUSE EVENT HANDLERS		//-----------------------		protected function handleRollOver( event:MouseEvent = null):void {			Delegate.cancel(_rollOutTimer);			_isMouseOver = true;
			if(stage) {
				stage.addEventListener(MouseEvent.MOUSE_UP, handleMouseUp, false, 0, true);
			}			invalidate(VALID_SKIN_STATE);		}
		protected function handleRollOut( event:MouseEvent = null):void {			_isMouseOver = false;			Delegate.cancel(_rollOutTimer);			if(_rollOutDelay > 0) _rollOutTimer = Delegate.callLater(rollOutDelay, doRollOut);            else doRollOut();            		}
		protected function handleMouseDown(event:MouseEvent = null):void {			_isMouseOver = true;			_isMouseDown = true;			if(stage) {
				stage.addEventListener(MouseEvent.MOUSE_UP, handleMouseUp, false, 0, true);
			}			invalidate(VALID_SKIN_STATE);		}
		protected function handleMouseUp(event:MouseEvent = null):void {			_isMouseDown = false;
			_isMouseOver = (event && hitTestPoint(event.stageX, event.stageY) && !Multitouch.supportsTouchEvents);			if(stage) stage.removeEventListener(MouseEvent.MOUSE_UP, handleMouseUp);			invalidate(VALID_SKIN_STATE);		}
				protected function handleClick(event:MouseEvent = null):void {			_isMouseDown = false;
			_isMouseOver = (event && hitTestPoint(event.stageX, event.stageY) && !Multitouch.supportsTouchEvents);			if(stage) stage.removeEventListener(MouseEvent.MOUSE_UP, handleMouseUp);			if(toggle) {				selected = !selected;
				dispatchEvent( new Event(Event.CHANGE, true) );			} else if(selectOnClick) {				selected = true;			}
			invalidate(VALID_SKIN_STATE);		}		protected function handleFocusIn(event:FocusEvent):void {			_hasFocus = true;			addEventListener(KeyboardEvent.KEY_DOWN, handleKeyPress);			invalidate(VALID_SKIN_STATE);		}		protected function handleFocusOut(event:FocusEvent):void {			_hasFocus = false;			addEventListener(KeyboardEvent.KEY_DOWN, handleKeyPress);			invalidate(VALID_SKIN_STATE);		}		protected function handleKeyPress(event:KeyboardEvent):void {			if(event.keyCode == Keyboard.ENTER) {				if(toggle) {					selected = !selected;				} else if(selectOnClick) {					selected = true;				}			}		}		protected function doRollOut():void {        				handleMouseUp();			invalidate(VALID_SKIN_STATE);		}		//-----------------------------		// GETTERS/SETTERS		//-----------------------------				override public function set enabled( buttonEnabled:Boolean ):void {			if(!buttonEnabled) _isMouseOver = false;  			useHandCursor = buttonEnabled;			mouseEnabled = buttonEnabled;			super.enabled = buttonEnabled;
			invalidate(VALID_SKIN_STATE);		}
		public function get selected():Boolean {			return _isSelected;		}
		public function set selected(val:Boolean):void {			if(_isSelected == val) return;			_isSelected = val;			_isMouseOver = false;			dispatchEvent(new Event(Event.CHANGE, true));						sendChangeEvent( 'selected', val, !val);					invalidate(VALID_SKIN_STATE);		}
		/**		 * Time from rollout event to 		 */		public function get rollOutDelay():Number {			return _rollOutDelay;		}
		public function set rollOutDelay(rollOutDelay:Number):void {			_rollOutDelay = rollOutDelay;		}
		public function get mouseOver():Boolean {			return _isMouseOver;		}
		public function get mousePressed():Boolean {			return _isMouseDown;		}
		public function get toggle():Boolean {			return _toggle;
		}
		[Inspectable(type="Boolean", defaultValue="false", name="Toggle Enabled")]
		public function set toggle(toggle:Boolean):void {			_toggle = toggle;
		}
		
		/**
		 * toggle selection status when clicked
		 */		public function get selectOnClick():Boolean {			return _selectOnClick;		}
		/**		 * automatically make button selected when it is clicked		 * 		 * Unlike toggleButton, this does not change state back to off when selected again. 		 * This is used for radio button and tab select buttons that don't have state driven 		 * by a model binding.		 * 		 * If toggle is true, this setting is ignored.		 */		public function set selectOnClick(selectOnClick:Boolean):void {			_selectOnClick = selectOnClick;		}		/**		 * Whether or not the button currently has input focus		 */		public function get hasFocus():Boolean {			return _hasFocus;		}				/**		 * Whether or not to show overState when focused		 */		public function get focusStateEnabled():Boolean {			return _focusStateEnabled;		}				public function set focusStateEnabled(focusEnabled:Boolean):void {			_focusStateEnabled = focusEnabled;		}				/**		 * setter for onClick handlers		 */		public function set onClick( f:Function ):void {			addEventListener( MouseEvent.CLICK, f, false, 0, true );		}				/**		 * The label string		 */		public function get label():String {
			if(_label==null && gridItemData) {
				return _gridItemData;
 			} else {
 				return _label;
			}		}		
		[Inspectable(type="String", defaultValue="")]		public function set label(label:String):void {			_label = label;
			//trace('setting label to ' + label );			invalidate(VALID_SKIN_STATE);		}				public function get padding():Padding {			return _padding;		}				/**		 * padding around content		 * 		 * This value is passed directly to the label in the default button skin.		 */		public function set padding ( p:* ) : void {			_padding = Padding.create( p );			invalidate(VALID_SIZE);		}				override public function get width():Number {			if(explicitWidth==0) {				return actualWidth;			} else {				return super.width;			}		}				private var _gridIndex:Number;		private var _gridItemData:*;				public function get gridIndex():Number {			return _gridIndex;		}						public function get gridItemData():* {			return _gridItemData;		}						public function set gridIndex(n:Number):void {			_gridIndex = n;		}						public function set gridItemData(d:*):void {			_gridItemData = d;			invalidate(VALID_SKIN_STATE);
			invalidate(VALID_DATA);		}						public function get icon():* {			return _icon;		}						public function set icon(icon:*):void {			_icon = icon;			if(iconImage==null) {				iconImage = add( Image, {alignH:iconAlignH, alignV:iconAlignV } );			}						iconImage.source = icon;		}						public function get iconAlignV():String {			return _iconAlignV;		}						public function set iconAlignV(iconAlignV:String):void {			_iconAlignV = iconAlignV;			if(iconImage) iconImage.alignV = _iconAlignV;			invalidate();		}						public function get iconAlignH():String {			return _iconAlignH;		}						public function set iconAlignH(iconAlignH:String):void {			_iconAlignH = iconAlignH;			if(iconImage) iconImage.alignH = _iconAlignH;			invalidate();		}					}}