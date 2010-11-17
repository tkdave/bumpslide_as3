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

	import com.adobe.crypto.MD5;

	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;

	/**
	 * Caches data to the AIR application storage directory
	 *
	 * @author David Knape
	 */
	public class FileCache implements ICache
	{

		public static const DEFAULT_CACHE_NAME:String = "myDataCache";

		private var _cacheName:String;

		private var _cacheDirectory:File;

		public function FileCache( cacheName:String = DEFAULT_CACHE_NAME )
		{
			// init storage directory
			_cacheName = cacheName;

			if (!File.applicationStorageDirectory.resolvePath( _cacheName ).exists) {
				File.applicationStorageDirectory.resolvePath( _cacheName ).createDirectory();
			}
			_cacheDirectory = File.applicationStorageDirectory.resolvePath( _cacheName );

			cleanup();
		}


		/**
		 * Saves data in the cache
		 * 
		 * @param key - unique key name
		 * @param data - ByteArray of data to save
		 * @param expireTime - AS3 timestamp (milliseconds since Jan 1, 1970)
		 */
		public function store( key:String, data:ByteArray, expireTime:Number = 0 ):ICachedItem
		{
			var file:File = cacheDirectory.resolvePath( MD5.hash( key ) + "_" + expireTime );
			var fileStream:FileStream = new FileStream();
			fileStream.open( file, FileMode.WRITE );
			fileStream.writeBytes( data );
			fileStream.close();
			return new CachedFile( file, expireTime );
		}


		/**
		 * Retrieves most recent version from cache and deletes any old copies in the process
		 * 
		 * @param key - unique key name
		 */
		public function retrieve( key:String ):ICachedItem
		{
			// get directory listing
			var files:Array = cacheDirectory.getDirectoryListing();

			var matches:Array = new Array();

			// for each file in the list, split at the '_' and look for a file
			// where the first part matches the hash of the url
			for each ( var f:File in files ) {
				var a:Array = f.name.split( '_' );
				if (!f.isDirectory && a != null && a.length == 2) {
					if (a[0] == MD5.hash( key )) {
						// store matches in an array of CachedFile objects
						matches.push( new CachedFile( f, Number( a[1] ) ) );
					}
				}
			}
			matches.sortOn( 'expireTime' );

			var mostRecent:CachedFile = matches.pop();

			// delete old copies
			// (this seems like a safe place to do some preliminary garbage collection)
			for each (var cf:CachedFile in matches ) {
				cf.file.deleteFileAsync();
			}

			return mostRecent;
		}


		/**
		 * Reference to cacheDirectory
		 */
		public function get cacheDirectory():File {
			return _cacheDirectory;
		}


		/**
		 * Clear the cache by deleting and re-creating the cache directory
		 */
		public function empty():void
		{
			cacheDirectory.deleteDirectory( true );
			File.applicationStorageDirectory.resolvePath( _cacheName ).createDirectory();
			_cacheDirectory = File.applicationStorageDirectory.resolvePath( _cacheName );
		}


		/**
		 * Delete any files over a month old that didn't get cleaned up in first round GC
		 */
		public function cleanup():void
		{
			// get directory listing
			var files:Array = cacheDirectory.getDirectoryListing();

			var monthAgo:Number = new Date().time - 1000 * 60 * 60 * 24 * 30;

			// trace('Last Month = ' + new Date( monthAgo ) );

			// for each file in the list, split at the '_' and look for a file
			// where the first part matches the hash of the url
			for each ( var f:File in files ) {
				var a:Array = f.name.split( '_' );
				if (!f.isDirectory && a != null && a.length == 2) {
					var expire_time:Number = Number( a[1] );

					if (expire_time != 0 && expire_time < monthAgo || f.creationDate.time < monthAgo && expire_time == 0) {
						// trace(' Time to delete ' + f.nativePath );
						f.deleteFileAsync();
					}
				}
			}
		}
	}
}


