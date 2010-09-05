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
