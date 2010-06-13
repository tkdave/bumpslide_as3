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
	
	import flash.events.IEventDispatcher;	

	/**
	 * Comand Interface
	 * 
	 * @author David Knape
	 */
	public interface ICommand extends IEventDispatcher {
		
		 // run the command
		 function execute( event:CommandEvent) : void;
		 
		 // cancels pending activity (for asynchronous commands)
		 function cancel() : void;
	}
}
