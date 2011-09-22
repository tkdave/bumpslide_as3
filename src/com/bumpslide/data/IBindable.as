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
		
		function unbind( target:Object, property:String=null ):void;
		
	}
}
