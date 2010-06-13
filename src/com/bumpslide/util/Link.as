package com.bumpslide.util {
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;	

	/**
	 * Attempts to avoid popup blockers when opening links
	 */
	public class Link {

		public static const BROWSER_FIREFOX:String = "firefox";		public static const BROWSER_SAFARI:String = "safari";		public static const BROWSER_IE:String = "ie";		public static const BROWSER_OPERA:String = "opera";		public static const BROWSER_UNKNOWN:String = "unknown";
		protected static const WINDOW_OPEN_FUNCTION:String = "window.open";

		/**
		 * Open a new browser window and prevent browser from blocking it.
		 *
		 * @param url        url to be opened
		 * @param window     window target
		 * @param features   additional features for window.open function
		 */
		public static function open(url:String, window:String = "", features:String = ""):void {
			var browserName:String = getBrowserName();			     
			switch( browserName ) {
				case BROWSER_FIREFOX:
					ExternalInterface.call(WINDOW_OPEN_FUNCTION, url, window, features);
					break;
				case BROWSER_IE:
					ExternalInterface.call("function setWMWindow() {window.open('" + url + "');}");
					break;
				default:
					navigateToURL(new URLRequest(url), window);
			}
		}
		
		/**
		 * Link to a page in the same window
		 */
		public static function to(url:String) : void {
			navigateToURL(new URLRequest(url), '_self');
		}

		/**
		 * return current browser name
		 */
		private static function getBrowserName():String {
			var browser:String = "unknown";
           
			if (ExternalInterface.available) {
				var browserAgent:String = ExternalInterface.call("function getBrowser(){return navigator.userAgent;}");
			}           
           
			if(browserAgent != null) {
				if(browserAgent.indexOf("Firefox") >= 0) {
					browser = BROWSER_FIREFOX;
				} else if(browserAgent.indexOf("Safari") >= 0) {
					browser = BROWSER_SAFARI;
				} else if(browserAgent.indexOf("MSIE") >= 0) {
					browser = BROWSER_IE;
				} else if(browserAgent.indexOf("Opera") >= 0) {
					browser = BROWSER_OPERA;
				} else {
					browser = BROWSER_UNKNOWN;
				}
			}      
			return browser;			
		}
		
		public static const BOOKMARK_DELICIOUS:uint = 0;
		public static const BOOKMARK_FACEBOOK:uint = 1;		public static const BOOKMARK_DIGG:uint = 2;		public static const BOOKMARK_REDDIT:uint = 3;		public static const BOOKMARK_STUMBLEUPON:uint = 4;
				
		public static function bookmarkThis( url:String, title:String="", type:uint=BOOKMARK_DELICIOUS ) : void {
			Link.to( getBookmarkURL(url, title, type) );
		}
				
		public static function getBookmarkURL( url:String, title:String="", type:uint=BOOKMARK_DELICIOUS) : String {
			switch (type) {
				case BOOKMARK_FACEBOOK:
					return 'http://www.facebook.com/sharer.php?u='+escape(url)+'&t='+escape(title);
				case BOOKMARK_STUMBLEUPON:
					return 'http://www.stumbleupon.com/submit?url='+escape(url)+'&title='+escape(title);
				case BOOKMARK_REDDIT:
					return 'http:/reddit.com/submit?url='+escape(url)+'&title='+escape(title);
				case BOOKMARK_DIGG:
					return 'http://digg.com/submit?phase=2&url='+escape(url)+'&title='+escape(title);
				default:
					return 'http://delicious.com/save?url='+escape(url)+'&title='+escape(title);
			}
			
		}
	}
}
