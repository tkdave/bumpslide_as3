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

package com.bumpslide.util {	import com.bumpslide.ui.Component;	import flash.display.DisplayObject;   	import flash.geom.Rectangle;   	    /**	* Alignment utilities	* 	* When designing resizable apps, it is often the case that movie clips need 	* to be programmatically aligned and/or centered.  The static methods in this	* class take care of the math involved in many of these cases.  When used on their	* own, they are handy.  When used in conjunction with StageProxy, they are stellar.	* 	* StageProxy is a singleton that proxies Stage.onResize events and can be used to 	* maintain min and max stage dimensions.  By default, the stageProxy's height and 	* width properties are used as the default value for the containerSize in these 	* methods.	* 	* The AS3 version of these methods no longer assume a 0,0 registration point, as	* we are aligning based on the clip bounds (getRect).	* 	* 	* @author David Knape	*/		public class Align	{		static public function get stageProxy () : StageProxy {			if(StageProxy.isInitialized()) return StageProxy.getInstance();			return null;		}						/**		* Right-aligns a clip		* 		* Example Usage: 		*   Align.right( mymenu_mc );		* 		* @param	clip		* @param	containerSize		* @param	clipSize		*/		static public function right(clip:DisplayObject, containerSize:Number=Number.NaN, clipSize:Number=Number.NaN) : void 		{ 				if(isNaN(containerSize) && stageProxy!=null) containerSize = stageProxy.width;								var rect:Rectangle = clip.getRect(clip);					if(isNaN(clipSize)) clipSize = rect.width;				clip.x = Math.round( containerSize - clipSize - rect.x);				}					/**		* Centers a clip horizontally		* 		* Example Usage: 		*   Align.center( mymenu_mc );		* 		* @param	clip		* @param	containerSize		* @param	clipSize		*/		static public function center( clip:DisplayObject, containerSize:Number=Number.NaN, clipSize:Number=Number.NaN ) : void 		{				if(isNaN(containerSize) && stageProxy!=null) containerSize = stageProxy.width;			var rect:Rectangle = clip.getRect(clip);			if(isNaN(clipSize)) clipSize = rect.width;								clip.x = Math.round( (containerSize - clipSize - rect.x) / 2);		}						/**		* Centers a clip vertically 		* 		* Example Usage: 		*   Align.middle( mymenu_mc );		* 		* @param	clip		* @param	containerSize		* @param	clipSize		*/		static public function middle( clip:DisplayObject, containerSize:Number=Number.NaN, clipSize:Number=Number.NaN ) : void 		{				if(isNaN(containerSize) && stageProxy!=null) containerSize = stageProxy.height;			var rect:Rectangle = clip.getRect(clip);			if(isNaN(clipSize)) clipSize = rect.height;								clip.y = Math.round( (containerSize - clipSize - rect.y) / 2);		}				/**		* Aligns a clip with the bottom of a container		* 		* Example Usage: 		*   Align.bottom( mymenu_mc );		* 		* @param	clip		* @param	containerSize		* @param	clipSize		*/		static public function bottom( clip:DisplayObject, containerSize:Number=Number.NaN, clipSize:Number=Number.NaN ) : void 		{				if(isNaN(containerSize) && stageProxy!=null) containerSize = stageProxy.height;			var rect:Rectangle = clip.getRect(clip);			if(isNaN(clipSize)) clipSize = rect.height;								clip.y = Math.round( (containerSize - clipSize - rect.y) );		}			/**		* arranges movie clips in a column as if they are in a VBox 		*  
		* If you want to render it yourself (with tweens, for instance), pass in a callback
		* as the third parameter to this function. 
		* 
		* Example:
		* <code>
		*     Align.vbox( clips, spacing, function ( mc:Sprite, position:) {
		* 		        	
		*     } );
		* </code>
		* 		* @param	clips		* @param	padding
		* @param 	callback		*/		static public function vbox( clips:Array, spacing:Number=2, callback:Function=null ) : void {			var count:int = clips.length;			if(count<2) return;				var yPos:Number = 0;//(clips[0] as DisplayObject).getBounds( clips[0].parent ).bottom + padding;	
						for(var n:uint=0; n<count; ++n) {				var mc:DisplayObject = clips[n] as DisplayObject;
				if(mc==null) continue;				// If clip is invisible, don't include in layout
				if(mc.visible==false) continue;				if(mc is Component) {
					callBackOrSetProperty( callback, mc, 'y', yPos );					yPos += mc.height + spacing;				} else {
					var mc_bounds:Rectangle = mc.getBounds( mc );
					callBackOrSetProperty( callback, mc, 'y', yPos + mc.y - mc_bounds.top );					yPos += mc_bounds.height + spacing;				}			}				}
		
		static private function callBackOrSetProperty( callback:Function, obj:Object, prop:String, value:* ):void {
			if(callback is Function) {
				callback.call( null, obj, value );
			} else {
				obj[prop] = value;
			}
		}				/**		* arranges movie clips in a row as if they are in a HBox		* 		* @param	clips		* @param	padding		*/		static public function hbox( clips:Array, spacing:Number=2, callback:Function=null ) : void {			var count:int = clips.length;			if(count<2) return;					var xPos:Number = 0;//(clips[0] as DisplayObject).getBounds( clips[0].parent ).right + padding;				for(var n:uint=0; n<count; ++n) {				var mc:DisplayObject = clips[n] as DisplayObject;
				if(mc==null) continue;				// If clip is invisible, don't include in layout
				if(mc.visible==false) continue;
				if(mc is Component) {
					callBackOrSetProperty( callback, mc, 'x', xPos );
					xPos += mc.width + spacing;
				} else {
					var mc_bounds:Rectangle = mc.getBounds( mc );
					callBackOrSetProperty( callback, mc, 'x', xPos + mc.x - mc_bounds.left);
					xPos += mc_bounds.width + spacing;
				}			}				}				}}