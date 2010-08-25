package com.bumpslide.ui.skin.defaults 
{
	import com.bumpslide.util.DateUtil;
	import com.bumpslide.ui.Button;
	import com.bumpslide.ui.Calendar;
	import com.bumpslide.ui.DatePicker;
	import com.bumpslide.ui.Label;
	import com.bumpslide.ui.Panel;
	import com.bumpslide.ui.skin.BasicSkin;

	import flash.display.BlendMode;
	import flash.events.Event;
	import flash.filters.DropShadowFilter;

	/**
	 * DefaultDatePickerSkin
	 * 
	 * A click on anywhere on this skin will launch the calendar popup
	 *
	 * @author David Knape
	 * @version SVN: $Id: $
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
			dateLabel = add(Label, { x: 24, autoSize: true });
			chooseButton = add(Button, { width: 21, height: 21, icon: CalendarIcon });
		}
		
		override public function renderSkin(skinState:String):void 
		{
			dateLabel.text = DateUtil.getFormatted( hostComponent.selectedDate, hostComponent.showTime, true, false, true, true );	
		}
	}
}
