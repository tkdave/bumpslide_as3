package  
unit{
	import com.bumpslide.net.HTTPRequest;

	import org.flexunit.Assert;
	import org.flexunit.async.Async;

	import flash.events.Event;
	import flash.net.URLRequest;

	/**
	 * @author David Knape
	 */
	public class TestHTTPRequest 
	{
		protected var req:HTTPRequest;

		private static const TEST_URL:String = "http://library.bumpslide.com/LICENSE.txt";

		[Test(async,timeout="10000")]
		public function testSuccessCallback():void 
		{
			
			req = new HTTPRequest(new URLRequest(TEST_URL));
			Async.handleEvent(this, req, Event.COMPLETE, onLoadComplete); 
			req.load();
		}		
		
		private function onLoadComplete(event:Event, passthroughData:*=  null):void
		{
			trace("First Word: ", String(req.result).split(' ')[0] );
			Assert.assertNotNull(req.result);
		}

//		[Test(async,expects="flash.errors.IOError")] 
//		public function testIOError():void 
//		{
//			req = new HTTPRequest(new URLRequest("http://fake.domain/fake.file"));
//			req.load();			
//		}
	}
}
