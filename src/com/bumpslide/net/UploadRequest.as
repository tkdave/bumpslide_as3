package com.bumpslide.net 
{
	import flash.events.Event;
	import flash.events.DataEvent;
	import flash.net.FileReference;
	import flash.net.URLRequest;

	[Event(name='open',type='flash.events.Event')]	[Event(name='uploadCompleteData',type='flash.events.DataEvent')]

	/**
	 * File Upload Request
	 * 
	 * @author David Knape
	 */
	public class UploadRequest extends HTTPRequest 
	{
		
		protected var _fileReference:FileReference;
		protected var _uploadDataFieldName:String = "FileData";
		protected var _testUpload:Boolean = false;
		
		public function UploadRequest( file_reference:FileReference=null, url_request:URLRequest=null, responder:IResponder=null )
		{
			timeout = 999999; 
			_fileReference = file_reference;
			super( url_request, responder );			
		}

		
		/**
		 * Creates the URLLoader, starts listening to URLLoader events, and loads the URLRequest
		 */	
		override protected function initRequest():void {			
			addLoaderEventListeners( _fileReference);			
			_fileReference.addEventListener(Event.OPEN, handleOpenEvent, false, 0, true  );
			_fileReference.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, handleUploadCompleteData, false, 0, true);
			_fileReference.upload( urlRequest, uploadDataFieldName, testUpload);
		}
		
		/**
		 * Override complete event handler, since we want to wait for DataEvent.UPLOAD_COMPLETE_DATA
		 */
		override protected function handleCompleteEvent(event:Event):void 
		{
			
			//finishCompletedRequest( event.target.data );
		}		
		
		/**
		 * Handle data returned by server
		 */
		private function handleUploadCompleteData(event:DataEvent):void
		{
			finishCompletedRequest( event.data );
			
			// relay the data complete event
			dispatchEvent( event );
		}
		
		/**
		 * Relay Open events
		 */
		protected function handleOpenEvent(event:Event):void
		{
			dispatchEvent( event );
		}

		
		/**
		 * closes the URLLoader and stops listening to URLLoader events
		 */
		override protected function killRequest():void {			
			removeLoaderEventListeners( _fileReference );
			_fileReference.removeEventListener(Event.OPEN, handleOpenEvent);			_fileReference.removeEventListener(DataEvent.UPLOAD_COMPLETE_DATA, handleUploadCompleteData);
			try { 
				_fileReference.cancel();
				//_urlLoader.close(); 
			} catch (e:Error) {
			}	
		}		
		
		public function get fileReference():FileReference {
			return _fileReference;
		}
		
		
		public function set fileReference(fileReference:FileReference):void {
			_fileReference = fileReference;
		}
		
		
		public function get uploadDataFieldName():String {
			return _uploadDataFieldName;
		}
		
		
		public function set uploadDataFieldName(uploadDataFieldName:String):void {
			_uploadDataFieldName = uploadDataFieldName;
		}
		
		
		public function get testUpload():Boolean {
			return _testUpload;
		}
		
		
		public function set testUpload(testUpload:Boolean):void {
			_testUpload = testUpload;
		}
	}
}
