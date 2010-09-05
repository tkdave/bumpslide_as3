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

package com.bumpslide.ui {	import com.bumpslide.tween.FTween;	import com.bumpslide.ui.Box;	import com.bumpslide.util.Align;		import flash.display.DisplayObject;	import flash.events.Event;	import flash.events.MouseEvent;			/**	 * Lightbox	 * 	 * @author David Knape	 */	public class Lightbox extends Component {				public static const EVENT_OPENED:String = "onLightboxOpened";		public static const EVENT_CLOSED:String = "onLightboxClosed";				private var _background:Box;		private var _content:DisplayObject;		protected var _centerContent:Boolean = true;				override protected function addChildren() : void {						visible = false;						// add background and listen for click events			_background = new Box(0x000000);			_background.alpha = .8;			_background.buttonMode = true;			_background.addEventListener( MouseEvent.CLICK, close );			addChild( _background );								addEventListener( Event.ADDED_TO_STAGE, onAddedToStage );						addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage );									delayUpdate = false;		}		protected function onAddedToStage(event:Event):void {			stage.addEventListener(Event.RESIZE, onStageResize);			onStageResize();		}				private function onRemovedFromStage(event:Event):void {			stage.removeEventListener(Event.RESIZE, onStageResize);		}		override protected function draw() : void {			 // extra big so it covers when resizing browser bigger			_background.setSize(width+500,height+500);						if(_centerContent && content!=null) {				Align.center( content, width );				Align.middle( content, height );			}			super.draw();		}				/**		 * Opens lightbox with supplied display object added to the display list		 */		public function open(displayObj:DisplayObject) : void {			content = displayObj;			FTween.fadeIn( this );			sendEvent( EVENT_OPENED, content );			callLater( 50, updateNow );		}				/**		 * Closes lightbox and removes content from the display list		 */		public function close(e:Event=null) : void {			content = null;			FTween.fadeOut( this );			sendEvent( EVENT_CLOSED );		}						/**		 * attaches content		 */		public function set content ( displayObj:DisplayObject ) : void {			if(_content!=null && contains(_content)) {				removeChild(_content);			}			_content = displayObj;			if(_content!=null) addChild( _content );			invalidate();		}				/**		 * currently attached content		 */		public function get content () : DisplayObject {			return _content;		}				/**		 * refrence to background so alpha or color can be adjusted		 */		public function get background () : Box {			return _background;		}										private function onStageResize(event:Event=null):void {			setSize( stage.stageWidth, stage.stageHeight);		}
		
		public function get centerContent():Boolean {			return _centerContent;
		}
		
		public function set centerContent(centerContent:Boolean):void {			_centerContent = centerContent;
		}	}}