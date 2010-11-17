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

	import com.bumpslide.events.ViewChangeEvent;
	import com.bumpslide.tween.FTween;
	import com.bumpslide.ui.Component;
	
	/**
	 * Abstract Transitionable View
	 *  
	 * Extend this class with custom transitions in your app.
	 * See example implementation at the bottom of this file.
	 * 
	 * @author David Knape
	 */
	public class BasicView extends Component implements IView {

				
		protected var _viewState:String = ViewState.INACTIVE;
		
		public function transitionIn():void {
			_viewState = ViewState.TRANSITIONING_IN;
			dispatchEvent( new ViewChangeEvent( ViewChangeEvent.TRANSITION_IN ) );
			doTransitionIn();
		}


		protected function doTransitionIn():void
		{
			FTween.fadeIn( this, 0, .2, transitionInComplete );
		}
		
		public function transitionOut():void {
			_viewState = ViewState.TRANSITIONING_OUT;			
			dispatchEvent( new ViewChangeEvent( ViewChangeEvent.TRANSITION_OUT ) );
			doTransitionOut();
		}


		protected function doTransitionOut():void
		{
			FTween.fadeOut( this, 0, .5, transitionOutComplete );
		}
		
		protected function transitionOutComplete() : void {
			log('transition out complete');
			_viewState = ViewState.INACTIVE;
			dispatchEvent( new ViewChangeEvent( ViewChangeEvent.TRANSITION_OUT_COMPLETE ) ); 
			destroy();
		}
		
		protected function transitionInComplete() : void {
			if(_viewState==ViewState.TRANSITIONING_OUT) return;
			_viewState = ViewState.ACTIVE;
			dispatchEvent( new ViewChangeEvent( ViewChangeEvent.TRANSITION_IN_COMPLETE ) );
		}
		
		public function get viewState():String {
			return _viewState;
		}
		
		
		override public function destroy():void
		{
			super.destroy();
			FTween.stopTweening(this);
		}
	}
}

//package app {
//	import com.bumpslide.ui.AbstractView;
//	import com.bumpslide.tween.FTween;
//
//	/**
//	 * Example View Implementation
//	 */
//	public class AppView extends BasicView {
//		
//		override public function doTransitionIn():void {
//			FTween.fadeIn( this, 0, .2, transitionInComplete );
//		}		
//		
//		override public function doTransitionOut():void {	
//			FTween.fadeOut( this, 0, .5, transitionOutComplete );
//		}
//	}
//}
