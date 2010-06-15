package com.bumpslide.ui 
{
	import com.bumpslide.tween.FTween;
	import com.bumpslide.util.DateUtil;

	import flash.display.BlendMode;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;

	/**
	 * DatePicker
	 * 
	 * Displays Date and contains button that, when clicked, opens a calendar control popup.
	 *
	 * @author David Knape
	 * @version SVN: $Id: $
	 */
	public class DatePicker extends Component 
	{
		
		// The calendar icon
		[Embed(source="/assets/calendar_icon2.png")]
		public var CalendarIcon:Class;

		public var dateLabel:Label;

		public var chooseButton:Button;

		public var popup:Panel;

		public var popupHolder:DisplayObjectContainer;

		private var cal:Calendar;

		private var _selectedDate:Date;

		
		override protected function addChildren():void 
		{
			super.addChildren();
			
			selectedDate = new Date();
			
			dateLabel = add(Label, { x: 24 });
			chooseButton = add(Button, { width: 21, height: 21, onClick: handleChooseButtonClick, icon: CalendarIcon });
			
			cal = new Calendar();
			popup = new Panel(cal);
			popup.setSize( 160, 160 );
			popup.alpha = 0;
			popup.blendMode = BlendMode.LAYER;
			popup.filters = [new DropShadowFilter(2, 45, 0, .5, 3, 3, 1, 2)];
			
			cal.addEventListener(Event.SELECT, handleDateSelect);
				
			addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
		}


		
		override protected function draw():void 
		{
			dateLabel.text = DateUtil.getFormatted(selectedDate, false, true, false);			
			super.draw();
		}

		
		private function handleDateSelect(event:Event):void 
		{
			selectedDate = cal.selectedDate;
			hidePopup();			
		}

		
		private function handleAddedToStage(event:Event):void 
		{
			if(popupHolder == null) popupHolder = stage;
		}

		
		protected function handleChooseButtonClick(event:MouseEvent):void 
		{
			if(isOpen) hidePopup();
			else showPopup();
		}

		
		protected function showPopup():void 
		{	
			var max_x:Number = popupHolder == stage ? stage.stageWidth : popupHolder.width;
			max_x -= popup.width + Style.PADDING;
			
			var max_y:Number = popupHolder == stage ? stage.stageHeight : popupHolder.height;
			max_y -= popup.height + Style.PADDING;
			
			var px:Number = Math.max(0, Math.min(max_x, popupHolder.mouseX + 20));
			var py:Number = Math.max(0, Math.min(max_y, popupHolder.mouseY - 20));
			
			
			popupHolder.addChild(popup);
			popup.move(px, py);
						
			cal.selectedDate = selectedDate;
			FTween.fadeIn(popup, 0, .5);
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, handleStageMouseDown);
			
		}

		
		private function handleStageMouseDown(event:MouseEvent):void 
		{
			if(!popup.hitTestPoint(stage.mouseX, stage.mouseY)) {
				hidePopup();
			}
		}

		
		protected function hidePopup():void 
		{
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, handleStageMouseDown);
			FTween.fadeOut(popup, 0, .7, d(popupHolder.removeChild, popup));
		}

		
		public function get isOpen():Boolean {
			return popupHolder.contains(popup);
		}

		
		public function get selectedDate():Date {
			return _selectedDate;
		}

		
		public function set selectedDate(selectedDate:Date):void {
			_selectedDate = selectedDate;
			invalidate();
		}
	}
}