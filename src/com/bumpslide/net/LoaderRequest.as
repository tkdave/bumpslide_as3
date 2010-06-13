package com.bumpslide.net 
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;

	/**
	 * IRequest implementation for Loaders
	 * 
	 * No more need for LoaderQueue.  Just use RequestQueue.
	 * 
	 * This extends HTTPRequest so we can re-use the event listeners, but we are
	 * loading with a Loader instead of a URLLoader
	 * 
	 * @author David Knape
	 */
	public class LoaderRequest extends HTTPRequest implements IRequest
	{		

		protected var _loader:Loader;
		protected var _loaderContext:LoaderContext;

		
		public function LoaderRequest(loader:Loader, content_url:String, loader_context:LoaderContext, responder:IResponder = null)
		{
			_loader = loader;
			_loaderContext = loader_context;
			super(new URLRequest(content_url), responder);
		}

		
		/**
		 * Cancel pending request and unload image
		 * 
		 * (alias for cancel)
		 */
		public function unload():void 
		{			
			cancel();
		}

		
		/**
		 * Cancel pending request and unload image
		 */
		override public function cancel():void
		{
			super.cancel();
			doUnloadContent();
		}

		
		protected function doUnloadContent():void 
		{			
			// unload
			try { 
				loader.unload(); /* trace('unloaded');*/ 
			} catch ( error1:Error ) {
			}    
			try { 
				// in case content is a swf, and we have FP10, unload and stop to be safe
				if(loader['unloadAndStop'] is Function) {
					(loader['unloadAndStop'] as Function).call(loader);
				} 
			} catch (error2:Error) {
			}
		}

		
		/**
		 * starts listening to LoaderInfo events, and starts the load
		 */	
		override protected function initRequest():void 
		{
			debug('loading ' + urlRequest.url);			
			addLoaderEventListeners(loader.contentLoaderInfo);
			loader.load(urlRequest, loaderContext); 
		}

		
		/**
		 * closes the Loader and stops listening to LoaderInfo events
		 * 
		 * does not unload the content 
		 */
		override protected function killRequest():void 
		{		
			removeLoaderEventListeners(loader.contentLoaderInfo);
			try { 
				loader.close(); 
			} catch ( e:Error ) {
			}
		}

		
		override protected function handleCompleteEvent(event:Event):void
		{
			finishCompletedRequest( loader.content );
		}

		
		public function get loader():Loader {
			return _loader;
		}

		
		public function get loaderContext():LoaderContext {
			return _loaderContext;
		}
	}
}
