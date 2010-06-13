package com.bumpslide.data {

	/**
	 * Represents bindable things.
	 * 
	 * This interface is just a suggested API for advertising the fact
	 * that a specific class dispatches events of the type ModelChangeEvent
	 * 
	 * Example implementations are in data.BindableModel and ui.Component 
	 * 
	 * @see BindableModel for implementation.
	 * 
	 * @author David Knape
	 */
	public interface IBindable {
		
		function bind( property:String, target:Object, setterOrFunction:*=null ):Binding ;
		
		function unbind( target:Object ):void;
		
	}
}
