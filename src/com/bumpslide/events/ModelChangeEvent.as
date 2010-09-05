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

package com.bumpslide.events {       	    import flash.events.Event;        /**     * Property Change Event for Bindable Models     *      * @author David Knape     */    public class ModelChangeEvent extends Event {    	    	    	public static const PROPERTY_CHANGED:String = "onPropertyChanged";                private var _source:Object;        private var _property:String;        private var _oldValue:*;        private var _newValue:*;                public function ModelChangeEvent( src:Object, prop:String, newVal:*, oldVal:*=null)        {        	super(PROPERTY_CHANGED, bubbles, cancelable);        	        	_source = src;        	_property = prop;        	_oldValue = oldVal;        	_newValue = newVal;        	        	//trace( this );        }                public function get source():Object        {            return _source;        }                public function set source( o:Object ):void        {         	_source = o;        }                public function get property():String        {            return _property;        }                public function get oldValue():*        {            return _oldValue;        }                public function get newValue():*        {            return _newValue;        }                override public function toString () : String {        	return '[ModelChangeEvent] '+property+'='+newValue;         }				override public function clone():Event		{			return new ModelChangeEvent( source, property, newValue, oldValue);		}	}}