package com.bumpslide.data {

	/**
	 * Basic Value object interface
	 * 
	 * @author David Knape
	 */
	public interface IValueObject {

		function equals(value:Object):Boolean;

		function clone():Object;
	}
}
