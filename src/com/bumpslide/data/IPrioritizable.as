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
