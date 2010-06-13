package com.bumpslide.ui.skin 
{
	import com.bumpslide.ui.Component;

	/**
	 * This is the base class for programmatic stateful skins
	 * 
	 * The ISkin draw method is implented in such a way that it looks
	 * for a method on the skin class with a name like '_'+hostComponent.skinState
	 * 
	 * If found, this method is called.  An example of this can be found in the 
	 * minimal button skin class.
	 * 
	 * @author David Knape
	 */
	public class BasicSkin extends Component implements ISkin 
	{			
		/**
		 * reference to component that is hosting this skin
		 */
		protected var _hostComponent:ISkinnable;

		/**
		 * 
		 */
		public function initHostComponent(host_component:ISkinnable):void
		{
			log('initHostComponent '+host_component);
			_hostComponent = host_component;
		}
		
		/**
		 * Default state change handler
		 * 
		 * Tries to call a function in this class with a name that is ('_' + currentState).
		 */
		public function renderSkin( skinState:String ):void
		{
			try {
				(this['_'+_hostComponent.skinState] as Function).call( this);
			} catch (e:Error) {
				// whatever
			}
		}
		
		override public function get width():Number {
			return _hostComponent ? _hostComponent.width : super.width;
		}
		
		override public function get height():Number {
			return _hostComponent ? _hostComponent.height : super.height;
		}
		
		
	}
}
