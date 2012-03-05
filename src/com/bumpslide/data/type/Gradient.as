package com.bumpslide.data.type
{

	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.InterpolationMethod;
	import flash.display.SpreadMethod;
	import flash.geom.Matrix;

	/**
	 * Gradient
	 *
	 * @author David Knape
	 */
	public class Gradient extends Object
	{
		
		public var type:String = GradientType.LINEAR;
		public var colors:Array = [ 0x999999, 0xcccccc ];
		public var alphas:Array = [ 1.0, 1.0];
		public var ratios:Array = [ 0, 255 ];
		public var spreadMethod:String = SpreadMethod.PAD;
		public var interpolationMethod:String = InterpolationMethod.RGB;
		public var focalPointRatio:Number = 0;
		public var rotation:Number = 0;

		public function Gradient( _type:String=null, _colors:Array=null, _alphas:Array=null, _ratios:Array=null, _rotation:Number=0, _spreadMethod:String=null, _interpolationMethod:String=null, _focalPointRatio:Number=0 )
		{
			if(_type) type = _type;
			if(_colors) colors = _colors;
			if(_alphas) alphas = _alphas;
			if(_ratios) ratios = _ratios;
			if(_rotation) rotation = _rotation;
			if(_spreadMethod) spreadMethod = _spreadMethod;
			if(_interpolationMethod) interpolationMethod = _interpolationMethod;
			if(_focalPointRatio) focalPointRatio = _focalPointRatio;			
		}
		
		public function beginFill( g:Graphics, width:Number, height:Number ):void {
			var m:Matrix = new Matrix();
			m.createGradientBox(width, height, rotation);
			g.beginGradientFill( type, colors, alphas, ratios, m, spreadMethod, interpolationMethod, focalPointRatio );
		}
	}
}
