package com.bumpslide.ui.skin 
{
	/**
	 * Interface for component skins
	 * 
	 * @author David Knape
	 */
	public interface ISkin
	{	
		
		/**
		 * Init Host
		 */
		function initHostComponent( host_component:ISkinnable ):void;
		
		
		/**
		 * State has changed.  Update display list.
		 */
		function renderSkin( skinState:String ):void;
		
		
		/**
		 * Take down children
		 */
		function destroy():void;
		
		
	}
}
