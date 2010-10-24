package unit
{

	import com.bumpslide.data.Callback;
	import com.bumpslide.net.HTTPRequest;

	import org.flexunit.asserts.assertTrue;
	import org.flexunit.asserts.fail;
	import org.flexunit.async.Async;

	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;

	/**
	 * @author David Knape
	 */
	public class TestHTTPRequest extends EventDispatcher
	{

		protected var req:HTTPRequest;

		private static const TEST_URL:String = "http://google.com/";

		private static const TIMEOUT:int = 10000;

		[Test(async)]
		public function testListeningForCompleteEvent():void
		{
			req = new HTTPRequest( new URLRequest( TEST_URL ) );
			Async.proceedOnEvent( this, req, Event.COMPLETE, TIMEOUT );
			req.load();
		}


		[Test(async)]
		public function testUsingCallbackWithPassthruData():void
		{
			req = new HTTPRequest( new URLRequest( TEST_URL ) );
			req.addResponder( new Callback( handleResult, handleUnexpectedError, { data:"Passthru" } ) );
			Async.proceedOnEvent( this, this, 'passthruComplete', TIMEOUT );
			req.load();
		}


		private function handleResult( data:Object, passthru:Object ) : void
		{
			assertTrue( data is String );
			assertTrue( passthru.data == "Passthru" );
			dispatchEvent( new Event( 'passthruComplete' ) );
		}


		private function handleUnexpectedError( error:Error ) : void
		{
			fail( error.message );
		}


		[Test(async)]
		public function testIOError():void
		{
			req = new HTTPRequest( new URLRequest( TEST_URL + "XX" ) );
			req.addResponder( new Callback( null, handleExpectedIOError ) );
			Async.proceedOnEvent( this, this, 'ioErrorComplete', TIMEOUT );
			req.load();
		}


		private function handleExpectedIOError( error:Error ):void
		{
			assertTrue( error is IOError );
			dispatchEvent( new Event( 'ioErrorComplete' ) );
		}
	}
}
