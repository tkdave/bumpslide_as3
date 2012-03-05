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

package com.bumpslide.net 
{
	import com.bumpslide.util.StringUtil;

	import flash.errors.IOError;
	import flash.events.AsyncErrorEvent;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.NetConnection;
	import flash.net.ObjectEncoding;
	import flash.net.Responder;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	/**
	 * Flash Remoting method call
	 * 
	 * @author David Knape
	 */
	public class AMFRequest extends AbstractRequest implements IRequest
	{

		protected var _netConnection:NetConnection;

		protected var _gatewayUrl:String;

		protected var _commandName:String;

		protected var _objectEncoding:uint = ObjectEncoding.AMF3;

		protected var _commandArgs:Array;

		protected var _amfResponder:Responder;

		// Active connections
		static protected var activeConnections:Dictionary = new Dictionary();

		
		/**
		 * Get exisiting NetConnection for a given URL
		 */
		static protected function getActiveConnection( url:String, debugEnabled:Boolean = false):NetConnection 
		{
			if(activeConnections[url] == null) {
				var nc:NetConnection = new NetConnection();
				if(debugEnabled) trace('[AMFRequest:Class (static)] getActiveConnection() - ' + url);
				nc.connect(url);
				nc.addEventListener(NetStatusEvent.NET_STATUS, defaultErrorHandler, false, 0);
				activeConnections[url] = nc;
				nc = null;
			}
			return activeConnections[url];
		}

		
		static protected function defaultErrorHandler(event:NetStatusEvent):void 
		{
			trace('[AMFRequest:Class (static)] defaultErrorHandler() - caught unhandled net status event ' + event.info['code']);
		}

		
		static protected function closeActiveConnection(url:String, debugEnabled:Boolean = false):void
		{
			var nc:NetConnection = activeConnections[url];
			if(nc != null && nc.connected) {
				if(debugEnabled) trace('[AMFRequest:Class (static)] closeActiveConnection() - ' + url);
				nc.close();
				nc.removeEventListener(NetStatusEvent.NET_STATUS, defaultErrorHandler);
				delete activeConnections[url];
			}
		}

		
		/**
		 * Create a new AMF request that can be called/loaded
		 */
		public function AMFRequest(gateway_url:String, command_name:String, command_args:Array = null, responder:IResponder = null)
		{
			_commandArgs = command_args;
			_gatewayUrl = gateway_url;
			_commandName = command_name;	
			super(responder);
		}

		
		/**
		 * Setup event listeners and make the method call
		 */	
		override protected function initRequest():void
		{
			//debug('initRequest');
			if(_netConnection == null) {
				_netConnection = AMFRequest.getActiveConnection(_gatewayUrl, debugEnabled);
				netConnection.objectEncoding = objectEncoding;
			} 
			
			netConnection.addEventListener(NetStatusEvent.NET_STATUS, handleNetStatusEvent, false, 999);
			netConnection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleSecurityError);
			netConnection.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
			netConnection.addEventListener(AsyncErrorEvent.ASYNC_ERROR, handleAsyncErrorEvent);
			
			_amfResponder = new Responder(finishCompletedRequest, handleError);
			var args:Array = [commandName, _amfResponder].concat(commandArgs);
			
			netConnection.call.apply(netConnection, args); 
		}

		
		/**
		 * Override this to do custom handling of error messages coming from your app server
		 */
		protected function handleError(error:Object):void
		{
			raiseError(new Error(error.toString()));
		}

		
		protected function handleAsyncErrorEvent(event:AsyncErrorEvent):void
		{
			raiseError(event.error);
		}

		
		protected function handleIOError(event:IOErrorEvent):void
		{
			event.stopImmediatePropagation();
			raiseError(new IOError(event.text));
		}

		
		protected function handleSecurityError(event:SecurityErrorEvent):void
		{
			event.stopImmediatePropagation();
			raiseError(new SecurityError(event.text));
		}

		
		protected function handleNetStatusEvent(event:NetStatusEvent):void
		{
			event.stopPropagation();
			if(event.info.level == 'error') {
				raiseError(new Error(event.info.code));
			} else {
				debug("NetStatus Event: " + event.info.code);
			}
		}

		
		override public function cancel():IRequest
		{
			AMFRequest.closeActiveConnection(gatewayUrl, debugEnabled);
			return super.cancel();			
		}

		
		override protected function killRequest():void
		{
			//debug('killRequest');
			if(netConnection != null) {
				netConnection.removeEventListener(NetStatusEvent.NET_STATUS, handleNetStatusEvent);
				netConnection.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, handleSecurityError);
				netConnection.removeEventListener(IOErrorEvent.IO_ERROR, handleIOError);
				netConnection.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, handleAsyncErrorEvent);
			}
		}

		
		public function get gatewayUrl():String {
			return _gatewayUrl;
		}		

		
		public function get commandName():String {
			return _commandName;
		}

		
		public function get netConnection():NetConnection {
			return _netConnection;
		}

		
		public function get objectEncoding():uint {
			return _objectEncoding;
		}

		
		public function set objectEncoding(objectEncoding:uint):void {
			_objectEncoding = objectEncoding;
		}

		
		public function get commandArgs():Array {
			return _commandArgs;
		}

		
		public function set commandArgs(commandArgs:Array):void {
			_commandArgs = commandArgs;
		}

		
		override public function toString():String
		{
			return '[AMFRequest] ' + StringUtil.formatNumber(getTimer() / 1000, 3) + ' (' + commandName + ') '; 
		}
	}
}
