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
	import com.bumpslide.ui.IResizable;
	import com.bumpslide.view.BasicView;
	import com.bumpslide.view.IView;

	import flash.display.DisplayObject;
	import flash.net.LocalConnection;

	/**
	 * Makes use of the transition in and out methods of views to manage content
	 * 
	 * This is a rather abstract views stack.  You could use this to switch between
	 * sections of a web page, or to switch views when changing a tab in a form.
	 * 
	 * Note that this class extends BasicView so that views can be nested.
	 * Transitioning out a viewloader will transition out it's children.
	 * 
	 * If you want a ready-made viewstack, check out the ViewStack class that
	 * mantains an array of the classes you want instantiated.  
	 * 
	 * In your subclass, whenever you need to trigger a page change, simply
	 * call invalidate(VALID_VIEW); 
	 * 
	 * Then, override the initView() method and update 'currentView' there.
	 * 
	 * @author David Knape
	 */
	public class ViewLoader extends BasicView implements IView {

		// validation constant
		public static const VALID_VIEW:String = "validView";

		// the curent views
		protected var _currentView:IView;

		// holder for old views
		protected var _oldViews:Array;
		
		// whether or not to call 'destroy' on views when they are removed
		public var destroyOldViews:Boolean = true;

		/**
		 * Constructor
		 */
		public function ViewLoader() {
			_oldViews = new Array();
			super();
		}

		/**
		 * Override this and add new views to stage while saving reference as 'currentView'
		 */
		protected function initView():void {
			trace('WARNING: You need to implement the initView() method in your ViewLoader implementation.  This is where you set currentView and add it to the stage.');
		}

		/**
		 * If valid page has changed, transition out the old page and load in the new one
		 */
		override protected function draw():void {			
			if(hasChanged(VALID_VIEW)) {	
				updateView();
			}
			
			if(hasChanged(VALID_SIZE) || hasChanged(VALID_VIEW)) {
				sizeContent();
			}
			
			validate(VALID_VIEW);
			validate(VALID_SIZE);
			
			super.draw();
		}
		
		protected function sizeContent():void {
			if(currentView is IResizable) {
				( currentView as IResizable).setSize( width, height );
			}
		}

		/**
		 * transition out old page and load the next one
		 */
		protected function updateView():void {
			
			
//			if(currentView.viewState == ViewState.TRANSITIONING_OUT) {
//				
//				// We interrupted a transition out
//				trace('interrupt');
//				//removeView( currentView );
//			}
			
			// If we have old views still hanging around, remove them now, including current views
			if(_oldViews.length) {
				// remove stale views, including current views that happen to be still transitioning out
				removeOldViews( true );				
			}
				
			if(currentView != null) {
				
				// instead of killing the current views, move a reference
				// to a stack of old views, so we can add new views on top
				// and allow for crossfades, and things of that sort
				_oldViews.push(currentView);
				
				log('updatePage() - transitioning out current views ' + currentView );
				currentView.transitionOut();
				//currentView = null;
			} else {
				log('updatePage() - currentView is null. Adding new views now...');
				addNewView();
			}
			
		}


		/**
		 * transition out complete, load next page
		 */
		protected function handleTransitionOutComplete(event:ViewChangeEvent):void {
			log('handleTransitionOutComplete() for ' + event.target );
			addNewView();
		}
		
		/**
		 * Transition In is complete, time to remove the old views
		 */
		protected function handleTransitionInComplete(event:ViewChangeEvent):void {
			log('removeOldViews() [because transitionIn is complete for '+event.target+']');
			removeOldViews();
		}

		/**
		 * Initializes new page and calls transitionIn on that page
		 */
		protected function addNewView():void {
			
			_currentView = null;
			
			// subclass should create child and add to display list
			initView();
						
			if(currentView != null) {
								
				log('addNewView() created ' + currentView);				
				currentView.addEventListener(ViewChangeEvent.TRANSITION_OUT_COMPLETE, handleTransitionOutComplete, false, 0, true);
				currentView.addEventListener(ViewChangeEvent.TRANSITION_IN_COMPLETE, handleTransitionInComplete, false, 0, true);
				currentView.transitionIn();
			} else {
				log('removeOldViews() [because there is no new currentView]');
				removeOldViews();
			}
		}
		
		/**
		 * Remove all the old views
		 */
		protected function removeOldViews( including_current_view:Boolean = false ):void {
			
			while( _oldViews.length ) {
				var view:IView = _oldViews.pop();
				if(including_current_view || view!=currentView) {
					removeView( view );
				}
			}
			_oldViews = new Array();
			
			// force some garbage collection (yeah, gskinner told you not to do this in production code. I know.)
			try {
				new LocalConnection().connect('__');
				new LocalConnection().connect('__');
			} catch (e:*) {}
		}

		protected function removeView( view:IView ):void {
			
			if(view == _currentView) _currentView = null;
			
			log(' - removing ' + view );
			if(view is DisplayObject) destroyChild( view as DisplayObject, destroyOldViews );
			view.removeEventListener(ViewChangeEvent.TRANSITION_OUT_COMPLETE, handleTransitionOutComplete);
			view.removeEventListener(ViewChangeEvent.TRANSITION_IN_COMPLETE, handleTransitionInComplete);
		}
		
		/**
		 * The current views
		 */
		public function get currentView():IView {
			return _currentView;
		}

		/**
		 * Set the current views.  This should be a display object.
		 */
		public function set currentView(currentView:IView):void {
			_currentView = currentView;
		}
				
		
		//------------------------------------------------------------		
		// IView implementation so that ViewLoaders can be nested
		//------------------------------------------------------------
		
		/**
		 * Transition out the child views
		 */
		override public function transitionOut():void {
			if(currentView!=null) {
				currentView.addEventListener(ViewChangeEvent.TRANSITION_OUT_COMPLETE, handleChildTransitionOutComplete, false, 0, true);
				currentView.transitionOut();
			}
			super.transitionOut();
		}
		
		/**
		 * notify transition out complete
		 */
		private function handleChildTransitionOutComplete(event:ViewChangeEvent):void {
			if(event.target==currentView) {
				currentView.removeEventListener(ViewChangeEvent.TRANSITION_OUT_COMPLETE, handleChildTransitionOutComplete);
				super.transitionOutComplete();
			}
		}
	}
}
