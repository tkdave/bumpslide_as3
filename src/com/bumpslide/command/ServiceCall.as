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
	import com.bumpslide.command.Command;
	import com.bumpslide.net.HTTPRequest;
	import com.bumpslide.net.IRequest;
	import com.bumpslide.net.IResponder;
	
	import flash.net.URLRequest;		

	/**
	 * This is an example command that makes a service call using an RPC request
	 * 
	 * In this case, the event.data is the url we want to load
	 * 
	 * This can be extended if you want, but it's more of a template/example.
	 * 
	 * @author David Knape
	 */
	public class ServiceCall extends Command implements IResponder {

		protected var rpc:IRequest;
		
		override public function execute(event:CommandEvent=null):void {
			callback = event;
			var url:String = event.data as String;  // event.data is the URL
			rpc = new HTTPRequest( new URLRequest( url ), this );
			rpc.load();
		}

		override public function cancel() : void {
			rpc.cancel();
		}
		
		public function fault(info:Error):void {
			debug( String( info ) );
			notifyError( info );
		}
		
		public function result(data:Object):void {
			notifyComplete( data );
		}	}
}
