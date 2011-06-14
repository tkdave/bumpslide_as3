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

	import com.greensock.TweenLite;
	import com.greensock.easing.Quad;

	import flash.display.DisplayObject;

	/**
	 * FadeIn/FadeOut shortcuts using TweenLite
	 * 
	 * These are the functions that were in BaseClip.
	 * They have been moved here to remove the dependencies 
	 * on an external tweening engine.
	 *   
	 * @author David Knape
	 */
	public class Fade {
		
		static public var Easing:Class = Quad;
		
		/**
		 *  fade in - with onComplete callback which gets run instantaneously if no tween is neded
		 */
		static public function In(target:DisplayObject, delay:Number=0, duration:Number=.4, onComplete:Function=null) : void {			
			if (target.alpha == 1 && target.visible) {
				if(onComplete!=null) onComplete.call(null); 
				return;
			}
			if(!target.visible) {
				target.visible = true; 
				target.alpha=0;
			}
			TweenLite.to( target, duration, { autoAlpha:1.0, ease:Easing.easeOut, delay:delay, onComplete:onComplete, overwrite:2});
		}
		
		/**
		 *  fade out - with onComplete callback which gets run instantaneously if no tween is neded
		 */
		static public function Out(target:DisplayObject, delay:Number=.1, duration:Number=.2, onComplete:Function=null) : void {
			if (!target.visible) { target.alpha = 0; if(onComplete!=null) onComplete.call(null); return; }
			TweenLite.to( target, duration, { autoAlpha:0, ease:Easing.easeIn, delay:delay, onComplete:onComplete, overwrite:2});   
		}
		
		static public function Cancel( target:DisplayObject ) : void {
			TweenLite.killTweensOf( target );
		}
		
		
		
	}
}
