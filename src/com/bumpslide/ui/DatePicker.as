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

	import com.bumpslide.events.UIEvent;
	import com.bumpslide.tween.FTween;
	import com.bumpslide.ui.skin.defaults.DefaultDatePickerSkin;
	import com.bumpslide.ui.skin.defaults.Style;

	import flash.display.BlendMode;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * DatePicker
	 * 
	 * Displays Date and contains button that, when clicked, opens a calendar control popup.
	 *
	 * @author David Knape
	 */
	public class DatePicker extends Component 
	{
		static public var DefaultSkinClass:Class = DefaultDatePickerSkin;
		
		// panel that holds the calendar display
		public var popup:Panel;

		// the stage (or wherever else you want the popup to live)
		public var popupHolder:DisplayObjectContainer;
		
		// the calendar control contained in the popup panel
		protected var cal:Calendar;
		
		private var _showTime:Boolean = true;
				
		private var _selectedDate:Date = new Date();

		
		override protected function addChildren():void 
		{
			cal = new Calendar();
			cal.addEventListener(Event.SELECT, handleDateSelect);
			
			popup = new Panel(cal);
			popup.setSize( 200, 200 );
			popup.alpha = 0;
			popup.blendMode = BlendMode.LAYER;
			popup.filters = [Style.DROPSHADOW_FILTER];
			popup.autoSizeHeight = true;
			addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
			
			popup.addEventListener( Component.EVENT_DRAW, handlePopupRedraw);
		}

		
		private function handlePopupRedraw(event:UIEvent):void 
		{
			if(event.target==popup.content) layoutChildren();
		}

		
		override protected function postConstruct():void 
		{
			super.postConstruct();
			if(skin==null && skinClass==null) {
				skinClass = DefaultSkinClass;
			}
		}

		
		override protected function initSkinParts():void 
		{
			super.initSkinParts();		
			skin.addEventListener( MouseEvent.CLICK, handleChooseButtonClick );
		}

			
		override protected function destroySkin():void 
		{
			skin.removeEventListener( MouseEvent.CLICK, handleChooseButtonClick );						
			super.destroySkin();
		}

		
		public function set onSelect( f:Function):void {
			cal.addEventListener(Event.SELECT, f);
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

		
		override public function layoutChildren():void 
		{
			//super.layoutChildren();
			if(!isOpen) return;
			
			var max_x:Number = popupHolder == stage ? stage.stageWidth : popupHolder.width;
			max_x -= popup.width + Style.PANEL_PADDING;
			
			var max_y:Number = popupHolder == stage ? stage.stageHeight : popupHolder.height;
			max_y -= popup.height + Style.PANEL_PADDING;
			//trace('layout datepicker popup');
			var px:Number = Math.max(0, Math.min(max_x, getBounds(popupHolder).left + 20));
			var py:Number = Math.max(0, Math.min(max_y, getBounds(popupHolder).top - 100));
			popup.move(px, py);
		}

		
		protected function showPopup():void 
		{			
			//trace('show popup');	
			popupHolder.addChild(popup);
									
			cal.selectedDate = selectedDate;
			FTween.fadeIn(popup, 0, .5);
			
			stage.addEventListener(MouseEvent.MOUSE_UP, handleStageMouseUp);
			
			invalidate();
		}

		
		private function handleStageMouseUp(event:MouseEvent):void 
		{
			if(!popup.hitTestPoint(stage.mouseX, stage.mouseY)) {
				hidePopup();
			}
		}

		
		protected function hidePopup():void 
		{	trace('hide popup');
			stage.removeEventListener(MouseEvent.MOUSE_UP, handleStageMouseUp);
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

		
		override public function get width():Number {
			return super.actualWidth;
		}

		
		override public function get height():Number {
			return super.actualHeight;
		}
		
		
		public function get showTime():Boolean {
			return _showTime;
		}
		
		
		public function set showTime(showTime:Boolean):void {
			_showTime = showTime;
			invalidate();
		}
	}
}