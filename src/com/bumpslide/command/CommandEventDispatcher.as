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

package com.bumpslide.command {
	import flash.events.EventDispatcher;
	
	/**
	 * Event Dispatcher reserved for sending command events 
	 * 
	 * The controller is the only one listening to this.
	 * This is very much like the CairngormEventDispatcher
	 * 
	 * @author David Knape
	 */
	public class CommandEventDispatcher extends EventDispatcher {

		public function CommandEventDispatcher(singletonEnforcer:PrivacyToken) {
			super();
		}
		
		private static var instance : CommandEventDispatcher;  
  		
		/**
		 * Returns the single instance of the dispatcher
		 */ 
		public static function getInstance() : CommandEventDispatcher {
			if(instance==null) {
				instance = new CommandEventDispatcher(new PrivacyToken());
			}
			return instance;
		}
		
		
	}
}

class PrivacyToken {}
