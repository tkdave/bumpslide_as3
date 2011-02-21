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

package com.bumpslide.ui 
{

	import com.bumpslide.data.type.Padding;
	import com.bumpslide.ui.skin.defaults.DefaultCheckboxSkin;

	import flash.events.Event;

	/**
	 * A checkbox is just a toggle button
	 * 
	 * @author David Knape
	 */
	public class CheckBox extends Button {

		static public var DefaultSkinClass:Class = DefaultCheckboxSkin;

		public function CheckBox(width:Number=-1, height:Number=-1, x:Number=0, y:Number=0, lbl:String="", is_selected:Boolean=false, on_change:Function=null )
		{
			super( width, height, x, y, lbl );

			selected = is_selected;
			
			if(on_change!=null) {
				addEventListener( Event.CHANGE, on_change, false, 0, true);
			}
		}

		override protected function addChildren():void {
			super.addChildren();
			toggle = true;
		}

		override protected function postConstruct():void 
		{
			super.postConstruct();			
			initDefaultSkin();
		}
		
		override protected function initDefaultSkin():void {
			//if(padding==null) {
			padding = new Padding( 0, 0, 0, 25 );
			//}
			
			if(skin==null && skinClass==null) {
				skinClass = DefaultSkinClass;
			}
		}

	}
}
