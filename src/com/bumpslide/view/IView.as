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

package com.bumpslide.view {	import flash.events.IEventDispatcher;			/**	 * Represents a page view that has transitions	 * 	 * This interface is similar to the Gaia Framework IPage. 	 * 	 * 	 * @see com.bumpslide.view.ViewStack	 * @see com.bumpslide.view.ViewLoader	 * 	 * @author David Knape	 */	public interface IView extends IEventDispatcher {						/**		 * Transition in and update view state accordingly		 */		function transitionIn():void;				/**		 * Transition out and update view state accordingly		 */		function transitionOut():void;				/**		 * Current view state		 * 		 * Should be one of the constants defined in com.bumpslide.view.ViewState		 */		function get viewState():String;	}}