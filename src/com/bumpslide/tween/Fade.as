package com.bumpslide.tween 
{
	import flash.display.DisplayObject;
	import flash.utils.getDefinitionByName;

	/**
	 * FadeIn/FadeOut shortcuts using TweenLite
	 * 
	 * These are the functions that were in BaseClip.
	 * They have been moved here to remove the dependencies 
	 * on an external tweening engine. 
	 * 
	 * We have also made these functions use dynamically linked
	 * references to TweenLite and the required easing equation.
	 * 
	 * Make sure you are using these else where by putting some 
	 * code like this somewhere in your project:
	 * 
	 * <code>
	 *   static private var useTweenLite:Boolean = InitTweenLite();
	 *   private static function InitTweenLite():Boolean {
	 *     // make sure we have TweenLite and Quad imported
	 *     TweenLite.defaultEase = Quad.easeOut;
	 *     return true;
	 *   }
	 * </code>
	 *   
	 * @author David Knape
	 */
	public class Fade {
		
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
			var tweenFunc:Function = getDefinitionByName('gs.TweenLite.to') as Function;
			var easeFunc:Function = getDefinitionByName('gs.easing.Quad.easeOut') as Function;
			tweenFunc.call( null, target, duration, { 'autoAlpha':1, ease:easeFunc, delay:delay, onComplete:onComplete, overwrite:2});         
		}
		
		/**
		 *  fade out - with onComplete callback which gets run instantaneously if no tween is neded
		 */
		static public function Out(target:DisplayObject, delay:Number=.1, duration:Number=.2, onComplete:Function=null) : void {
			if (!target.visible) { target.alpha = 0; if(onComplete!=null) onComplete.call(null); return; }
			var tweenFunc:Function = getDefinitionByName('gs.TweenLite.to') as Function;
			var easeFunc:Function = getDefinitionByName('gs.easing.Quad.easeIn') as Function;
			tweenFunc.call( null, target, duration, { 'autoAlpha':0, ease:easeFunc, delay:delay, onComplete:onComplete, overwrite:2});        
		}
		
		static public function Cancel( target:DisplayObject ) : void {
			var killFunc:Function = getDefinitionByName('gs.TweenLite.killTweensOf') as Function;
			killFunc.call( null, target );
		}
		
	}
}
