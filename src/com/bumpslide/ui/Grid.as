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

package com.bumpslide.ui 
{
	import flash.events.Event;
	import com.bumpslide.util.GridLayout;

	import flash.events.MouseEvent;

	[Event(name="itemClick", type="com.bumpslide.events.UIEvent")]

	/**
	 * Component that contains a GridLayout managed data grid and a scrollbar
	 *   
	 * @author David Knape
	 */
	public class Grid extends AbstractScrollPanel {

		static public const EVENT_ITEM_CLICK:String = GridLayout.EVENT_ITEM_CLICK;

		public var layout:GridLayout;
		
		protected var _itemRenderer:Class=null;
		protected var _itemProps:Object;
		protected var _roundedCellDimensions:Boolean = false;
		
		public function Grid( item_renderer:Class=null, column_width:Number=100, row_height:Number=100, orientation:String='vertical' ) {
			super();
			gridItemRenderer = item_renderer;
			columnWidth = column_width;
			rowHeight = row_height;
			this.orientation = orientation;
		}		
				
		override protected function addChildren():void {
			
			layout = new GridLayout(_holder, gridItemRenderer);
			layout.itemInitProperties = gridItemProps;
			
			super.addChildren();
			
			// update when model (possibly length) changed
			layout.addEventListener( Event.CHANGE, eventDelegate( invalidate ) );
			layout.debugEnabled = logEnabled;
			
			_holder.cacheAsBitmap = false;		}
				override public function destroy():void {
			layout.destroy();
			super.destroy();		}

		override protected function initScrollTarget():void {
			scrollbar.scrollTarget = layout;			}

		override protected function onMouseWheel(event:MouseEvent):void {
			if(!mouseWheelEnabled) return;
			var amt:Number = scrollAmount / ( isVertical ? rowHeight : columnWidth);
			scrollbar.value -= event.delta * amt;
			layout.scrollPosition = scrollbar.value;
		}
				override public function reset():void {
			super.reset();
			layout.stopTweening();
			layout.offset = 0;
			scrollbar.value = 0;		}
		public function set dataProvider( dp:* ):void {
			if(layout.itemRenderer == null) layout.itemRenderer = (gridItemRenderer!=null) ? gridItemRenderer : GridItem;
			layout.itemInitProperties = gridItemProps;
			log('setting dataProvider ' + dp); 
			layout.dataProvider = dp;
			invalidate();
		}
		
		public function get dataProvider() : * {
			return layout.dataProvider;
		}
		
		/**
		 * Size the content
		 */
		override protected function setContentSize(w:Number, h:Number):void {
			
			if(isVertical) {
				w+=spacing;
			} else {
				h+=spacing;
			}
			
			var round:Function = _roundedCellDimensions ? Math.floor : function(n:Number):Number {return n;};
			
			if (fixedColumnCount > 0) {
				layout.columnWidth = round(w / fixedColumnCount );
				w = layout.columnWidth * fixedColumnCount;
				if (fixedAspectRatio > 0) {
					layout.rowHeight = round( layout.columnWidth / fixedAspectRatio);
				}
			}

			if (fixedRowCount > 0) {
				layout.rowHeight = round(h / fixedRowCount);
				h = layout.rowHeight * fixedRowCount;
				if (fixedAspectRatio > 0) {
					layout.columnWidth = round( layout.rowHeight * fixedAspectRatio);
				}
			}
						
			layout.setSize(w, h);
			
			super.setContentSize( w, h );
		}
				
		override public function get actualHeight():Number {
			if(layout && padding) {
				if(isVertical) {
					return layout.totalSize * layout.rowHeight + padding.height;	
				} else {
					return layout.rows;
				}
			} return super.actualHeight;
		}

		
		/**
		 * IGridItem implementation used to render cells
		 */
		public function get gridItemRenderer():Class {
			return _itemRenderer;
		}

		public function set gridItemRenderer(item_renderer:Class):void {
			_itemRenderer = item_renderer==null ? Button : item_renderer;
			//trace('_itemRenderer: ', _itemRenderer, item_renderer);
			//trace('layout: ' + (layout));
			if(layout != null) layout.itemRenderer = _itemRenderer;
		}

		
		override public function set orientation(orientation:String):void {
			if(_orientation == orientation) return;
			layout.orientation = orientation;
			super.orientation = orientation;						
		}		
		
		private var _fixedColumnCount:int=0;
		private var _fixedRowCount:int=0;
		private var _fixedAspectRatio:Number=0;
		
		public function get fixedRowCount():int {
			return _fixedRowCount;
		}
		
		public function set fixedRowCount(fixedRowCount:int):void {
			_fixedRowCount = fixedRowCount;
			invalidate();
		}
		
		public function get fixedColumnCount():int {
			return _fixedColumnCount;
		}
		
		public function set fixedColumnCount(fixedColumnCount:int):void {
			_fixedColumnCount = fixedColumnCount;
			invalidate();
		}
		
		public function get columnWidth():Number {
			return layout.columnWidth;
		}
		
		public function set columnWidth(fixedColumnWidth:Number):void {
			layout.columnWidth = fixedColumnWidth;
			invalidate();
		}
		
		public function get rowHeight():Number {
			return layout.rowHeight;
		}
		
		public function set rowHeight(fixedRowHeight:Number):void {
			layout.rowHeight = fixedRowHeight;
			invalidate();
		}
		
		public function get fixedAspectRatio():Number {
			return _fixedAspectRatio;
		}
		
		public function set fixedAspectRatio(fixedAspectRatio:Number):void {
			_fixedAspectRatio = fixedAspectRatio;
			invalidate();
		}
		
		override public function set tweenEnabled(tweenEnabled:Boolean):void {
			_tweenEnabled = tweenEnabled;
			layout.tweeningEnabled = tweenEnabled;
		}
		
		override public function set tweenEasingFactor(tweenEasingFactor:Number):void {
			_tweenEasingFactor = tweenEasingFactor;
			layout.scrollTweenEaseFactor = tweenEasingFactor;
		}
		
		public function get spacing():Number {
			return layout.spacing;
		}
		
		public function set spacing(spacing:Number):void {
			layout.spacing = spacing;
			invalidate();
		}
		
		/**
		 * get array of data associated with selected items
		 */
		public function get selectedItems():Array { 
			var data:Array = [];				
			for each ( var item:Button in layout.itemClips ) {
				if(item && item.selected) {
					data.push( item.gridItemData );
				}
			}
			return data;
		}
		
		
		public function get gridItemProps():Object {
			if(_itemProps==null) return { grid:this };
			return _itemProps;
		}
		
		/**
		 * Initial properties for grid items
		 */
		public function set gridItemProps(itemProps:Object):void {
			_itemProps = itemProps;
			// add grid to item props
			_itemProps.grid = this; 
			if(layout != null) layout.itemInitProperties = itemProps;
		}
		
		/**
		 * Returns data at index n
		 * 
		 * Optional param (data_provider) can be specified to grab data from a data provider that 
		 * has not yet been committed.
		 * 
		 * This method supports getting data from flash data providers, flex collections, and as3 arrays
		 */
		public function getItemAt( n:uint, data_provider:*=null ):* {
			var dp:* = data_provider ? data_provider : dataProvider;
			if(dp==null) return null;
			return dp.getItemAt != undefined ? dp.getItemAt( n ) : dp[n];
		}


		/**
		 * Whether or not cell dimensions should be rounded when auto-calculating 
		 * 
		 * This is ignored unless fixedRowCount or fixedColumnCount is set to true
		 */
		public function get roundedCellDimensions():Boolean {
			return _roundedCellDimensions;
		}


		public function set roundedCellDimensions( roundedCellDimensions:Boolean ):void {
			_roundedCellDimensions = roundedCellDimensions;
		}
	}
}