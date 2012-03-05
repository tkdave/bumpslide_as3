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

package com.bumpslide.command 
{
	import com.bumpslide.net.IResponder;

	import flash.events.Event;

	/**
	 * This is like a CairngormEvent.  It triggers an application command.
	 * 
	 * We've added built a responder interface for notifying views directly
	 * when an asynchronous process has finished.  
	 * 
	 * Commands must store the event as it's callback in order to make this work.
	 *  
	 * @author David Knape
	 */
	public class CommandEvent extends Event implements IResponder 
	{

		public var data:*;

		public var resultHandler:Function = null;
		public var faultHandler:Function = null;

		
		public function CommandEvent(type:String, data:Object = null, resultHandler:Function = null, faultHandler:Function = null ) 
		{
			super(type, true);
			this.data = data;
			this.resultHandler = resultHandler;
			this.faultHandler = faultHandler;
		}

		
		override public function clone():Event 
		{
			return new CommandEvent(type, data);
		}

		override public function toString():String 
		{
			return '[CommandEvent] "' + type + '" data=' + data;
		}

		
		public function fault(info:Error):void 
		{
			if(faultHandler != null) {
				try {
					faultHandler.call(null, info);
				} catch (e:ArgumentError) {
					faultHandler.call(null);
				}
			}
		}

		
		public function result(data:Object):void 
		{
			if(resultHandler != null) {
				try {
					resultHandler.call(null, data);
				} catch (e:ArgumentError) {
					resultHandler.call(null);
				}
			}
		}
	}
}
