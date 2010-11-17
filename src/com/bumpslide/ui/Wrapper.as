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
	import com.bumpslide.events.UIEvent;

	import mx.core.UIComponent;
	import mx.core.mx_internal;

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.system.ApplicationDomain;

	/**
	 * Component Wrapper for Flex
	 * 
	 * inspired by gkinner's display object wrapper
	 * refactored and updated to work with bumpslide UI components
	 * as well as normal display objects
	 *  
	 * @author David Knape
	 */
	[DefaultProperty('content')]

	public class Wrapper extends UIComponent 
	{

		private var _content:DisplayObject;

		private var _watchSize:Boolean;

		
		/**
		 * Creates a new wrapper with content passed in as constructor arg
		 */
		public function Wrapper(p_content:*= null, p_watchSize:Boolean = false) 
		{
			content = p_content;
			watchSize = p_watchSize;
			super();
		}

		[Inspectable]
		public function set watchSize(value:Boolean):void {
			_watchSize = value;
			
			if (_watchSize) {
				addEventListener(Event.ENTER_FRAME, checkSize);
			} else {
				removeEventListener(Event.ENTER_FRAME, checkSize);
			}
		}

		
		public function get watchSize():Boolean {
			return _watchSize;
		}

		[Inspectable]
		public function set content(p_content:*):void {
			if (_content != null && contains(_content)) {
				removeChild(_content);
			}
			
			if (p_content is String) {
				try {
					p_content = ApplicationDomain.currentDomain.getDefinition(p_content);
				} catch (e:*) {
				}
			}
			if (p_content is Class) {
				p_content = new p_content();
			}
			_content = p_content as DisplayObject;
			if (_content != null) {
				addChild(_content);
			}
			
			// list for component redraw and invalidate size
			addEventListener( Component.EVENT_SIZE_CHANGED, function( event:UIEvent ):void {
				invalidateSize();
			});
			
			invalidateSize();
		}

		
		public function get content():DisplayObject {
			return _content;
		}

		
		override protected function measure():void 
		{
			measuredWidth = contentWidth;
			measuredHeight = contentHeight;
		}

		
		private function checkSize(evt:Event):void 
		{
			if (mx_internal::_width != contentWidth || mx_internal::_height != contentHeight) {
				invalidateSize();
			}
		}
		
		private function get contentWidth():Number {
			return (_content) ? _content.width : 0;
		}

		
		private function get contentHeight():Number {
			return (_content) ? _content.height : 0;
		}

		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void 
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			if(content is IResizable) {
				(content as IResizable).setSize(unscaledWidth, unscaledHeight);
			} else {
				content.width = unscaledWidth;
				content.height = unscaledHeight;
			}
		}
		
		
	}
}
