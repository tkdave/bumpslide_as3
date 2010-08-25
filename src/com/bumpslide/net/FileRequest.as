package com.bumpslide.net {

	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;

	/**
	 * Reads raw bytes from the file system in an AIR application
	 *
	 * @author David Knape
	 */
	public class FileRequest extends AbstractRequest {

		public var file:File;
		private var _stream:FileStream;
		private var _bytes:ByteArray;

		public function FileRequest(file:File, responder:IResponder = null) {
			this.file = file;
		}

		override protected function initRequest() : void {
			_stream = new FileStream();
			_stream.openAsync(file, FileMode.READ);
			_stream.addEventListener(Event.COMPLETE, handleFileReadComplete);
			_stream.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
		}

		override protected function killRequest() : void {
			_stream.removeEventListener(Event.COMPLETE, handleFileReadComplete);
			_stream.removeEventListener(IOErrorEvent.IO_ERROR, handleIOError);
			try {
				_stream.close();
			} catch (error:Error) {
			}
		}

		protected function handleFileReadComplete(event:Event) : void {
			var bytes:ByteArray = new ByteArray();
			_stream.readBytes(bytes, 0, _stream.bytesAvailable);
			finishCompletedRequest(bytes);
		}

		protected function handleIOError(event:IOErrorEvent) : void {
			raiseError(new IOError(event.text));
		}
	}
}
