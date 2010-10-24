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

package com.bumpslide.ui.skin 
{

	import com.bumpslide.ui.IResizable;
	import com.bumpslide.util.Delegate;

	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;

	/**
	 * Base class for MovieClip skins
	 * 
	 * Each skin state should be represented as a frame in a movie clip
	 * @author David Knape
	 */
	dynamic public class MovieClipSkin extends MovieClip implements ISkin 
	{	

		protected var _host:ISkinnable;

		
		/**
		 * When state changes, go to a new frame
		 * 
		 * Override this behavior for more advanced skins that need transitions and such
		 */	
		public function renderSkin( skinState:String ):void
		{
			gotoAndStop(skinState);
			
			if(stage) {
				stage.addEventListener( Event.RENDER, handleStageRender );
				stage.invalidate();
			} else {
				Delegate.onEnterFrame( render );
			}

			// and render now just in case - silly flash
			render();
		}
		
		protected function handleStageRender( e:Event ):void
		{
			if(stage)
				stage.removeEventListener( Event.RENDER, handleStageRender );
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
		protected function render():void
		{
			autosizeBackground();
		}


		/**
		 * If there is a skin part called 'background', size it to match the component
		 * 
		 * If you don't want your background auto-sized, don't name it 'background'.
		 */
		protected function autosizeBackground() : void
		{
			var background:DisplayObject = this['background'] as DisplayObject;
			// render background
			if(background != null) {
				if(background is IResizable) {
					(background as IResizable).setSize( hostComponent.width, hostComponent.height );
				} else {
					background.width = hostComponent.width;
					background.height = hostComponent.height;
				}
			}
		}
		
		public function initHostComponent( host:ISkinnable ):void 
		{
			_host = host;
		}

		
		public function destroy( ):void 
		{
			// bye bye
		}

		
		/**
		 * code in movie clips can reference this.hostComponent 
		 * loosely typed for flexibility
		 */
		public function get hostComponent():* 
		{
			return _host;
		}
	}
}
