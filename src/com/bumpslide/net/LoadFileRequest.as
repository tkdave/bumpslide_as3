package com.bumpslide.net
{

	import flash.events.Event;
	import flash.net.FileReference;


	/**
	 * BrowseSelectRequest
	 *
	 * @author David Knape
	 */
	public class LoadFileRequest extends AbstractRequest
	{

		private var fileReference:FileReference;

		public function LoadFileRequest( file_reference:FileReference, responder:IResponder = null )
		{
			super( responder);
			fileReference = file_reference;
			retryCount = 1;
 		}


		override protected function initRequest():void
		{
			fileReference.addEventListener( Event.COMPLETE, handleLoadComplete );
			fileReference.load();
		}


		private function handleLoadComplete( event:Event ):void
		{
			finishCompletedRequest( fileReference.data );
		}

		
		override protected function killRequest():void
		{
			try { fileReference.cancel(); } catch (e:Error) {}
		}


	}
}
