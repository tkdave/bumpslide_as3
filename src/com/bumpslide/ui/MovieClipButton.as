package com.bumpslide.ui 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	/**
	 * This class is used as the base class for MovieClips that are buttons
	 * 
	 * This is a solution for those who want to avoid button skins and just place 
	 * a label and background on the stage as was done in older versions of this 
	 * component library.
	 *
	 * @author David Knape
	 * @version SVN: $Id: $
	 */
	public class MovieClipButton extends Button 
	{
		private var _autoSize:Boolean = false;
		
		public var background:MovieClip;
		public var label_txt:TextField;
		
		/**
		 * Add label configuration hook to startup sequence
		 */
		override protected function addChildren():void {		
			super.addChildren();
			configureLabel();
		}
		
		
		/**
		 * Setup the label_txt TextField
		 * 
		 * By default, we make it a single-line auto-sized non-selectable text field
		 */
		protected function configureLabel() : void {
			if(label)
			label_txt.autoSize = TextFieldAutoSize.LEFT;
			label_txt.multiline = label_txt.wordWrap = false;
			label_txt.selectable = false;
			label_txt.mouseWheelEnabled = false;
		}
		
		override protected function draw():void 
		{
			super.draw();
			gotoAndStop( skinState );
			
			if(stage) {
				stage.addEventListener(Event.RENDER, handleStageRender);
				stage.invalidate();
			} else {
				callLater(50, render);
			}	
		}

		private function handleStageRender(e:Event):void {
			if(stage) stage.removeEventListener(Event.RENDER, handleStageRender);
			render();
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
		protected function render():void {		
			
			// render label before rendering the background
			if(label_txt!=null && label!=null) {
				label_txt.text = label;
			}
			
			if(background!=null) {
				background.width = width;
				background.height = height;
			}
		}
		
		
		/**
		 * Override the width getter so background is sized to match 
		 * label when autosizeWidth is true
		 */		
		override public function get width():Number {
			if(autoSize && label_txt!=null && label!="") {
				var b:Rectangle = label_txt.getBounds( this );
				return Math.round( b.left*2 + b.width );
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
		
		
		public function set autoSize(autoSize:Boolean):void {
			_autoSize = autoSize;
			invalidate();
		}
	}
}
