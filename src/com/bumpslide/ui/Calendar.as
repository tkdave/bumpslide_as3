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

	import com.bumpslide.data.constant.Unit;
	import com.bumpslide.events.UIEvent;
	import com.bumpslide.util.DateUtil;

	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * Calendar Control
	 * 
	 * This is the calendar used in the DatePicker
	 *
	 * @author David Knape
	 */
	public class Calendar extends Component 
	{	
		// the month we are displaying
		private var _displayDate:Date;
		private var _displayDateChanged:Boolean;
		
		// selected date
		private var _selectedDate:Date;
		private var _selectedDateChanged:Boolean;
		
		// child components
		private var leftButton:Button;
		private var rightButton:Button;
		private var monthLabel:Label;
		private var grid:Grid;
		private var topPanel:Panel;

		private var _monthChanged:Boolean = false;

		
		override protected function init():void
		{
			super.init();
			displayDate = new Date();
			selectedDate = new Date();
		}


		override protected function addChildren():void
		{
			grid = add( Grid, { padding:"28 4 0 4", gridItemRenderer:DayRenderer, fixedColumnCount:7, rowHeight:24, spacing:0 } );
			grid.addEventListener( Grid.EVENT_ITEM_CLICK, handleDayClick );
			grid.skin = null;

			var c:Component = new Component();
			monthLabel = c.add( Label, { x:24, selectable:false, alignH:"center" } );
			leftButton = c.add( Button, { height:16, width:16, onClick:handleClickBack } );
			rightButton = c.add( Button, { height:16, width:16, onClick:handleClickForward, alignH:"right" } );

			leftButton.icon = new PixelIcon( [ '  *', ' **', '***', ' **', '  *' ] );

			rightButton.icon = new PixelIcon( [ '*', '**', '***', '**', '*' ] );

			topPanel = add( Panel, { content:c, padding:4 } );
			// topPanel.background.filters = [Style.BEVEL_FILTER_INSET];
		}


		override protected function initSize():void
		{
			width = 500;
			height = 330;
		}


		override protected function draw():void
		{
			var first_day:int = new Date( displayDate.fullYear, displayDate.month, 1 ).day;
			var num_days:int = DateUtil.getLastDayOfMonth( displayDate.month, displayDate.fullYear );
			var n:int;

			if (_monthChanged) {
				// update month label
				monthLabel.text = DateUtil.getFormatted( displayDate, false, false, false );

				// create array of dates indexed starting with day of week
				var days:Array = [];
				for (n = 0; n < num_days; n++) {
					days[ first_day + n] = create( DayVO, { date:new Date( displayDate.fullYear, displayDate.month, n + 1 ) } );
				}
				grid.dataProvider = days;
				grid.updateNow();
			}

			// set size
			topPanel.setSize( width, 24 );
			grid.setSize( width, width );

			// update now so we have items to select
			grid.layout.updateNow();

			// select selected day
			if (_selectedDateChanged || _displayDateChanged) {
				for (n = 0; n < num_days; n++) {
					var item:Button = grid.layout.getGridItemAt( first_day + n ) as Button;
					if (item != null && item.gridItemData != null) {
						var d:Date = new Date( DayVO(item.gridItemData).date );
						// DateUtil.roundDown(d, Unit.DAY);
						item.selected = d.time == selectedDate.time;
					}
				}
			}

			_selectedDateChanged = false;
			_displayDateChanged = false;
			_monthChanged = false;

			super.draw();
		}


		override public function get actualHeight():Number {
			return grid.y + grid.actualHeight;
		}


		protected function handleDayClick( event:UIEvent ):void
		{
			selectedDate = new Date( (event.data as DayVO).date );
			dispatchEvent( new Event( Event.SELECT ) );
		}


		protected function handleClickBack( event:MouseEvent ):void
		{
			displayDate.month--;
			_displayDateChanged = true;
			_monthChanged = true;
			invalidate();
		}


		protected function handleClickForward( event:MouseEvent ):void
		{
			displayDate.month++;
			_displayDateChanged = true;
			_monthChanged = true;
			invalidate();
		}


		public function get selectedDate():Date {
			return _selectedDate;
		}


		public function set selectedDate( selectedDate:Date ):void {
			_selectedDate = new Date( selectedDate );
			DateUtil.roundDown( _selectedDate, Unit.DAY );
			_selectedDateChanged = true;
			displayDate = _selectedDate;
			invalidate();
		}


		public function get displayDate():Date {
			return _displayDate;
		}


		public function set displayDate( displayDate:Date ):void {
			var orig_time:Number = _displayDate ? _displayDate.time : 0;
			_displayDate = new Date( displayDate );

			if (orig_time != _displayDate.time) {
				_displayDateChanged = true;

				DateUtil.roundDown( _displayDate, Unit.MONTH );
				if (orig_time != _displayDate.time) {
					_monthChanged = true;
				}
				invalidate();
			}

			DateUtil.roundDown( _displayDate, Unit.MONTH );
			if (orig_time != _displayDate.time) {
				_displayDateChanged = true;
				invalidate();
			}
		}
	}
}

import com.bumpslide.ui.Box;
import com.bumpslide.ui.Button;
import com.bumpslide.ui.skin.defaults.DefaultButtonSkin;
import com.bumpslide.ui.skin.defaults.Style;


class DayVO extends Object {
	public var date:Date;
	public function toString():String {
		return String(date.date);
	}
}

class DayRenderer extends Button 
{	
	
	override protected function addChildren():void
	{
		super.addChildren();
		padding = 0;
	}
	
	public function get background():Box {
		if(skin) return (skin as DefaultButtonSkin).background as Box;
		else return null;
	}
	
	override protected function draw():void 
	{
		visible = (gridItemData!=null);
		
		
		super.draw();
		
		if(background) {
			background.filters = [];
			background.borderWidth = 1;
			background.borderColor = Style.INPUT_FOCUS_BORDER;
		}
	}
}
