package com.bumpslide.ui.skin 
{
	import com.bumpslide.ui.IResizable;
	import flash.display.DisplayObject;

	/**
	 * Interface for skinnable components
	 * 
	 * Skins don't have to be ISkin.  They just get a few nice hooks if they do.
	 * 
	 * @author David Knape
	 */
	public interface ISkinnable extends IResizable
	{
		function set skinClass(c:Class):void;
		function get skinClass():Class;
		
		function set skinState(s:String):void;
		function get skinState():String;
		
		function set skin(mc:DisplayObject):void;
		function get skin():DisplayObject;	
		
			
	}
}
