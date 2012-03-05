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

	import com.bumpslide.tween.FTween;
	import com.bumpslide.view.ComponentView;
	import com.bumpslide.view.IView;
	import com.bumpslide.view.ViewLoader;

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;

	[Event(name="onLightboxOpened", type="com.bumpslide.events.UIEvent")]
	[Event(name="onLightboxClosed", type="com.bumpslide.events.UIEvent")]
	
	[Event(name="close", type="flash.events.Event")]
		
	
	/**	 * Lightbox	 * 	 * @author David Knape	 */
	public class Lightbox extends ViewLoader
	{

		public static const EVENT_OPENED:String = "onLightboxOpened";
		public static const EVENT_CLOSED:String = "onLightboxClosed";
		
		
		
		private var _background:Box;
		private var _content:DisplayObject;
		
		protected var _resizeContent:Boolean = false;
		protected var _centerContent:Boolean = true;
		protected var _contentPercentWidth:Number = .7;
		protected var _contentPercentHeight:Number = .7;
		

		public function Lightbox( match_stage_size:Boolean = true, center_content:Boolean = true )
		{
			if (match_stage_size) {
				addEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
				addEventListener( Event.REMOVED_FROM_STAGE, onRemovedFromStage );
			}
			
			centerContent = center_content;

		}


		override protected function addChildren():void
		{
			// add background and listen for click events
			_background = new Box( 0x000000 );
			_background.visible = false;
			_background.backgroundAlpha = .50;
			_background.buttonMode = true;
			_background.addEventListener( MouseEvent.CLICK, close );
			addChild( _background );
			
			delayUpdate = false;
		}


		protected function onAddedToStage( event:Event ):void
		{
			stage.addEventListener( Event.RESIZE, onStageResize );
			onStageResize();
		}


		protected function onRemovedFromStage( event:Event ):void
		{
			stage.removeEventListener( Event.RESIZE, onStageResize );
		}
		
		

		override protected function draw():void
		{
			FTween.ease( background, 'autoAlpha', (content==null) ? 0 : 1, .5, { minDelta: .01} );
			
			super.draw();
		}
		
		override protected function sizeContent():void {
			
			// extra big so it covers when resizing browser bigger
			_background.setSize( width + 500, height + 500 );
			
			if(currentView is IResizable) {
				( currentView as IResizable).setSize( width, height );
			}
		}


		/**		 * Opens lightbox with supplied display object added to the display list		 */
		public function open( displayObj:DisplayObject ):void
		{
			content = displayObj;
		}


		/**		 * Closes lightbox and removes content from the display list		 */
		public function close( e:Event = null ):void
		{
			dispatchEvent( new Event( Event.CLOSE, true ) );
			content = null;
		}
		
		
		override protected function initView():void
		{
			if(content is IView) {
				currentView = content as IView;
			} else if(content is DisplayObject) {
				var v:ComponentView = new ComponentView();
				v.centerContent = centerContent;
				v.resizeContent = resizeContent;
				v.contentPercentHeight = contentPercentHeight;
				v.contentPercentWidth = contentPercentWidth;
				v.content = content;
				currentView = v;
				
			}
			if (currentView != null) {
				addChild( DisplayObject( currentView ) );
			}
		}

		/**		 * attaches content		 */
		public function set content( displayObj:DisplayObject ):void {
			
			if (_content!=null && displayObj != _content) {
				sendEvent( EVENT_CLOSED );
			}
			_content = displayObj;
			
			if(_content!=null) {
				sendEvent( EVENT_OPENED, content );
			}
			invalidate(VALID_VIEW);
		}


		/**		 * currently attached content		 */
		public function get content():DisplayObject {
			return _content;
		}


		/**		 * refrence to background so alpha or color can be adjusted		 */
		public function get background():Box {
			return _background;
		}


		protected function onStageResize( event:Event = null ):void
		{			
			setSize( stage.stageWidth, stage.stageHeight );
		}


		public function get centerContent():Boolean {
			return _centerContent;
		}


		public function set centerContent( centerContent:Boolean ):void {
			_centerContent = centerContent;
		}


		public function get resizeContent():Boolean {
			return _resizeContent;
		}


		public function set resizeContent( resizeContent:Boolean ):void {
			_resizeContent = resizeContent;
		}


		public function get contentPercentWidth():Number {
			return _contentPercentWidth;
		}


		public function set contentPercentWidth( contentPercentWidth:Number ):void {
			_contentPercentWidth = contentPercentWidth;
		}


		public function get contentPercentHeight():Number {
			return _contentPercentHeight;
		}


		public function set contentPercentHeight( contentPercentHeight:Number ):void {
			_contentPercentHeight = contentPercentHeight;
		}
	}
}