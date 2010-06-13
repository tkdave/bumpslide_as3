/**
 * This code is part of the Bumpslide Library by David Knape
 * http://bumpslide.com/
 * 
 * Copyright (c) 2006, 2007, 2008 by Bumpslide, Inc.
 * 
 * Released under the open-source MIT license.
 * http://www.opensource.org/licenses/mit-license.php
 * see LICENSE.txt for full license terms
 */ 
 
package com.bumpslide.ui 
{
	import com.bumpslide.util.GridLayout;

	import flash.events.MouseEvent;

	/**
	 * Component that contains a GridLayout managed data grid and a scrollbar
	 *   
	 * @author David Knape
	 */
	public class Grid extends AbstractScrollPanel {

		static public const EVENT_ITEM_CLICK:String = "onGridItemClick";
		
		public var layout:GridLayout;
		
		protected var _itemRenderer:Class=null;
		protected var _itemProps:Object;
		
		public function Grid( item_renderer:Class=null, column_width:Number=100, row_height:Number=100, orientation:String='vertical' ) {
			super();
			gridItemRenderer = item_renderer;
			columnWidth = column_width;
			rowHeight = row_height;
			this.orientation = orientation;
		}		
				
		override protected function addChildren():void {
			super.addChildren();
			//updateDelay = 1;
			_holder.cacheAsBitmap = false;		}
				override public function destroy():void {
			layout.destroy();
			super.destroy();		}
		override protected function initContent():void {			
			super.initContent();
			layout = new GridLayout(_holder, gridItemRenderer);
			layout.itemInitProperties = gridItemProps;
			layout.addEventListener( GridLayout.EVENT_MODEL_CHANGED, eventDelegate( invalidate ) );
			//layout.debugEnabled = true;
		}

		override protected function initScrollTarget():void {
			scrollbar.scrollTarget = layout;			}

		override protected function onMouseWheel(event:MouseEvent):void {
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
			if(layout.itemRenderer == null) layout.itemRenderer = GridItem;
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
			
			if(fixedColumnCount>0) {
				layout.columnWidth =  Math.floor(w/fixedColumnCount );
				w = layout.columnWidth * fixedColumnCount;
				if(fixedAspectRatio>0) {
					layout.rowHeight =  Math.floor( layout.columnWidth / fixedAspectRatio);
				}
			}
			
			if(fixedRowCount>0) {
				layout.rowHeight =  Math.floor(h/fixedRowCount);
				h = layout.rowHeight * fixedRowCount;
				if(fixedAspectRatio>0) {
					layout.columnWidth = Math.floor( layout.rowHeight * fixedAspectRatio);
				}
			}
						
			layout.setSize(w, h);
			
			super.setContentSize( w, h );
		}

		
		/**
		 * IGridItem implementation used to render cells
		 */
		public function get gridItemRenderer():Class {
			return _itemRenderer;
		}

		public function set gridItemRenderer(item_renderer:Class):void {
			_itemRenderer = item_renderer==null ? GridItem : item_renderer;
			//trace('_itemRenderer: ' + (_itemRenderer));
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
		
		public function get gridItemProps():Object {
			return _itemProps;
		}
		
		/**
		 * Initial properties for grid items
		 */
		public function set gridItemProps(itemProps:Object):void {
			_itemProps = itemProps;
			if(layout != null) layout.itemInitProperties = itemProps;
		}
	}
}