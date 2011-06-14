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

package com.bumpslide.net {	import com.bumpslide.util.ArrayUtil;	import flash.net.URLLoaderDataFormat;
	import flash.errors.IOError;	import flash.events.Event;	import flash.events.HTTPStatusEvent;	import flash.events.IEventDispatcher;	import flash.events.IOErrorEvent;	import flash.events.ProgressEvent;	import flash.events.SecurityErrorEvent;	import flash.net.URLLoader;	import flash.net.URLRequest;	import flash.net.URLVariables;
	[Event(name='progress',type='flash.events.ProgressEvent')]	[Event(name='httpStatus',type='flash.events.HTTPStatusEvent')]			/**	 * This class wraps a URLRequest and provides retry and timeout functionality.	 * 	 * It also implements a basic request interface (IRequest) that makes use of the 	 * IResponder interface.  This class also relays URLLoader progress and complete events.	 * 
	 * This is the grandaddy of all the IRequest implementations. 
	 * 	 * @author David Knape	 */	public class HTTPRequest extends AbstractRequest {								// private		protected var _urlLoader:URLLoader;		protected var _urlRequest:URLRequest;		protected var _postData:URLVariables;
		protected var _httpStatus:int;
		protected var _dataFormat:String = URLLoaderDataFormat.TEXT;
		
		// don't raise an error on these status codes
		public var acceptedHttpStatus:Array = [0,200];
				/**		 * Creates a new HTTPRequest that wraps a URLRequest		 */		public function HTTPRequest( request:URLRequest, responder:IResponder=null, data_format:String=URLLoaderDataFormat.TEXT  ) {			_urlRequest = request;			_dataFormat = data_format;						super( responder );		}								/**		 * Creates the URLLoader, starts listening to URLLoader events, and loads the URLRequest		 */			override protected function initRequest():void {
			_urlLoader = new URLLoader();
			_urlLoader.dataFormat = _dataFormat;			addLoaderEventListeners( _urlLoader );			_urlLoader.load(_urlRequest); 		}				/**		 * closes the URLLoader and stops listening to URLLoader events		 */		override protected function killRequest():void {						if(_urlLoader==null) return;			removeLoaderEventListeners( _urlLoader );			try { 				_urlLoader.close(); 			} catch (e:Error) {			}			}				/**		 * Request as a string for debugging		 */		override public function toString():String {			return '[HTTPRequest] (' + _urlRequest.url + ') ';		}		
		/**
		 * Event handlers that can be applied to a URLLoader or a Loader's 
		 * contentLoaderInfo property as is done in the LoaderRequest class.
		 * 
		 * Used in initRequest implementations.		 */		protected function addLoaderEventListeners( target:IEventDispatcher ) : void {			target.addEventListener(ProgressEvent.PROGRESS, handleProgressEvent);			target.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);			target.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleSecurityError);   			target.addEventListener(Event.COMPLETE, handleCompleteEvent);    			target.addEventListener(HTTPStatusEvent.HTTP_STATUS, handleHttpStatusEvent);		}		
		/**
		 * Called from killRequest to remove the event handlers. 
		 * 
		 * Pulled out to a function so we can use it in the LoaderRequest class. 		 */		protected function removeLoaderEventListeners( target:IEventDispatcher ) : void {			target.removeEventListener(ProgressEvent.PROGRESS, handleProgressEvent);			target.removeEventListener(IOErrorEvent.IO_ERROR, handleIOError);			target.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, handleSecurityError);   			target.removeEventListener(Event.COMPLETE, handleCompleteEvent);    			target.removeEventListener(HTTPStatusEvent.HTTP_STATUS, handleHttpStatusEvent); 		}						//-------------------------		// Loader Event Handlers		//-------------------------				protected function handleIOError(event:IOErrorEvent):void 		{			raiseError( new IOError( event.text ) );			//dispatchEvent( event );		}     				protected function handleSecurityError(event:SecurityErrorEvent):void 		{			raiseError( new SecurityError( event.text ) );			//dispatchEvent( event );		}   				protected function handleProgressEvent(event:ProgressEvent):void 		{			dispatchEvent(event);  		}				private function handleHttpStatusEvent(event:HTTPStatusEvent):void		{			_httpStatus = event.status;			dispatchEvent( event );		}						protected function handleCompleteEvent(event:Event):void 		{
			if ( acceptedHttpStatus.indexOf( _httpStatus ) == -1 ) {
				raiseError( new Error( event.toString()  ) );
			} else {				finishCompletedRequest( event.target.data );
			}		}							/**		 * The urlRequest we are wrapping		 */		public function get urlRequest():URLRequest {			return _urlRequest;		}				public function set urlRequest(urlRequest:URLRequest):void {			_urlRequest = urlRequest;		}				/**		 * The latest HTTP Status code (ex: 404, 500, etc.)		 */		public function get httpStatus():int {
			return _httpStatus;
		}

		public function get dataFormat() : String {
			return _dataFormat;
		}

		public function set dataFormat(dataFormat:String) : void {
			_dataFormat = dataFormat;
		}	}}