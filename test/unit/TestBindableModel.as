package unit 
{
	import com.bumpslide.events.ModelChangeEvent;

	import org.flexunit.Assert;
	import org.flexunit.async.Async;

	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	 * @author David Knape
	 */
	public class TestBindableModel extends EventDispatcher
	{
		private var model:TestModel;
		
		
		[Before]
		public function setup():void {
			model = new TestModel();	
		}
		
		[Test(async, description="Test Prop Change Event")]
		public function testArrayPropChange():void {
			model.addEventListener( ModelChangeEvent.PROPERTY_CHANGED, Async.asyncHandler( this, handleArrayPropChange, 1000) );
			model.arrayData = ['Test', 'Data'];
		}

		private function handleArrayPropChange(event:ModelChangeEvent, passthru:*=null):void 
		{
			Assert.assertEquals( model.arrayData.length, 2);
		}
		
		
		[Test(async,description='Test String Binding')]
		public function testStringBinding():void {
			model.bind('stringData', this );
			model.stringData = "hi";
			Async.proceedOnEvent(this, this, 'stringDataBound');
		}
		
		public function set stringData (s:String):void {
			if(s==null) return;
			Assert.assertEquals(s, "hi");
			dispatchEvent( new Event('stringDataBound') );
		}
		
		
		
		[Test(description='Last Test')]
		public function testHello():void {
			model.stringData = "hello";
			Assert.assertNotNull( model.stringData );
		}
		
				
//		private function handleArrayDataChange(arrayData:Array):void 
//		{
//			Assert.assertEquals( arrayData.length, 2 );
//		}
	}
}

import com.bumpslide.data.BindableModel;


class TestModel extends BindableModel {

	public function set arrayData(a:Array):void {
		set('arrayData', a);
	}
	
	public function get arrayData():Array {
		return get('arrayData');
	}
	
	public function set stringData(s:String):void {
		set('stringData', s);
	}
	
	public function get stringData():String {
		return  get('stringData');
	}
	
	
	
}