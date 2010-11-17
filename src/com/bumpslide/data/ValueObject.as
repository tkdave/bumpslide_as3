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

package com.bumpslide.data {	import com.bumpslide.util.ObjectUtil;	import flash.events.EventDispatcher;	import flash.utils.getQualifiedClassName;	/**	 * An abstract value object with reusable clone and comparison methods 	 * 	 * @author David Knape	 */	public class ValueObject extends EventDispatcher implements IValueObject {				/**		 * Returns a new VO exactly like this one		 */		public function clone() : Object {			return ObjectUtil.clone( this );		}				/**		 * Compares this VO to another		 */		public function equals( o:Object ) : Boolean {			return ObjectUtil.equals( this, o );		}				/**		 * Merge properties found in the object into this VO instance		 */		public function merge( o:Object ) : void {			ObjectUtil.mergeProperties( o, this, _mergeProperties);		}
		
		public function toObject():Object {
			return ObjectUtil.mergeProperties( this, new Object(), _mergeProperties);
		}
		
		public var _mergeProperties:Array = null;						override public function toString():String {			var classname:String = getQualifiedClassName(this).split('::').pop();						return "["+classname+"] ";		}			}}