package com.bumpslide.data {

	/**
	 * Pritoritiziable Interface for use with hacked version of  polygonal.de PriorityQueue
	 * 
	 * @author David Knape
	 */
	public interface IPrioritizable {
		function get priority():int;
		function set priority(p:int):void;
		function get creationIndex() : int;
		
	}
}
