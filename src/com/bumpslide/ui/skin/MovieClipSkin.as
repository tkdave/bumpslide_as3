package com.bumpslide.ui.skin 
{
	import flash.display.MovieClip;

	/**
	 * Base class for MovieClip skins
	 * 
	 * Each skin state should be represented as a frame in a movie clip
	 * @author David Knape
	 */
	public class MovieClipSkin extends MovieClip implements ISkin 
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
		 * code in movie clips can reference this.hostComponent which is loosely typed
		 * for flexibility
		 */
		public function hostComponent():* 
		{
			return _host;
		}
	}
}
