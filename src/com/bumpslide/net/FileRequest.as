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
			super(responder);
		}

		override protected function initRequest() : void {
			_stream = new FileStream();
			debug('Opening File Stream ' + file );
			_stream.addEventListener(Event.COMPLETE, handleFileReadComplete);
			_stream.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
			_stream.openAsync(file, FileMode.READ);
		}

		override protected function killRequest() : void {
			_stream.removeEventListener(Event.COMPLETE, handleFileReadComplete);
			_stream.removeEventListener(IOErrorEvent.IO_ERROR, handleIOError);
			try {
				debug('Closing File Stream ' + file );
				_stream.close();
			} catch (error:Error) {
			}
		}

		protected function handleFileReadComplete(event:Event) : void {
			debug('File Read Complete ('+ _stream.bytesAvailable+' bytes available)');
			var bytes:ByteArray = new ByteArray();
			_stream.readBytes(bytes, 0, _stream.bytesAvailable);
			finishCompletedRequest(bytes);
		}

		protected function handleIOError(event:IOErrorEvent) : void {
			debug('IOError opening file ' + file );
			raiseError(new IOError(event.text));
		}
	}
}
