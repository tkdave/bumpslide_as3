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

	import flash.utils.getQualifiedClassName;

	import com.bumpslide.util.Delegate;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;

	// Request completed successfully	[Event(name='complete',type='flash.events.Event')]
	
	// Request was cancelled before it was completed
	[Event(name='cancel',type='flash.events.Event')]
	
	// Error	[Event(name='error',type='flash.events.ErrorEvent')]

	/**	 * Generic async request, provides retry and timeout functionality as well as a responder implementation	 * 	 * @author David Knape	 */
	public class AbstractRequest extends EventDispatcher implements IRequest
	{

		// Error Messages		public static var ERROR_MSG_TIMED_OUT:String = "Request Timed Out";
		public static var ERROR_MSG_DEFAULT:String = "Net Request Error";
		public static var ERROR_MSG_CANCELLED:String = "Request Cancelled";

		// options		public var debugEnabled:Boolean = false;

		// private	
		// responders
		protected var _responders:Array;

		// timeout timer
		protected var _loadTimer:Timer;

		// timeout per request (in seconds)
		protected var _timeout:uint = 30;

		// number of times to attempt a connection
		protected var _retryCount:uint = 3;

		// delay between connection attempts (in seconds)
		protected var _retryWaitTime:uint = 1;

		// parsed/formatted results
		protected var _result:*;

		// raw data
		protected var _data:*;

		// are we actively loading
		protected var _loading:Boolean = false;

		// were we just cancelled
		protected var _cancelled:Boolean = false;

		// true if the request has been completed
		protected var _complete:Boolean = false;

		/**		 * Creates a new HTTPRequest that wraps a URLRequest		 */
		public function AbstractRequest( responder:IResponder = null )
		{
			if(responder != null)
				addResponder( responder );
		}


		/**		 * Adds a responder to the request		 */
		public function addResponder( responder:IResponder ):IRequest
		{
			if(_responders == null)
				_responders = new Array();
			if(responder != null) {
				// don't add the same responder twice
				if(_responders.indexOf( responder ) == -1) {
					_responders.push( responder );
				}
			}
			return this;
		}

		/**
		 * Remove a responder
		 */
		public function removeResponder( responder:IResponder ) : IRequest
		{
			var idx:int = _responders.indexOf( responder );
			if(idx != -1) {
				_responders.splice( idx, 1 );
			}
			return this;
		}


		/**		 * Starts loading the request		 */
		public function load():IRequest
		{
			if(cancelled || loading) {
				return this;
			}
			initTimer();
			try {
				initRequest();
			} catch (error:Error) {
				raiseError( error );
			}
			return this;
		}


		/**		 * Cancels pending request		 */
		public function cancel():IRequest
		{
			// only allow cancelling requests that are still pending
			if(!_complete) {
				_cancelled = true;
				debug( ERROR_MSG_CANCELLED );
				raiseError( new Error( ERROR_MSG_CANCELLED ) );
				dispatchEvent( new Event( Event.CANCEL ) );
			}
			return this;
		}

		/**
		 * Cancel and reset to default state so request can be re-used
		 * 
		 * Note that this method can also optionally remove all repsponders, but this is disabled by default.
		 */
		public function reset( remove_responders:Boolean = false ):IRequest {
			cancel();
			_cancelled = false;
			_loading = false;
			_complete = false;
			_result = null;
			_data = null;
			if(remove_responders) {
				_responders = new Array();
			}
			return this;
		}


		/**		 * Starts listening to load events and start the loading process		 */
		protected function initRequest():void
		{
			throw new Error( 'initRequest() must be implemented in a subclass' );
		}


		/**		 * closes the URLLoader and stops listening to URLLoader events		 */
		protected function killRequest():void
		{
			throw new Error( 'killRequest() must be implemented in a subclass' );
		}


		/**		 * Kills the request, processes result, and triggers complete event		 * 		 * This should be called from an onComplete handler and passed some raw data to process		 * 		 */
		protected function finishCompletedRequest( rawData:* ):void
		{
			killRequest();
			killTimer();
			if(cancelled)
				return;
			debug( 'Complete' );
			// save raw data
			_data = rawData;
			// Yay. We're complete			
			_complete = true;
			try {
				// process the data into some kind of 'result'
				_result = getResult();
			} catch (e:Error) {
				raiseError( e );
				trace(_data);
				return;
			}
			// pass data to responders
			for each (var r:IResponder in _responders) {
				if(r.fault != null)
					r.result( result );
			}
			// dispatch the complete event
			dispatchEvent( new Event( Event.COMPLETE ) );
		}


		/**		 * This should be overriden by subclasses to parse XML, JSON, etc.		 * 		 * By default, we just set the result to be the raw data		 */
		protected function getResult():*
		{
			return data;
		}


		/**		 * Starts the timer that is used to manage timeouts and retries		 */
		protected function initTimer():void
		{
			_loadTimer = new Timer( timeout * 1000, retryCount );
			_loadTimer.addEventListener( TimerEvent.TIMER, handleTimeout );
			_loadTimer.addEventListener( TimerEvent.TIMER_COMPLETE, handleFinalTimeout );
			_loadTimer.start();
		}


		/**		 * Stops the timer used to manage timeouts and retries		 */
		protected function killTimer():void
		{
			if(_loadTimer == null)
				return;
			_loadTimer.stop();
			_loadTimer.removeEventListener( TimerEvent.TIMER, handleTimeout );
			_loadTimer.removeEventListener( TimerEvent.TIMER_COMPLETE, handleFinalTimeout );
			Delegate.cancel( _retryDelay );
		}

		protected var _retryDelay:Timer;

		/**		 * After request times out, try again		 */
		protected function handleTimeout( e:TimerEvent = null ):void
		{
			
			debug( 'handleTimeout' );
			killRequest();
			
			if(retryCount>1) {
				// wait for 1 sec before we retry
				// This prevents the extra init/kill that was occuring right before we give up
				// and it gives us some space in between on tries, which is nice
				_retryDelay = Delegate.callLater( retryWaitTime * 1000, retry );
			}
		}


		protected function retry() : void
		{
			debug( 'Retry' );
			try {
				initRequest();
			} catch (error:Error) {
				raiseError( error );
			}
		}


		/**		 * If Timer has expired, we have completed all retries.  Kill it.		 */
		private function handleFinalTimeout( event:TimerEvent ):void
		{
			debug( 'Final try timed out (time: ' + getTimer() + ')' );
			Delegate.cancel( _retryDelay );
			raiseError( new Error( ERROR_MSG_TIMED_OUT ) );
		}


		/**		 * calls fault handler on responder and dispatches an 'error' event if you're in to that kind of thing		 */
		protected function raiseError( error:Error = null ):void
		{
			if(error == null)
				error = new Error( ERROR_MSG_DEFAULT );
			if(!cancelled)
				debug( error );
			// kill it
			killRequest();
			killTimer();
			// pass message to responder fault handlers
			for each (var r:IResponder in _responders) {
				if(r.fault != null)
					r.fault( error );
			}
			// Dispatch 'error' event
			if(!cancelled) {
				dispatchEvent( new Event( 'error' ) );
			}
		}


		/**		 * trace util		 */
		protected function debug( msg:* ):void
		{
			if(debugEnabled)
				trace( this.toString() + msg );
		}


		override public function toString():String
		{
			return '[' + getQualifiedClassName( this ).split( '::' ).pop() + '] ';
		}


		/**		 * Timeout in seconds		 */
		public function get timeout():uint {
			return _timeout;
		}


		public function set timeout( seconds:uint ):void {
			_timeout = seconds;
		}


		/**		 * Number of times to retry request if it is timing out		 * 		 * This includes the initial attempt. A request with a retryCount of 3 will be attempted 3 times.
		 * 
		 * A request with retry count of 1 will only be requested once.		 */
		public function get retryCount():uint {
			return _retryCount;
		}


		public function set retryCount( n:uint ):void {
			_retryCount = n;
		}


		/**		 * Delay in seconds between connection attempts		 */
		public function get retryWaitTime():uint {
			return _retryWaitTime;
		}


		public function set retryWaitTime( value:uint ):void {
			_retryWaitTime = value;
		}


		/**		 * Access to a formatted result object (XML, decoded JSON, etc. - depends on implementation)		 * 		 * This is what gets passed to the responder's result handler		 */
		public function get result():* {
			return _result;
		}


		/**		 * The raw data retrieved from the server		 */
		public function get data():* {
			return _data;
		}


		/**		 * Whether or not we are loading		 */
		public function get loading():Boolean {
			return _loadTimer != null && _loadTimer.running;
		}


		/**		 * Whether or not this call has been cancelled		 */
		public function get cancelled():Boolean {
			return _cancelled;
		}


		public function get complete():Boolean {
			return _complete;
		}
	}
}