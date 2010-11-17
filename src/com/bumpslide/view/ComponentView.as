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

package com.bumpslide.view 
{

	import com.bumpslide.ui.IResizable;
	import com.bumpslide.util.Align;

	import flash.display.DisplayObject;

	/**
	 * IView implementation that uses TweenLite to fadeIn/fadeOut
	 * 
	 * This view is designed to wrap any display object and facilitate
	 * display management from a ViewStack.
	 * 
	 * If the content is a Bumpslide UI Component, this 
	 */
	public class ComponentView extends BasicView 
	{

		private var _content:DisplayObject;
		
		protected var _centerContent:Boolean = false;
		protected var _resizeContent:Boolean = true;
		protected var _contentPercentWidth:Number = 1.0;
		protected var _contentPercentHeight:Number = 1.0;
		
		public function ComponentView( childContent:DisplayObject=null ) 
		{
			content = childContent;
			super();
		}

		
		override protected function draw():void 
		{
			if(hasChanged(VALID_SIZE)) {
				sizeContent();
			}
			super.draw();
		}


		protected function sizeContent():void
		{	
			if(resizeContent) {
				if (content is IResizable) {
					(content as IResizable).setSize( width * contentPercentWidth, height * contentPercentHeight );
				} else {
					content.width = width * contentPercentWidth;
					content.height = height * contentPercentHeight;
				}
			}
			
			if(centerContent) {
				Align.center( content, width );
				Align.middle( content, height );
			} else {
				content.x = 0;
				content.y = 0;
			}
			
		}

		
		override public function destroy():void 
		{
			super.destroy();
			destroyChild( content );
		}


		public function get content():DisplayObject {
			return _content;
		}


		public function set content( value:DisplayObject ):void {
			if(_content) destroyChild( _content );
			_content = value;
			if(_content) addChild( _content );
			invalidate( VALID_SIZE );
		}


		public function get resizeContent():Boolean {
			return _resizeContent;
		}


		public function set resizeContent( resizeContent:Boolean ):void {
			if(_resizeContent == resizeContent) return;
			_resizeContent = resizeContent;
			invalidate(VALID_SIZE);
		}


		public function get contentPercentWidth():Number {
			return _contentPercentWidth;
		}


		public function set contentPercentWidth( contentPercentWidth:Number ):void {
			if(_contentPercentWidth == contentPercentWidth) return;
			_contentPercentWidth = contentPercentWidth;
			invalidate(VALID_SIZE);
		}


		public function get contentPercentHeight():Number {
			return _contentPercentHeight;
		}


		public function set contentPercentHeight( contentPercentHeight:Number ):void {
			if(_contentPercentHeight == contentPercentHeight) return;
			_contentPercentHeight = contentPercentHeight;
			invalidate(VALID_SIZE);
		}


		public function get centerContent():Boolean {
			return _centerContent;
		}


		public function set centerContent( centerContent:Boolean ):void {
			if(_centerContent == centerContent) return;
			_centerContent = centerContent;
			invalidate(VALID_SIZE);
		}

		
	}
}