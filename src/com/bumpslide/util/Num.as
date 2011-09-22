package com.bumpslide.util {
	
	/*
	 * Number utilities from Zach Archer
	 *
	 * @author Zach Archer, http://zacharcher.com/
	 */
	public class Num {
	
		// progress = (0.0...1.0)
		public static function interpolate( min:Number, max:Number, progress:Number ) :Number {
			return( (1-progress)*min + progress*max );
		}
	
		public static function isWithin( subject:Number, left:Number, right:Number ) :Boolean {
			return (left <= subject && subject <= right);
		}
		public static function isBetween( subject:Number, left:Number, right:Number ) :Boolean {
			return (left < subject && subject < right);
		}
	
		// Math.pow: If x is negative, and exponent is not an integer, returns NaN. (Based on the
		// unfortunate fact that it doesn't know how to flip the sign.)
		// This function always returns a positive value that conforms to the expected Exponent
		// curve. (see: http://en.wikipedia.org/wiki/Exponent )
		public static function powAbs( x:Number, exponent:Number ) :Number {
			if( x >= 0 ) {
				return Math.pow( x, exponent );
			} else {
				return Math.pow( Math.abs(x), 1/exponent );
			}
		}
	
		//
		// DSP SIGNAL PROCESSING
		//
	
		// Converts a 'unipolar' signal (0.0...1.0) to 'bipolar' (-1.0...1.0), and the reverse
		public static function uni2bi( n:Number ) :Number {
			return (n*2.0) - 1.0;
		}
		public static function bi2uni( n:Number ) :Number {
			return (n+1.0) / 2.0;
		}
	
		// Restrict a value between upper and lower limits
		public static function clamp( signal:Number, min:Number, max:Number ) :Number {
			return Math.max( min, Math.min( max, signal ) );
		}
	
		// Quantize a signal (0.0...1.0) to a limited output set of "steps"
		public static function quantize( signal:Number, steps:Number ) :Number {
			return Math.floor( signal * steps ) / (steps+1);
		}
	
		// Wrap a signal between 0..height.
		// Different from modulo because negative numbers will wrap upwards and become positive.
		public static function wrap( signal:Number, height:Number ) :Number {
			return signal - (Math.floor( signal / height ) * height);
		}
	
	}
	
}
