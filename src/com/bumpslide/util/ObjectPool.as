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

package com.bumpslide.util 
{

	/**
	 * ObjectPool
	 *
	 * @author David Knape
	 * @version SVN: $Id: $
	 */
	public class ObjectPool extends Object 
	{
		
		private var _pool:Array;
		private var _objClass:Class;
		private var _maxPoolSize:uint = 5000;
			
		public function ObjectPool( objectClass:Class, initialPoolSize:uint=10, maxPoolSize:uint=5000)
		{
			_objClass = objectClass;
			_maxPoolSize = maxPoolSize;
			_pool = new Array();
			for(var n:uint=0; n<initialPoolSize; n++) {
				_pool.push( new _objClass() );
			}
		}
		
		public function getObject( defaultProperties:Object=null ) : * {
			var obj:*;			
			if(_pool.length>0) {
				obj = _pool.pop();
			} else {
				obj = new _objClass();
			} 	
			if(defaultProperties!=null) {
				for(var prop:String in defaultProperties) {
					obj[prop] = defaultProperties[prop];
				}
			}
			return obj;
		}
		
		public function releaseObject( obj:* ):* {
			if(_pool.length<_maxPoolSize) {
				_pool.push( obj );
			}
			return obj;
		}
	}
}
