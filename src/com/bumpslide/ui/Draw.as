package com.bumpslide.ui {
	import flash.display.Graphics;
	import flash.geom.Point;		

	/**
	 * @author David Knape
	 */
	public class Draw {
		
		/**
		 * Draw a dashed line using the drawing API line drawing 
		 * 
		 * Use graphics.lineStyle to determine color and tweak other proeprties.
		 * 
		 * Note that a dash length of 1 will actually show up as more than a pixel due
		 * to limitations with the drawing API.  Use a bitmap fill for pixel perfect stuff.
		 */
		static public function dashedLine( graphics:Graphics, from:Point, to:Point, len:Number=5, gap:Number=5 ) : void {
			
			var dist:Number = Point.distance(from, to);
			if(dist==0) return;
			var lStep:Number = (len/dist);
			var gStep:Number = (gap/dist);
			var n:Number=0;
			while( n<1 ) {		
				var p1:Point = Point.interpolate( to, from, n );
				n+=lStep;
				var p2:Point = Point.interpolate( to, from, n );
				n+=gStep;
				graphics.moveTo( p1.x, p1.y );
				graphics.lineTo( p2.x, p2.y );				
			}			
		} 
		
		/**
		 * Draws a dotted line using draging API circles for each dot
		 * 
		 * Use graphics.beginFill to determine color
		 */
		static public function dottedLine( graphics:Graphics, from:Point, to:Point, spacing:Number=5, radius:Number=1 ):void {
			var dist:Number = Point.distance(from, to);
			if(dist==0) return;
			var step:Number = ((spacing+radius*2)/dist);
			var n:Number=0;
			while( n<1 ) {		
				var p:Point = Point.interpolate( to, from, n );				
				graphics.drawCircle(p.x, p.y, radius);			
				n+=step;
			}	
		}
		
		/**
		 * Pixel perfect dotted line (each dot is a pixel)
		 * 
		 * Use graphics.beginFill to determine color
		 */
		static public function pixelDottedLine( graphics:Graphics, from:Point, to:Point, spacing:Number=5 ):void {
			var dist:Number = Point.distance(from, to);
			if(dist==0) return;
			var step:Number = ((spacing+1)/dist);
			var n:Number=0;
			while( n<1 ) {		
				var p:Point = Point.interpolate( to, from, n );	
				graphics.drawRect( Math.round(p.x), Math.round(p.y), 1, 1);
				n+=step;
			}	
		} 
	}
}
