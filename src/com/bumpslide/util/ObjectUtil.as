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

package com.bumpslide.util {	import flash.net.registerClassAlias;	import flash.utils.ByteArray;	import flash.utils.Dictionary;	import flash.utils.Proxy;	import flash.utils.getDefinitionByName;	import flash.utils.getQualifiedClassName;	/**	 * Object cloning and comparison utilities	 * 	 * This code was inspired by and borrowed from the 	 * Flight Framework Type utility.	 * 	 * @author David Knape	 */	public class ObjectUtil 	{		private static var registeredTypes:Dictionary = new Dictionary();		public static function create( classs:Class, initialProperties:Object = null):* 		{			var obj:* = new classs();			return ObjectUtil.mergeProperties( initialProperties, obj );		}				public static function equals(value1:Object, value2:Object):Boolean 		{			if(value1 == value2) {				return true;			}			if(value1 == null || value2 == null) {				return false;			}						ObjectUtil.registerType(value1);						var so1:ByteArray = new ByteArray();			so1.writeObject(value1);	        			var so2:ByteArray = new ByteArray();			so2.writeObject(value2);						return Boolean(so1.toString() == so2.toString());		}				public static function clone(value:Object):Object 		{						if(value == null) return null;						ObjectUtil.registerType(value);						var so:ByteArray = new ByteArray();			so.writeObject(value);	        			so.position = 0;			return so.readObject();		}                       				/**		 * Registers the class alias for this object so it can be		 * cloned and compared as a byteArray		 */		public static function registerType(value:Object):Boolean 		{			if( !(value is Class) ) {				value = getType(value);			}						if(!registeredTypes[value]) {						// no need to register a class more than once				registeredTypes[value] = registerClassAlias(getQualifiedClassName(value).split("::").join("."), value as Class);			}						return true;		}  				/**		 * Get the class name for an object		 */		public static function getType(value:Object):Class 		{			if (value is Class) {				return value as Class;			} else if(value is Proxy) {				return getDefinitionByName(getQualifiedClassName(value)) as Class;			} else {				return value.constructor as Class;			}		}      				/**		 * Merge properties from source into target		 * 		 * Assumes source is an object with enumerable properties		 */		public static function mergeProperties( source:*, target:*, merge_props:Array=null, not_props:Array=null ):* 		{			if(source != null && target != null)
			
			var prop:String;
			
			if(merge_props && merge_props.length) {
				for each( prop in merge_props ) {
					try { 
						target[prop] = source[prop];
					} catch (er:Error) {
						//trace( e, e.getStackTrace() );
					}
				}
			} else {
						for( prop in source ) {
				if(not_props==null || -1==not_props.indexOf( prop )) {					try { 						target[prop] = source[prop];					} catch (er:Error) {						//trace( e, e.getStackTrace() );					}
				}
						}
			}			return target;		}	}}