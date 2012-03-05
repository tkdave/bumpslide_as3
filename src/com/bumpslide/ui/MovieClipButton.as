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

	import flash.display.DisplayObject;
	import com.bumpslide.util.Delegate;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	/**
	 * This class is used as the base class for MovieClips that are buttons
	 * 
	 * This is a solution for those who want to avoid button skins and just place 
	 * a textfield and background on the stage as was done in older versions of this 
	 * component library.
	 *
	 * @author David Knape
	 */
	public class MovieClipButton extends Button
	{

		// background placed on the stage
		public var background:DisplayObject;

		// dynamic text field place on the stage
		public var label_txt:TextField;

		private var _autoSize:Boolean = false;

		override protected function init() : void
		{
			super.init();
			stop();
		}


		override protected function initDefaultSkin() : void
		{
			// no skin here
		}


		/**
		 * Setup the label_txt TextField
		 * 
		 * By default, we make it a single-line auto-sized non-selectable text field
		 */
		protected function configureLabel() : void
		{
			// trace('configuring label');
			if(label_txt != null) {
				label_txt.autoSize = TextFieldAutoSize.LEFT;
				label_txt.multiline = label_txt.wordWrap = false;
				label_txt.selectable = false;
				label_txt.mouseWheelEnabled = false;
			}
		}
  		
		override protected function draw():void
		{
			try {
				var displayMethod:Function = this['_' + skinState];
				displayMethod.call( this );
			} catch (e:Error) {
				try {
					gotoAndStop( skinState );
				} catch (e:ArgumentError) {
					log('missing button state ' + skinState );
				}
			}
			
			// now, invalidate stage and wait for render event
			// so we can update content inside the frames of movieclip skins
			if (stage) {
				stage.addEventListener( Event.RENDER, handleStageRender );
				stage.invalidate();
			} else {
				Delegate.onEnterFrame( render );
			}

		}


		/**
		 * Called after a redraw
		 * 
		 * During the draw phase we issue a gotoAndStop command. And, since
		 * items on the stage are not yet accessible we have to wait for the next 
		 * render event before we can update the label text and background.
		 * 
		 * This is the function that gets called just before the frame is rendered 
		 * and is a good place to programmatically affect any clips placed on the stage.
		 */
		override protected function render():void
		{
			// render label before rendering the background

			// re-configure in case we are on a new frame
			configureLabel();

			// render label
			if(label_txt != null && label != null) {
				label_txt.text = label;
			}

			// render background
			if(background != null) {
				if(background is IResizable) {
					(background as IResizable).setSize( width, height );
				} else {
					background.width = width;
					background.height = height;
				}
			}
		}


		/**
		 * Override the width getter so background is sized to match 
		 * label when autoSize is true
		 */
		override public function get width():Number {
			if(autoSize && label_txt != null && label != "") {
				var b:Rectangle = label_txt.getBounds( this );
				return Math.round( b.left * 2 + b.width );
			} else {
				return super.width;
			}
		}


		/**
		 * Autosize the background to match the label size
		 */
		public function get autoSize():Boolean {
			return _autoSize;
		}

		[Inspectable(type="Boolean",defaultValue="false", name="Auto-size")]
		public function set autoSize( autoSize:Boolean ):void {
			_autoSize = autoSize;
			invalidate();
		}
	}
}
