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

package com.bumpslide.preloader {
	import flash.events.Event;
	/**
	 * Events to be dispatched by the main app for communicating with the preloader
	 * 
	 * @author David Knape
	 */
	public class PreloadEvent extends Event {
		 
		// if preloader was instructed to waitForStartup, this is the event it's waiting for		public static const STARTUP_COMPLETE:String = "preloadStartupComplete";
		
		// tells preloader to display a text message		public static const MESSAGE:String = "preloadMessage";
		
		
		// the message (for use with PreloadEvent.MESSAGE)		public var messageText:String = "";
		
		
		
		public function PreloadEvent(type:String, message_text:String = "") {
			super(type, true, false);
			messageText = message_text;
		}
	}
}
