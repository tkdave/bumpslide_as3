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

package com.bumpslide.ui {	    /**     * Grid Item Interface     *      * This interface should be implemented by clips that      * are controlled by a GridLayout instance.     *      * @author David Knape     */    public interface IGridItem {    	    	// cancel any pending loader activity, remove event listeners, and die    	// this is implemented alredy in Component, and thus Button    	function destroy () : void;    	    	// setter used to assign grid index to your grid item    	function set gridIndex (n:Number):void;    	function get gridIndex () : Number;    	    	// setter used to pass in the data for this position in the dataprovider    	function set gridItemData (d:*):void;    	function get gridItemData () : *;    	    	    	    	// standard display object stuff (most likely already implemented)    	function set x (n:Number) : void;    	    	function set y (n:Number) : void;
    	
    	function get x ():Number;    	
    	function get y ():Number;    		    	function set visible (val:Boolean) : void;    	function get visible () : Boolean;    	    }}