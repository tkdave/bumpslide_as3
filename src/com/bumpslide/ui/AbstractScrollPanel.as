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

package com.bumpslide.ui {	import com.bumpslide.ui.skin.defaults.Style;	import com.bumpslide.data.constant.Direction;
	import flash.events.MouseEvent;	/**	 * Base class for ScrollPanel, TextPanel, and Grid	 *    	 * @author David Knape	 */	public class AbstractScrollPanel extends Panel {		// the scrollbar		public var scrollbar:Slider;				protected var _scrollbarClass:Class = Slider;				// the current scroll position 		protected var _scrollPosition:Number=0;			// amount to scroll for each click		protected var _scrollAmount:Number=8;		// width of scrollbar (height when horizontal)		protected var _scrollbarWidth:Number=Style.SCROLLBAR_WIDTH;		// space between scrollbar and content		protected var _gap:Number=Style.SCROLLBAR_GAP;		// options		protected var _showScrollbarWhenDisabled:Boolean=false;		protected var _orientation:String=Direction.VERTICAL;		protected var _tweenEnabled:Boolean=true;		protected var _scrollbarClassChanged:Boolean = false;		protected var _tweenEasingFactor:Number = .3;		private var _hideScrollbar:Boolean = false;
		
		private var _mouseWheelScroll:Boolean = true;				/**		 * Created background and scrollbar is they don't already exist,		 * and assigns this class to be the scrollTarget of the scrollbar (VSlider)		 */		override protected function addChildren():void {								super.addChildren();						initScrollbar();						// cache content as bitmap for smoother scrolling			_holder.cacheAsBitmap = true;						// listen for mouse wheel			addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);		}		
		protected function initScrollbar():void {			//trace('init scrollbar');
			if(_scrollbarClassChanged) {								destroyChild( scrollbar );			}
			
			//trace('scrollbar='+scrollbar);						if(scrollbar == null || _scrollbarClassChanged) {				_scrollbarClassChanged = false;				scrollbar = new scrollbarClass() as Slider;				scrollbar.orientation = isVertical ? Direction.VERTICAL : Direction.HORIZONTAL;								addChild(scrollbar);				_scrollbarClassChanged = false;			} else { 				scrollbarWidth = isVertical ? scrollbar.width : scrollbar.height;			}					initScrollTarget();			}				/**		 * Handle mouse wheel scrolling		 */		protected function onMouseWheel(event:MouseEvent):void {
			if(!mouseWheelEnabled) return;			scrollbar.value -= event.delta * scrollAmount;			scrollbar.scrollTarget.scrollPosition = scrollbar.value;		}		/**		 * Initialize the scroll target		 */		protected function initScrollTarget():void {			throw new Error('This should be overriden in a subclass,');		}				/**		 * update size, position, and visibility of child components		 */		override protected function draw():void {							// first size content to fill (no scrollbar)
			super.draw();			//setContentSize(contentWidth, contentHeight);						// if scrollbar doesn't exist, we haven't been fully initialized, get out			if(!scrollbar) return;						// see if scroll bar is necessary			var scroll_needed:Boolean = scrollbar.scrollTarget && (scrollbar.scrollTarget.totalSize > scrollbar.scrollTarget.visibleSize);			
			// size the scrollbar regardless of whether or not we need it
			if(isVertical) {
				scrollbar.setSize( scrollbarWidth, height-padding.height);
			} else {
				scrollbar.setSize( width-padding.width, scrollbarWidth );
			}
							// if we need a scrollbar, resize the content to accomodate the scrollbar			if((scroll_needed || showScrollbarWhenDisabled) && !_hideScrollbar) {								// we need a scrollbar, show it and size it				scrollbar.visible = true;									if(isVertical) {					setContentSize(contentWidth - (scrollbar.width + gap), contentHeight);				} else {					setContentSize(contentWidth, contentHeight - (scrollbar.height + gap));				}			} else {				// no need for a scrollbar, hide it and kill the scrollRect				scrollbar.visible = false;				_holder.scrollRect = null; 			}						// update scrollbar value (just in case)			constrainScrollPosition();			scrollbar.value = scrollbar.scrollTarget.scrollPosition;			
								}				override public function layoutChildren():void 		{			positionContent();			positionScrollbar();
			super.layoutChildren();		
		}
				/**		 * Override this is you want the scrollbar someplace else		 */		protected function positionScrollbar():void {			if(isVertical) {				scrollbar.move( width-scrollbarWidth-padding.right, padding.top);			} else {				scrollbar.move( padding.left, height-scrollbarWidth-padding.bottom );			}					}				protected function constrainScrollPosition():void {			if(scrollbar.scrollTarget.totalSize <= scrollbar.scrollTarget.visibleSize) _scrollPosition = 0;			else _scrollPosition = Math.max(minScrollPosition, Math.min(maxScrollPosition, _scrollPosition));		}		
		public function get maxScrollPosition():Number {
			return scrollbar.scrollTarget.totalSize - scrollbar.scrollTarget.visibleSize;
		}
		
		public function get minScrollPosition():Number {
			return 0;
		}
		
		/**		 * Reset scroll to 0 and refresh (after content change)		 */		public function reset():void {				_scrollPosition = 0;			scrollbar.value = 0;			scrollbar.updateNow();			invalidate();		}		//-------------------		// GETTERS/SETTERS		//-------------------		/**		 * horizontal or vertical orientation		 */		public function get orientation():String {			return _orientation;		}		public function set orientation(orientation:String):void {			if(_orientation == orientation) return;			_orientation = orientation;			scrollbar.orientation = orientation;				updateNow();			//trace('done');		}		/**		 * if false, scrollbar is hidden when not needed (default:true)		 */		public function get showScrollbarWhenDisabled():Boolean {			return _showScrollbarWhenDisabled;		}		public function set showScrollbarWhenDisabled(showScrollbarWhenDisabled:Boolean):void {			_showScrollbarWhenDisabled = showScrollbarWhenDisabled;			invalidate();		}		/**		 * number of pixels between scrollbar and content		 */		public function get gap():Number {			return _gap;		}		public function set gap(gap:Number):void {			if(_gap==gap) return;			_gap = gap;			invalidate();		}		public function get scrollAmount():Number {			return _scrollAmount;		}		public function set scrollAmount(scrollAmount:Number):void {			_scrollAmount = scrollAmount;		}		public function get scrollbarWidth():Number {			return _scrollbarWidth;		}		public function set scrollbarWidth(scrollbarWidth:Number):void {			_scrollbarWidth = scrollbarWidth;		}		public function get tweenEnabled():Boolean {			return _tweenEnabled;		}		public function set tweenEnabled(tweenEnabled:Boolean):void {			_tweenEnabled = tweenEnabled;		}		public function get isVertical():Boolean {			return orientation == Direction.VERTICAL;		}				public function get scrollbarClass():Class {			return _scrollbarClass;		}				public function set scrollbarClass(scrollbarClass:Class):void {			_scrollbarClass = scrollbarClass;			_scrollbarClassChanged = true;			initScrollbar();			scrollbarWidth = isVertical ? scrollbar.width : scrollbar.height;			invalidate();		}				public function get tweenEasingFactor():Number {			return _tweenEasingFactor;		}				public function set tweenEasingFactor(tweenEasingFactor:Number):void {			_tweenEasingFactor = tweenEasingFactor;		}		public function get hideScrollbar():Boolean {			return _hideScrollbar;		}		public function set hideScrollbar( hideScrollbar:Boolean ):void {			_hideScrollbar = hideScrollbar;			invalidate();		}		public function get mouseWheelEnabled():Boolean {			return _mouseWheelScroll;		}		public function set mouseWheelEnabled( val:Boolean ):void {			_mouseWheelScroll = val;		}

	}}