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

package com.bumpslide.ui {	import com.bumpslide.data.constant.Direction;		import com.bumpslide.ui.Slider;		/**	 * This class exists so we can distinquish from normal sliders in a FLA file	 * 	 * @author David Knape	 */	public class VSlider extends Slider {		public function VSlider() { super(Direction.VERTICAL); }	}}