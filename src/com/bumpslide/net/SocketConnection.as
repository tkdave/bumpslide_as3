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

package com.bumpslide.net {
	import com.bumpslide.util.Delegate;
	
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.XMLSocket;
	import flash.utils.Timer;	

	/**
	 * Persistent XML/Data Socket Connection
	 * 
	 * - if connection drops, it will keep trying to reconnect
	 * - nice for kiosks and things of that sort
	 * 
	 * @author David Knape
	 */
	public class SocketConnection extends EventDispatcher {

		private var _port:uint;
		private var _host:String;
		private var _socket:XMLSocket;
		
		private var updateDelay:Timer;
		private var retryTimer:Timer;
		
		public function SocketConnection() {
			super();			
		}
		
		public function reset() : void {			
			if(_socket!=null && _socket.connected) {
				if(_socket.connected) _socket.close();
				_socket.removeEventListener(Event.CONNECT, onConnect);
				_socket.removeEventListener(Event.CLOSE, onClose);
				_socket.removeEventListener(DataEvent.DATA, onData);
				_socket.removeEventListener(IOErrorEvent.IO_ERROR, onError);
			}
			
			trace('[XMLSocket] Connecting to '+_host+' port '+_port +' ... ');
			_socket = new XMLSocket(_host, _port);
			_socket.addEventListener(Event.CONNECT, onConnect);
			_socket.addEventListener(Event.CLOSE, onClose);
			_socket.addEventListener(DataEvent.DATA, onData);
			_socket.addEventListener(IOErrorEvent.IO_ERROR, onError);
		}
		
		/**
		 * Retry to connect after waiting for 5 seconds
		 */
		private function retryConnection() :void {
			Delegate.cancel( retryTimer );
			retryTimer = Delegate.callLater( 5000, reset );
		}
		
		private function onError(event:IOErrorEvent):void {
			trace('[XMLSocket] Error="'+event.text+'"' );
			retryConnection();
		}

		private function onData(event:DataEvent):void {
			//trace('[XMLSocket] Data="'+event.data+'"' );
			var e:DataEvent = event.clone() as DataEvent;
			dispatchEvent( e );
		}

		private function onClose(event:Event):void {
			trace('[XMLSocket] Connection Closed.');
			retryConnection();
		}

		private function onConnect(event:Event):void {
			trace('[XMLSocket] Socket Connected.');
			//_socket.send("Hello");
		}
		
		public function send(data:*):void {
			_socket.send( data );
		}
		
		
		public function get host():String {
			return _host;
		}
		
		public function set host(s_host:String):void {
			_host = s_host;
			invalidate();
		}
		
		public function get port():uint {
			return _port;
		}
		
		public function set port(n_port:uint):void {
			_port = n_port;
			invalidate();
		}		
		
		private function invalidate():void {
			Delegate.cancel(updateDelay);
			updateDelay = Delegate.callLater(100, reset);
		}
	}
}

class SingletonEnforcer {}