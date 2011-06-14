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
package com.bumpslide.ui.skin.defaults
{

	import com.bumpslide.ui.Button;
	import com.bumpslide.ui.DatePicker;
	import com.bumpslide.ui.Label;
	import com.bumpslide.ui.skin.BasicSkin;
	import com.bumpslide.util.DateUtil;


	/**
	 * DefaultDatePickerSkin
	 * 
	 * A click on anywhere on this skin will launch the calendar popup
	 *
	 * @author David Knape
	 */
	public class DefaultDatePickerSkin extends BasicSkin
	{
		// The calendar icon
		[Embed(source="/assets/calendar_icon2.png")]
		public var CalendarIcon:Class;
		
		private var dateLabel:Label;
		private var chooseButton:Button;

		public function get hostComponent():DatePicker {
			return _hostComponent as DatePicker;
		}


		override protected function addChildren():void
		{
			dateLabel = add( Label, { x:24, text:'Select a date...' } );
			chooseButton = add( Button, { width:21, height:21, icon:CalendarIcon } );
		}


		override protected function draw():void
		{
			super.draw();
			dateLabel.text = DateUtil.getFormatted( hostComponent.selectedDate, hostComponent.showTime, true, false, true, true );
		}
	}
}
