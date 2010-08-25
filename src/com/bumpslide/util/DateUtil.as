package com.bumpslide.util 
{
	import com.bumpslide.data.constant.Unit;

	/**
	 * Utilities for dealing with Dates
	 *  
	 * @author David Knape
	 */
	public class DateUtil 
	{
		public static var MONTH_NAMES:Array = new Array("January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December");
		public static var MONTH_ABBREV:Array = new Array("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec");
		public static var MONTH_LETTERS:Array = new Array("J","F","M","A","M","J","J","A","S","O","N","D");
		
		public static var DAY_NAMES:Array = new Array("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday");
		public static var DAY_ABBREV:Array = new Array("Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat");
		public static var DAY_LETTERS:Array = new Array("S", "M", "T", "W", "T", "F", "S");
		
		public static var DAYS_PER_MONTH:Array = new Array(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31, 29);

		/**
		 * Parses W3CDTF Time stamps 
		 * 
		 * Modified from adobe as3corelib: 
		 * - david added option to ignore timezone
		 */ 
		public static function parseW3CDTF(str:String, ignoreTimezone:Boolean = false):Date 
		{
			var finalDate:Date;
			try {
				var dateStr:String = str.substring(0, str.indexOf("T"));
				var timeStr:String = str.substring(str.indexOf("T") + 1, str.length);
				var dateArr:Array = dateStr.split("-");
				var year:Number = Number(dateArr.shift());
				var month:Number = Number(dateArr.shift());
				var date:Number = Number(dateArr.shift());
				
				var multiplier:Number;
				var offsetHours:Number;
				var offsetMinutes:Number;
				var offsetStr:String;
				
				if (timeStr.indexOf("Z") != -1 || ignoreTimezone) {
					multiplier = 1;
					offsetHours = 0;
					offsetMinutes = 0;
					timeStr = timeStr.replace("Z", "");
				} else if (timeStr.indexOf("+") != -1) {
					multiplier = 1;
					offsetStr = timeStr.substring(timeStr.indexOf("+") + 1, timeStr.length);
					offsetHours = Number(offsetStr.substring(0, offsetStr.indexOf(":")));
					offsetMinutes = Number(offsetStr.substring(offsetStr.indexOf(":") + 1, offsetStr.length));
					timeStr = timeStr.substring(0, timeStr.indexOf("+"));
				} else { 
					// offset is -
					multiplier = -1;
					offsetStr = timeStr.substring(timeStr.indexOf("-") + 1, timeStr.length);
					offsetHours = Number(offsetStr.substring(0, offsetStr.indexOf(":")));
					offsetMinutes = Number(offsetStr.substring(offsetStr.indexOf(":") + 1, offsetStr.length));
					timeStr = timeStr.substring(0, timeStr.indexOf("-"));
				}
				var timeArr:Array = timeStr.split(":");
				var hour:Number = Number(timeArr.shift());
				var minutes:Number = Number(timeArr.shift());
				var secondsArr:Array = (timeArr.length > 0) ? String(timeArr.shift()).split(".") : null;
				var seconds:Number = (secondsArr != null && secondsArr.length > 0) ? Number(secondsArr.shift()) : 0;
				var milliseconds:Number = (secondsArr != null && secondsArr.length > 0) ? Number(secondsArr.shift()) : 0;
				
				if(ignoreTimezone) {
					finalDate = new Date(year, month - 1, date, hour, minutes, seconds, milliseconds);
				} else {
					var utc:Number = Date.UTC(year, month - 1, date, hour, minutes, seconds, milliseconds);
					var offset:Number = (((offsetHours * 3600000) + (offsetMinutes * 60000)) * multiplier);
					finalDate = new Date(utc - offset);
				}
				if (finalDate.toString() == "Invalid Date") {
					throw new Error("This date does not conform to W3CDTF.");
				}
			} catch (e:Error) {
				var eStr:String = "Unable to parse the string [" + str + "] into a date. ";
				eStr += "The internal error was: " + e.toString();
				trace('[DateUtil] ' + eStr);
				//throw new Error(eStr);
			}
			return finalDate;
		} 

		
		/**
		 * Basic date formatting function 
		 * 
		 * showDate( d ); // == "Saturday, September 15, 2008 9:00pm"
		 * showDate( d, false, false, false); // == "September 2009"
		 */
		static public function getFormatted( d:Date, showTime:Boolean = true, showDate:Boolean = true, showWeekday:Boolean = true, showMonth:Boolean = true, showYear:Boolean = true ):String 
		{
			if(d==null) return "";
			// "Saturday, September 15, 2008 9:00pm"
			var s:String = "";			
			if(showWeekday) s += DAY_NAMES[d.day] + ", ";
			if(showMonth) s += MONTH_NAMES[d.month] + " ";
			if(showDate) s += d.date + ", ";
			if(showYear) s += d.fullYear;			
			if(showTime) s += " " + getShortHour(d) + ":" + (d.minutes < 10 ? "0" : "") + d.minutes + getAMPM(d).toLowerCase();
			return s;
		}

		
		/**
		 *	Returns a short hour (0 - 12) represented by the specified date.
		 */	
		public static function getShortHour(d:Date):int 
		{
			if(d==null) return 0;
			var h:int = d.hours;			
			if(h == 0 || h == 12) {
				return 12;
			} else if(h > 12) {
				return h - 12;
			} else {
				return h;
			}
		}

		
		/**
		 *	Returns AM or PM for a given date/time;
		 */	
		public static function getAMPM(d:Date):String 
		{
			if(d==null) return '';
			return (d.hours > 11) ? "PM" : "AM";
		}   

		
		/**
		 * Returns the number of days in a month
		 */
		public static function getLastDayOfMonth(monthIndex:Number, year:Number):Number 
		{	
			if ((isLeapYear(year)) && (monthIndex == 1)) {
				return 29;
			} else {
				return DAYS_PER_MONTH[monthIndex];
			}
		}

		
		/**
		 * Determines whether or not a year is a leap year
		 */
		public static function isLeapYear(y:Number):Boolean 
		{
			var ret:Boolean;

			if ((y % 100 == 0) && ( y % 400 != 0)) {
				ret = false;
			}  else if (y % 4 == 0) {
				ret = true;
			} else {
				ret = false;
			}
			return ret;
		};

		
		/**
		 * Round a date down to the nearest whole unit
		 */
		static public function roundDown( d:Date, unit:String ):void 
		{
			
			switch( unit ) {
				
				case Unit.SECOND:
					d.milliseconds = 0;
					break;
					
				case Unit.MINUTE:
					d.milliseconds = 0;
					d.seconds = 0;
					break;
								
				case Unit.HOUR:
					d.milliseconds = 0;
					d.seconds = 0;
					d.minutes = 0;
					break;
					
				case Unit.DAY:
					d.milliseconds = 0;
					d.seconds = 0;
					d.minutes = 0;
					d.hours = 0;
					break;
					
				case Unit.MONTH:
					d.milliseconds = 0;
					d.seconds = 0;
					d.minutes = 0;
					d.hours = 0;
					d.date = 1;
					break;
					
				case Unit.YEAR:
					d.milliseconds = 0;
					d.seconds = 0;
					d.minutes = 0;
					d.hours = 0;
					d.date = 1;
					d.month = 0;
					break;
				
				case Unit.DECADE:
					d.milliseconds = 0;
					d.seconds = 0;
					d.minutes = 0;
					d.hours = 0;
					d.date = 1;
					d.month = 0;
					d.fullYear = Math.floor(d.fullYear / 10) * 10; 
					break;
				
				case Unit.CENTURY:
					d.minutes = 0;
					d.hours = 0;
					d.date = 1;
					d.month = 0;
					d.fullYear = Math.floor(d.fullYear / 100) * 100; 
					break;
			}
		}

		
		/**
		 * Round a date up to the nearest whole unit
		 */
		static public function roundUp( d:Date, unit:String ):void 
		{
			
			switch( unit ) {
			
				case Unit.SECOND:
					d.milliseconds = 0;
					d.seconds += 1;
					break;
					
				case Unit.MINUTE:
					d.milliseconds = 0;
					d.seconds = 0;
					d.minutes += 1;
					break;
								
				case Unit.HOUR:
					d.milliseconds = 0;
					d.seconds = 0;
					d.minutes = 0;
					d.hours += 1;
					break;
					
				case Unit.DAY:
					d.milliseconds = 0;
					d.seconds = 0;
					d.minutes = 0;
					d.hours = 0;
					d.date += 1;
					break;
					
				case Unit.MONTH:
					d.milliseconds = 0;
					d.seconds = 0;
					d.minutes = 0;
					d.hours = 0;
					d.date = 1;
					d.month += 1;
					break;
					
				case Unit.YEAR:
					d.milliseconds = 0;
					d.seconds = 0;
					d.minutes = 0;
					d.hours = 0;
					d.date = 1;
					d.month = 0;
					d.fullYear += 1;
					break;
				
				case Unit.DECADE:
					d.milliseconds = 0;
					d.seconds = 0;
					d.minutes = 0;
					d.hours = 0;
					d.date = 1;
					d.month = 0;
					d.fullYear = Math.round(1 + (d.fullYear / 10)) * 10;
					break;
				
				case Unit.CENTURY:
					d.milliseconds = 0;
					d.seconds = 0;
					d.minutes = 0;
					d.hours = 0;
					d.date = 1;
					d.month = 0;
					d.fullYear = Math.round(1 + (d.fullYear / 100)) * 100;
					break;
			}
		}  
		
		static public function advanceByUnit( d:Date, unit:String ):void {
			
			switch( unit ) {					
				case Unit.MILLISECOND:
					d.milliseconds += 1;
					break;
				case Unit.SECOND:
					d.seconds += 1;
					break;
				case Unit.MINUTE:
					d.minutes += 1;
					break;					
				case Unit.HOUR: 
					d.hours += 1;
					break;
				case Unit.DAY: 
					d.date += 1; 
					break;
				case Unit.MONTH: 
					d.month += 1; 
					break;
				case Unit.YEAR: 
					d.fullYear += 1;
					break;
					
				case Unit.DECADE:
					d.fullYear += 10;
					break;
				
				case Unit.CENTURY:
					d.fullYear += 100;
					break;
				
				default:
					throw new Error('Invalid unit');
			}
		}
		
		static public function advanceBySubUnit( d:Date, unit:String ):void {			
			
			switch( unit ) {
				case Unit.SECOND:  
					d.milliseconds += 100; 
					break;
				case Unit.MINUTE:  
					d.seconds += 15; 
					break;
				case Unit.HOUR:    
					d.minutes += 15; 
					break;
				case Unit.DAY:     
					d.hours += 1; 
					break;
				case Unit.MONTH:   
					d.date += 1; 
					break;
				case Unit.YEAR:    
					d.month += 1; 
					break;
				case Unit.DECADE:    
					d.fullYear += 1; 
					break;							
				case Unit.CENTURY:    
					d.fullYear += 10; 
					break;		
				default:  
					throw new Error('Invalid Unit');
					break;	
			}
		}
	}
}
