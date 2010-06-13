package com.bumpslide.ui {
	import flash.display.*;
	import flash.geom.Matrix;	

	/**
	 * Bitmap reflection of a display object
	 * 
	 * Usage:
	 * <code>
	 *   
	 *   // init...
	 *   var reflection:Reflection = new Reflection();
	 *   reflection.x = someContent.x;
	 *   reflection.y = someContent.y + someContent.height;	 *   
	 *   addChild( reflection );
	 *   
	 *   // update...
	 *   reflection.reflect( someContent );
	 *   
	 * </code>
	 * 
	 * @author David Knape
	 */
	public class Reflection extends Bitmap {

		public var distance:Number = 100;	

		public function reflect(source:DisplayObject):void {
			if(!bitmapData || bitmapData.height != distance || bitmapData.width != source.width) {
				bitmapData = new BitmapData(source.width, distance, true, 0x00000000);
			}						
			// draw reflection
			var mtx:Matrix = new Matrix();
			mtx.ty = -source.height;
			mtx.scale(source.scaleX, -source.scaleY);
			bitmapData.draw(source, mtx, source.transform.colorTransform, BlendMode.LAYER);
			
			// draw gradient with alpha blend mode to fade it out
			var gradient:Shape = new Shape();
			var matr:Matrix = new Matrix();
			matr.createGradientBox(source.width, distance, Math.PI / 2, 0, 0);
			gradient.graphics.beginGradientFill(GradientType.LINEAR, [0x000000, 0x000000], [.2, 0], [0, 255], matr);  
			gradient.graphics.drawRect(0, 0, bitmapData.width, bitmapData.height);
			bitmapData.draw(gradient, null, null, BlendMode.ALPHA);
		}
	}
}
