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

package com.bumpslide.ui {

	import com.bumpslide.data.constant.Direction;
	import com.bumpslide.data.type.Padding;
	import com.bumpslide.events.UIEvent;
	import com.bumpslide.ui.skin.defaults.DefaultPanelSkin;
	import com.bumpslide.ui.skin.defaults.Style;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	/**	 * Simple Container with Background box and padding.	 * 	 * This is a core base class for the scroll panels and grids	 * 	 * This component can be instantiated via code, or it can be created 	 * inside a FLA.  Missing pieces will be dynamically added to the 	 * display list. Background is no longer transparent by default.  We still 	 * need it for absorbing certain mouse events in various child components.	 * 
	 * Update 2010-10: Background is now drawn with skin. 
	 * 	 * @author David Knape	 */	public class Panel extends Component 	{
		static public var DefaultSkinClass:Class = DefaultPanelSkin;		// children		public var background:DisplayObject;		public var viewrect:Sprite; // avatar on stage to determine content padding		protected var _content:DisplayObject;		protected var _holder:Sprite;		// content and scrollbar padding in relationship to background		protected var _padding:Padding; 		protected var _autoSizeHeight:Boolean = false;		protected var _constructorArgs:Array;				private var _backgroundVisible:Boolean = true;

		private var _handlingChildSizeChange:Boolean=false;
				
		private var _contentVisible:Boolean = true;
		
		private var _title:String;
				function Panel( content:DisplayObject = null, padding:*=  null, background_color:uint = NaN, background_alpha:Number = NaN):void 		{
			//trace(this+' CTOR');
			_holder = add( Sprite );			_constructorArgs = arguments;			super();		}				override protected function postConstruct():void 		{
			super.postConstruct();						// apply constructor arguments			if(_constructorArgs!=null) {				if(content==null) content = _constructorArgs[0];				if(_constructorArgs[1]!=null) padding = _constructorArgs[1];				if(backgroundBox != null && !isNaN( _constructorArgs[2])) backgroundBox.backgroundColor = _constructorArgs[2];				if(!isNaN( _constructorArgs[3])) background.alpha = _constructorArgs[3];			}
			
			initDefaultSkin();
		}


		protected function initDefaultSkin():void
		{
			// init default skin if there is none set (and there was no background on stage)
			if(background == null && skin == null && skinClass==null) {
				skinClass = DefaultSkinClass;
			}
		}
				override protected function initSize():void 		{
			super.initSize();						if(explicitWidth == 0 && explicitHeight == 0) {				width = 256;				height = 256;			}
		}
		
		
		override protected function initSkin() : void
		{
			super.initSkin();
			
			// wire up the close button if it's here
			var closeButton:DisplayObject = getSkinPart('closeButton');
			if(closeButton)
			closeButton.addEventListener( MouseEvent.CLICK, function (e:Event):void {
				contentVisible = !contentVisible;
			} );
		}
				/**		 * init		 */		override protected function addChildren():void 		{						//debugEnabled = true;									delayUpdate = false;			initPadding();
			addEventListener( Component.EVENT_SIZE_CHANGED, handleChildSizeChange, true );
		}


		protected function handleChildSizeChange( event:UIEvent ) : void
		{
			
			if(event.target.parent == _holder) {
				//trace( '[Panel] child size changed ' , event.target);
				_handlingChildSizeChange = true;
				invalidate(VALID_SIZE);
				//updateNow();
			}
		}
						override public function destroy():void 		{			destroyChild(content);			super.destroy();		}				/**		 * Uses viewrect on stage to determine appropriate padding		 * By default, the _defaultPadding value is used		 */		protected function initPadding():void 		{			// define padding using viewrect component on stage 			if(viewrect != null) {				var b:Rectangle = viewrect.getBounds(this);								_padding = new Padding(b.y, width - b.right, height - b.bottom, b.x);				removeChild(viewrect);			}		}				override public function layoutChildren():void 		{
			super.layoutChildren();			drawBackground();			positionContent();
		}
				/**		 * Draws the background (default now handled by skin)		 */		protected function drawBackground():void 		{
			// leaving this method here for backwards compatability
			if(background) {
				background.width = width;
				background.height = height;
			}		}				/**		 * Positions holder and sizes scroll rect for no scrollbar 		 */		override protected function draw():void 		{			
			
			if(!_handlingChildSizeChange) {											setContentSize(contentWidth, contentHeight);
			}						
			super.draw();
			
			_handlingChildSizeChange = false;		}				protected function positionContent():void 		{			_holder.x = padding.left;			_holder.y = padding.top;		}				protected function setContentSize(w:Number, h:Number):void 		{			//trace('setContentSize ' +w, h );
			
			// mask
			scrollRectSet('width', contentWidth);
			scrollRectSet('height', contentHeight);
						if(autoSizeHeight) {				if(content) content.width = contentWidth;
				if(content is Component) {
					(content as Component).updateNow();
				}							} else {														if(content is IResizable) {					(content as IResizable).setSize(w, h);				}			}
			
							}				protected function scrollRectSet( prop:String, value:Number ):void 		{			if(_holder == null) return;			if(_holder.scrollRect == null) _holder.scrollRect = new Rectangle();			var rect:Rectangle = _holder.scrollRect;			rect[prop] = Math.round(value);			log( rect );
			_holder.scrollRect = rect;		}				//-------------------		// GETTERS/SETTERS		//-------------------				/**		 * The content being scrolled		 */			public function set content( c:DisplayObject ):void {	
			
			log('set content = '+c);
						// if we had old content, remove it			if(_content != null && _holder.contains(_content) ) {				_holder.removeChild(_content);			}			// add to stage inside holder						if(c != null) _holder.addChild(c);										_content = c;			invalidate();		}				public function get content():DisplayObject {			return _content;		}				public function get contentWidth():Number {			return width - padding.width;		}				public function get contentHeight():Number {			return height - padding.height;		}				public function set padding( p:* ):void {			_padding = Padding.create( p );			invalidate();		}						public function get padding():Padding {
			if(_padding==null) _padding = new Padding(Style.PANEL_PADDING);			return _padding;		}				/**		 * If background was not explicitly set or placed on the stage, this is the default background		 */		public function get backgroundBox():Box {			if(background is Box) {				return background as Box;			} else {				return null;			}		}				public function get autoSizeHeight():Boolean {			return _autoSizeHeight;		}				public function set autoSizeHeight(autoSize:Boolean):void {			_autoSizeHeight = autoSize;			invalidate();		}				override public function get height():Number {			// get display object height.  Calls actualHeight getter from component class if found			// this is overriden by TextBox to return the 			var contentheight:Number = content ? (content is Component ? (content as Component).actualHeight : content.height) : 0;
			if(!contentVisible) return padding.height;			else return (autoSizeHeight) ? contentheight + padding.height : super.height;		}						public function get backgroundVisible():Boolean {			return _backgroundVisible;		}						public function set backgroundVisible(backgroundVisible:Boolean):void {			_backgroundVisible = backgroundVisible;			invalidate();		}

		
		public function get contentVisible() : Boolean {
			return _contentVisible;
		}

		public function set contentVisible( contentVisible:Boolean ) : void {
			_contentVisible = contentVisible;
			_holder.visible = _contentVisible;
			invalidate(VALID_SIZE);
		}


		override public function set children( display_objects:Array ) : void {
			if(display_objects.length>1 && content == null) {
				content = new Container( Direction.VERTICAL );
				(content as Container).children = display_objects;
			} else if (display_objects.length == 1) {
				content = display_objects[0];		
			}
		}

		
		/**
		 * Optional title for display
		 */
		public function get title() : String {
			return _title;
		}


		public function set title( title:String ) : void {
			_title = title;
			invalidate();
		}
	}}