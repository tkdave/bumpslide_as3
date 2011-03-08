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

package com.bumpslide.data {        /**     * @author David Knape     */    public class LoopedDataProvider {    	    	private var data:Array;    	    	private var _length:Number = uint.MAX_VALUE;    	    	public function LoopedDataProvider( a:Array, dp_length:Number=uint.MAX_VALUE) {    		data = a;    		length = dp_length;    	}    	    	    	public function getItemAt(n:Number) : * {    		if(data.length==0) return undefined;    		return data[ n%data.length ];    	}    	    	public function get length () : Number {    	    		return _length;        }                public function set length (max_length:Number) : void {        	_length = max_length;        }                public function getArray():Array {        	var a:Array = new Array();        	for(var n:Number=0; n<length; n++) {        		a.push( getItemAt(n) );        	}        	return a;        }    }}