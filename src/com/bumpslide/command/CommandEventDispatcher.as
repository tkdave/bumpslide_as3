/**
 * This code is part of the Bumpslide Library by David Knape
 * http://bumpslide.com/
 * 
 * Copyright (c) 2006, 2007, 2008 by Bumpslide, Inc.
 * 
 * Released under the open-source MIT license.
 * http://www.opensource.org/licenses/mit-license.php
 * see LICENSE.txt for full license terms
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
