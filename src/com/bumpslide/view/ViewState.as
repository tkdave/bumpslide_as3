package com.bumpslide.view 
{
	/**
	 * ViewState constants
	 *
	 * @author David Knape
	 * @version SVN: $Id: ViewState.as 194 2010-01-28 19:29:17Z tkdave $
	 */
	public class ViewState 
	{
		
		/**
		 * Transitioning out
		 * 
		 * Should be set as transition out begins
		 */
		public static const TRANSITIONING_OUT:String = "transOut";
		
		/**
		 * Transitioning In
		 * 
		 * Should be set as transition in begins
		 */
		public static const TRANSITIONING_IN:String = "transIn";
		
		/**
		 * Component is currently active
		 * 
		 * Should be set when transition in is complete
		 */
		public static const ACTIVE:String = "active";
		
		/**
		 * Component is not active 
		 * 
		 * Should be set when transition out is complete
		 */
		public static const INACTIVE:String = "inactive";
		
		
	}
}
