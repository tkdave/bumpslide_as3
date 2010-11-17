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
 
package com.bumpslide.net.cache {

	import flash.utils.ByteArray;
	
	/**
	 * ICache
	 *
	 * @author David Knape
	 */
	public interface ICache {

		/**
		 * Saves data in the cache
		 * 
		 * @param key - unique key name
		 * @param data - ByteArray of data to save
		 * @param expireTime - AS3 timestamp (milliseconds since Jan 1, 1970)
		 */
		function store(key:String, data:ByteArray, expireTime:Number = 0):ICachedItem;

		/**
		 * Retrieves most recent version from cache and deletes any old copies in the process
		 * 
		 * @param key - unique key name
		 */
		function retrieve(key:String):ICachedItem;
	}
}
