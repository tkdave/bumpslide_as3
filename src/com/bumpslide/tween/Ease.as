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
package com.bumpslide.tween
{

	import com.bumpslide.data.type.RGB;

	/**	 * FTween easing functions	 * 	 * Each function takes a current value, a target, the current velocity, 	 * and an object to hold additional named parameters.	 * 	 * The function should return the new velocity/delta.	 * 	 * @author David Knape	 */
	public class Ease
	{

		static public var Default:Function = Out;

		/**		 * Default Ease Out - Nice and Clean		 */
		static public function Out( current:Number, target:Number, veloc:Number, params:Object ) : Number
		{
			return (target - current) * paramValue( params, 'gain', .3 );
		}


		/**
		 * Ease In
		 */
		public static function In( current:Number, target:Number, veloc:Number, params:* ) : Number
		{
			var delta:Number = target - current;
			var ramp:Number = paramValue( params, 'ramp', .3 );
			var tolerance:Number = paramValue( params, 'tolerance', .1 );
			var positiveDirection:Boolean = delta > 0;
			var positiveVelocity:Boolean = veloc > 0;

			// start with something other than zero so we have something to build on
			// let's just use the tolerance value
			if(veloc == 0)
				veloc = positiveDirection ? tolerance : -tolerance;

			// If we have somewhere to go, go there
			if(Math.abs( delta ) > tolerance) {
				// We are going up
				if(positiveDirection) {
					// current velocity is positive
					if(positiveVelocity) {
						// ramp up the velocity, but don't exceed the delta
						veloc = Math.min( delta, veloc * (1 + ramp) );
					} else {
						// we're going the wrong way, reverse course
						veloc *= (1 - ramp);

						// If we're close to the zero line, jump across
						if(veloc > -tolerance)
							veloc = tolerance;
					}
				} else {
					// we're supposed to be going down

					// but, we're currently going up
					if(positiveVelocity) {
						// reverse course by ramping down
						veloc *= (1 - ramp);

						// if close to zero line, jump across to negative territory
						// (where we should be)
						if(veloc < tolerance)
							veloc = -tolerance;
					} else {
						// headed the right way, ramp up veloc
						// but, don't exceed the delta
						// (but use MAX instead of MIN func since we're negative)
						veloc = Math.max( delta, veloc * (1 + ramp) );
					}
				}

				return veloc;
			} else {
				// delta is close to zero, just return delta
				return delta;
			}
		}


		/**
		 * Combines easeIn and easeOut
		 */
		public static function InOut( current:Number, target:Number, veloc:Number, params:* ) : Number
		{
			var easedIn:Number = Ease.In( current, target, veloc, params );
			var easedOut:Number = Ease.Out( current, target, veloc, params );

			if((target - current) > 0 ) {
				return Math.min( easedOut, easedIn );
			} else {
				return Math.max( easedOut, easedIn );
			}
		}


		/**		 * Springy Tween		 */
		static public function Spring( current:Number, target:Number, veloc:Number, params:Object ) : Number
		{
			// apply gain
			veloc += (target - current) * paramValue( params, 'gain', .3 );
			// apply friction
			veloc *= ( 1 - paramValue( params, 'friction', .2 ) );
			return veloc;
		}


		/**		 * Stuttery motion		 */
		static public function Stutter( current:Number, target:Number, veloc:Number, params:Object ) : Number
		{
			return (target - current) * paramValue( params, 'gain', .3 ) * Math.random();
		}


		/**		 * Linear Tweening 		 */
		static public function Linear( current:Number, target:Number, veloc:Number, params:Object ) : Number
		{
			var d:Number = (target - current);
			var speed:Number = paramValue( params, 'speed', 10 );

			if(d > 0)
				return Math.min( d, speed );
			else
				return Math.max( d, -speed );
		}


		/**		 * Color Tween - eases R,G,B values inside of Color target		 * 		 * This is kind of a meta-tween.  The actual tweening of the rgb values is		 * specified by the 'subEasing' param.		 */
		static public function Color( current:Number, target:Number, veloc:Number, params:Object ) : Number
		{
			var easeFunction:Function = paramValue( params, 'componentEasing', Ease.Default );
			var curr:RGB = RGB.createFromNumber( current );
			var targ:RGB = RGB.createFromNumber( target );
			var prev:RGB = RGB.createFromNumber( current - veloc );
			// previous value in case we are springing
			var deltaR:Number = easeFunction.call( null, curr.red, targ.red, curr.red - prev.red, params );
			var deltaG:Number = easeFunction.call( null, curr.green, targ.green, curr.green - prev.green, params );
			var deltaB:Number = easeFunction.call( null, curr.blue, targ.blue, curr.blue - prev.blue, params );
			var newR:Number = curr.red + deltaR;
			var newG:Number = curr.green + deltaG;
			var newB:Number = curr.blue + deltaB;
			// to avoid rounding errors that get us stuck, always round towards the target
			newR = deltaR > 0 ? Math.ceil( newR ) : Math.floor( newR );
			newG = deltaG > 0 ? Math.ceil( newG ) : Math.floor( newG );
			newB = deltaB > 0 ? Math.ceil( newB ) : Math.floor( newB );
			var newColor:RGB = new RGB( newR, newG, newB );
			// trace( newColor + '/' + targ );
			return newColor.number - current;
		}


		/**		 * Easing capped at a certain velocity		 */
		static public function Smooth( current:Number, target:Number, veloc:Number, params:* ) : Number
		{
			var delta:Number = Ease.Default.apply( null, arguments );
			var maxDelta:Number = paramValue( params, 'maxVelocity', Number.MAX_VALUE );
			return (delta > 0) ? Math.min( delta, maxDelta ) : Math.max( delta, -maxDelta );
		}


		static private function paramValue( params:Object, name:String, defaultValue:* ) : *
		{
			return params[name] != null ? params[name] : defaultValue;
		}
	}
}