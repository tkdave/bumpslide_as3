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

package com.bumpslide.ui {
	import com.bumpslide.util.GridLayout;		
	/**	 * Basic Grid Item including invalidation/update hook and buttonMode init	 * 	 * Use this as a base class for cell renderers in GridLayout grids.  	 * Or, you can make your own class that implements IGridItem.	 *   	 * If you just want to process grid item clicks, listen for the	 * UIEvent of type Grid.EVENT_ITEM_CLICK.  This is actually dispatched 	 * from within GridLayout, and the data attribute of this event is the 	 * gridItemData for this item. 	 * 	 * @author David Knape	 * @see com.bumpslide.ui.ListItem	 */	public class GridItem extends Component implements IGridItem {				// our place in line		protected var _gridIndex:Number;		// what defines us		protected var _gridItemData:*;		// ancestral ties		public var layout:GridLayout;						//----------------------------------------------		// Methods to override in GridItem Sub Classes		//----------------------------------------------		/**		 * Implement grid item view update here. 		 */		protected function drawGridItem():void {			//label = gridItemData;		}				/**		 * Called when data is set to null (when clip is recycled)		 * 		 * This isn't as important to override unless you need to remove 		 * some event listeners that were added during 'drawGridItem'.		 */				protected function clearGridItem():void {			//label = "";		}						//----------------------------------------------				/**		 * Sets updateDelay to 0 so we don't have any flicker in our scrolling grids		 */		override protected function addChildren():void {						//delayUpdate = false;            			super.addChildren();		}
			/**		 * Override if you want, but you shouldn't need to.		 */		override protected function draw():void {				if(hasChanged(VALID_DATA)) {				if(gridItemData!=null) {					drawGridItem();				} else {					clearGridItem();				}				validate(VALID_DATA);			}			super.draw();		}     				//------------------------------------		// IGridItem Interface implementation		//------------------------------------        		/**		 * grid index		 */		public function get gridIndex():Number {			return _gridIndex;		}		/**		 * the grid dataprovider's item at this index		 */		public function get gridItemData():* {			return _gridItemData;		}		/**		 * sets grid index (used by GridLayout)		 */		public function set gridIndex(n:Number):void {			_gridIndex = n;
			invalidate(VALID_DATA);		}		/**		 * Updates data (used by GridLayout)		 * 		 * This is where we call invalidate to trigger an update process		 */		public function set gridItemData(d:*):void {			_gridItemData = d;
			// turn off delayed updates if you need it to clear immediately//			if(_gridItemData==null) {//				// clear it now//				clearGridItem();//			}			invalidate(VALID_DATA);					}					}}