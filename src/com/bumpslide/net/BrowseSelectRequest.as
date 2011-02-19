package com.bumpslide.net
{

	import flash.events.Event;
	import flash.net.FileReference;


	/**
	 * Wraps a File Browse operation
	 *
	 * @author David Knape
	 */
	public class BrowseSelectRequest extends AbstractRequest
	{

		public var fileReference:FileReference;
		public var typeFilter:Array;

		public function BrowseSelectRequest( file_reference:FileReference, type_filter:Array = null,  responder:IResponder = null )
		{
			super( responder);
			fileReference = file_reference;
			typeFilter = type_filter;
			retryCount = 1;
 		}


		override protected function initRequest():void
		{
			fileReference.addEventListener( Event.SELECT, handleSelect );
			fileReference.addEventListener( Event.CANCEL, handleCancel );
			fileReference.browse( typeFilter );
		}


		private function handleCancel( event:Event ):void
		{
			cancel();
		}


		private function handleSelect( event:Event ):void
		{
			finishCompletedRequest( fileReference );
		}
		
		override protected function killRequest():void
		{
			fileReference.removeEventListener( Event.CANCEL, handleCancel );
			try { fileReference.cancel(); } catch (e:Error) {}
		}


	}
}
