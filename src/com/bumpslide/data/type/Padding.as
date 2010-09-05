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
package com.bumpslide.data.type
{

	import com.bumpslide.util.StringUtil;
	import com.bumpslide.util.Delegate;

	/**
	 * Structure that represents the padding around a rectangular component
	 * 
	 * @author David Knape
	 */
	public class Padding
	{

		public var top:Number = 0;

		public var bottom:Number = 0;

		public var left:Number = 0;

		public var right:Number = 0;

		/**
		 * Create a new Padding object
		 * 
		 * parameters are processed just like CSS.
		 * 
		 * If just one value, it's used for all.
		 * If just two, it's top/bottom, left/right.
		 * And, so on...
		 */
		function Padding( t:Number = -1, r:Number = -1, b:Number = -1, l:Number = -1 )
		{
			if(t == -1)
				return;
			else
				top = bottom = t;

			if(r == -1) {
				left = right = bottom = top;
				return;
			} else
				left = right = r;

			if(b != -1)
				bottom = b;

			if(l != -1)
				left = l;
		}


		// top + bottom
		public function get height() : Number {
			return top + bottom;
		}


		// left + right
		public function get width() : Number {
			return left + right;
		}


		public function clone() : Padding
		{
			return new Padding( top, right, bottom, left );
		}


		public function toString():String
		{
			return "[Padding top: " + top + " right: " + right + " bottom: " + bottom + " left: " + left + " ]";
		}


		/**
		 * For setting via a string (or a padding object)
		 * 
		 * ex: var padding:Padding = Padding.create("10 5"); 
		 * // top and bottom are 10, left and right are 5 (like CSS padding spec)
		 */
		static public function create( value:* ):Padding
		{
			if( value is Padding ) {
				return value;
			} else if( value is Number ) {
				return new Padding( value );
			} else if(value is String) {
				var args:Array = value.split( ' ' ).map( Delegate.map( StringUtil.trim ) );
				while(args.length < 4)
					args.push( -1 );
				return new Padding( Number( args[0] ), Number( args[1] ), Number( args[2] ), Number( args[3] ) );
			} else {
				return new Padding();
			}
		}
	}
}
