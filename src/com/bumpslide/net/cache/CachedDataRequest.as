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
 package com.bumpslide.net.cache
{

	import com.bumpslide.data.Callback;
	import com.bumpslide.net.AbstractRequest;
	import com.bumpslide.net.FileRequest;
	import com.bumpslide.net.HTTPRequest;
	import com.bumpslide.net.IRequest;
	import com.bumpslide.net.IResponder;
	import com.bumpslide.util.Delegate;

	import flash.events.Event;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;

	[Event(name='fresh', type='flash.events.Event')]
	[Event(name='fromCache', type='flash.events.Event')]
	[Event(name='expired', type='flash.events.Event')]
	
	/**
	 * Cached Data Request wraps FileRequest and HTTPRequest
	 * 
	 * Request a URL, and give it an expire time.  The freshest content we can 
	 * acquire will be returned to the responders result handler as a ByteArray.
	 * 
	 * You can easily extend this class and override the getResult method to 
	 * transform the loaded data into it's appropriate type.
	 * 
	 * @author David Knape
	 */
	public class CachedDataRequest extends AbstractRequest
	{

		protected var _cache:ICache;

		protected var _url:String;

		protected var _request:IRequest;

		protected var _expireTime:Number;

		protected var _mostRecentCopy:CachedFile;

		protected var _killing:Boolean = false;

		protected var _urlRequest:URLRequest;

		/**
		 * Load a raw bytes from cache if found
		 */
		public function CachedDataRequest( url_request:URLRequest, cache:FileCache, responder:IResponder = null, expire_time:Number = 0 )
		{
			_urlRequest = url_request;
			_url = _urlRequest.url;
			_cache = cache;
			_expireTime = expire_time;

			// don't retry cache requests
			retryCount = 1;

			// 1 minute
			timeout = 60;

			super( responder );
		}


		override protected function initRequest():void
		{
			var key:String = urlRequest.url + '_' + urlRequest.method + '_' + urlRequest.data.toString();

			// Get most recent version from cache.
			_mostRecentCopy = cache.retrieve( key ) as CachedFile;

			// If it's expired, dispatch an 'expired' event for testing purposes
			if (_mostRecentCopy && _mostRecentCopy.isExpired) {
				debug( 'Most recent copy is expired' );
				// wait 10 ms so unit tests have a chance to add the event listener
				Delegate.callLater( 10, dispatchEvent, new Event( 'expired' ) );
			}

			// If this version is expired, try to get a new one
			if (_mostRecentCopy == null || _mostRecentCopy.isExpired) {
				debug( 'No recent copy found (or expired), loading URL ' + url );

				var r:HTTPRequest = new HTTPRequest( urlRequest, new Callback( handleHttpResult, handleHttpError ), URLLoaderDataFormat.BINARY );
				r.retryCount = retryCount;
				r.timeout = timeout;
				r.load();
				_request = r;
			} else {
				// Load from cache after a slight delay so we have time to add responders
				debug( 'Loading previously cached version' );
				Delegate.callLater( 10, loadFromCache );
			}
		}


		/**
		 * Load data from the cache
		 */
		protected function loadFromCache( fresh:Boolean = false ):void
		{
			if (_mostRecentCopy == null) {
				throw new Error( 'Attempting to load from cache, but there is no recent copy. This should not be happening.' );
			}

			// dispatch notification for testing purposes
			if (!fresh) {
				dispatchEvent( new Event( 'fromCache' ) );
			}

			// load the file
			_request = new FileRequest( _mostRecentCopy.file, new Callback( handleCacheResult, handleCacheError ) );
			_request.load();
		}


		/**
		 * implement the kill method by simply killing any pending sub-request
		 */
		override protected function killRequest():void
		{
			_killing = true;
			if (_request) {
				_request.cancel();
			}
		}


		/**
		 * When HTTP result is loaded, process the result as we would the result from the cache
		 */
		protected function handleHttpResult( result:ByteArray ):void
		{
			debug( 'HTTP Result ' + result.length + ' bytes ' );

			// Update the cache
			_mostRecentCopy = cache.store( url, result, expireTime ) as CachedFile;

			// dispatch note that this is fresh content
			dispatchEvent( new Event( 'fresh' ) );

			handleCacheResult( result );
		}


		/**
		 * On HTTP Error, load from cache if we can. Error out if we can't.
		 */
		protected function handleHttpError( info:Error ):void
		{
			if (_killing)
				return;
			if (_mostRecentCopy) {
				debug( 'HTTP Request Failed, using most recent copy from cache' );
				loadFromCache();
			} else {
				debug( 'HTTP Request Failed, no recent copy, raising error' );
				raiseError( info );
			}
		}


		/**
		 * When cached file is loaded, we are done (finish the request)
		 */
		protected function handleCacheResult( result:ByteArray ):void
		{
			debug( 'File loaded ' + result.length + ' bytes' );
			finishCompletedRequest( result );
		}


		/**
		 * If there is an error pulling from the cache, pass it up the chain. This shouldn't ever happen.
		 */
		protected function handleCacheError( info:Error ):void
		{
			if (_killing)
				return;
			raiseError( info );
		}


		/**
		 * The cache implementation
		 */
		public function get cache():ICache {
			return _cache;
		}


		/**
		 * Shortcut to url we are trying to load
		 */
		public function get url():String {
			return urlRequest ? urlRequest.url : null;
		}


		/**
		 * Indicates that this request is currently being explitly killed, and we should not be throwing any more errors
		 */
		public function get killing():Boolean {
			return _killing;
		}


		/**
		 * Date.time when this request will expire
		 */
		public function get expireTime():Number {
			return _expireTime;
		}


		/**
		 * Cached request as a string
		 */
		override public function toString():String
		{
			return super.toString() + "(" + url + ") ";
		}


		/**
		 * The request we are loading
		 */
		public function get urlRequest():URLRequest {
			return _urlRequest;
		}
	}
}