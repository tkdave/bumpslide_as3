/**
 * This code is part of the Bumpslide Library by David Knape
 * http://bumpslide.com/
 * 
 * Copyright (c) 2006, 2007, 2008, 2009 by Bumpslide, Inc.
 * 
 * Released under the open-source MIT license.
 * http://www.opensource.org/licenses/mit-license.php
 * see LICENSE.txt for full license terms
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
