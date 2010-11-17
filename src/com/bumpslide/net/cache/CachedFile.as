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

	import flash.filesystem.File;

	/**
	 * Reference to a cached file
	 *
	 * @author David Knape
	 */
	public class CachedFile implements ICachedItem
	{

		public var file:File;

		public var expireTime:Number = 0;

		public function CachedFile( f:File, expires:Number = 0 )
		{
			file = f;
			expireTime = expires;
		}


		public function get isExpired():Boolean {
			var t:Number = new Date().time;
			return expireTime != 0 && t >= expireTime;
		}
	}
}
