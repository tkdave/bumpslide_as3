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
	import com.bumpslide.ui.Component;
	import com.bumpslide.util.StageProxy;

	import flash.events.Event;	
	/**
	 * Application/Document base class with stage proxy
	 * 
	 * @author Default
	 */
	public class Application extends Component 
	{

		protected var stageProxy:StageProxy;
				
		override protected function init():void 
		{
			log('init');
			
			// init stage proxy
			stageProxy = StageProxy.getInstance();
			stageProxy.addEventListener(Event.RESIZE, onStageResize);
			
			// wait for actual stage		
			addEventListener(Event.ADDED_TO_STAGE, eventDelegate(initStage));
			
			// go on adding children. invalidating, and all that
			super.init();	
								
		}

		/**
		 * Called when stage is available
		 */
		protected function initStage():void 
		{			
			stageProxy.init(stage); // <-- only need to do this once per app
			callLater( 10, updateNow );
		}

		/**
		 * Listen to stage proxy resize events
		 */
		protected function onStageResize(e:Event ):void 
		{
			log('stageProxy resized ' + stageProxy.width + ',' + stageProxy.height);
			setSize(stageProxy.width, stageProxy.height);
		}
		
		
		override public function get minWidth():Number {
			return stageProxy.minWidth;
		}
		
		
		override public function set minWidth(val:Number):void {
			stageProxy.minWidth = val;
		}
		
		
		public function get maxWidth():Number {
			return stageProxy.maxWidth;
		}
		
		
		 public function set maxWidth(val:Number):void {
			stageProxy.maxWidth = val;
		}
		
		
		override public function get minHeight():Number {
			return stageProxy.minHeight;
		}
		
		
		override public function set minHeight(val:Number):void {
			stageProxy.minHeight = val;
		}
		
		
		public function get maxHeight():Number {
			return stageProxy.maxHeight;
		}
		
		
		public function set maxHeight(val:Number):void {
			stageProxy.maxHeight = val;
		}
	}
}