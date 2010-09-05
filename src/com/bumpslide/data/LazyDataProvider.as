/**
 * This code is part of the Bumpslide Library maintained by David Knape
 * Fork me at http://github.com/tkdave/bumpslide_as3
 * 
 * Copyright (c) 2010 by Bumpslide, Inc. 
 * http://www.bumpslide.com/
 *
 * This code is released under the open-source MIT license.
 * See LICENSE.txt for full license terms.
 * More info at http://www.opensource.org/licenses/mit-license.php
 */

package com.bumpslide.data 
{
	import flash.utils.Dictionary;

	import com.bumpslide.net.IRequest;

	import fl.data.DataProvider;

	/**
	 * LazyDataProvider
	 *
	 * @author David Knape
	 * @version SVN: $Id: $
	 */
	public class LazyDataProvider extends DataProvider 
	{

		private var _pageSize:int;
		private var _lazyItemProvider:ILazyItemProvider;

		// number of items to preload
		public var prefetch:int = 10;		
		private var loading:Boolean;
		
		protected var receivedPages:Array = new Array();
		protected var requestedPages:Array = new Array();
		protected var requestsWaiting:Array = new Array();
		protected var itemsPending:Dictionary = new Dictionary();		
		protected var requestsPending:Dictionary = new Dictionary();
		
		protected var countRequested:Boolean = false;
		protected var countReceived:Boolean = false;


		
		public function LazyDataProvider(lazyItemProvider:ILazyItemProvider, pageSize:int = 100) 
		{
			super();
			_pageSize = pageSize;
			_lazyItemProvider = lazyItemProvider;			
			
			// request total item count
			countRequested = true;
			loading = true;
			_lazyItemProvider.getTotal().addResponder(new Callback(handleResult_getTotal, null));		
		}

		
		protected function handleResult_getTotal( total:int ):void 
		{
			trace('[LazyDataProvider] total = ' + total );
			data = new Array(total);
			receivedPages = new Array();
			countReceived = true;
			loading = false;
			
			invalidate();
			
			// request any pages that were waiting for totals to be receieved
			while( requestsWaiting.length ) {
				doRequest(requestsWaiting.shift());
			}
		}

		
		public override function getItemAt(index:uint ):Object 
		{
			return getItemAndPrefetchAt(index);
		}

		
		protected function getItemAndPrefetchAt( index:uint, do_prefetch:Boolean = true ):Object 
		{
			
			var page_num:int = Math.floor(index / this._pageSize);			
			var item:* = null;
			
			//If the item is in an already available page then return it
			if(pageAvailable(page_num)) {
				item = super.getItemAt(index);
			} else {
				// request the page if it has not been requested
				if(!pageBeingRequested(page_num) ) {
					requestPage(page_num);
				}
				
				// Now, what to do here?
				
				// old mx Lists are looking for ItemPending errors, but that seems messy to me.
				
				// We could have the lazyItemProvider provide a stub/loading VO
				
//				item = lazyItemProvider.getLoadingValue(); // returns a properly typed VO with null properties and proper label
				
				// or, we could just return null
				// or, we could do what the old firefly/AMF AS2 recordset did and return the string "in progress"
				
//				item = "in progress";

				// let's just return null for now
				item = null;
			}
			
			if(do_prefetch) {
				try {
					getItemAndPrefetchAt(index + prefetch, false);
				} catch (e:RangeError) {
					// catch out of bounds errors
				}
			}
			return item;
		}

		
		public function unload():void 
		{
			for each ( var req:IRequest in requestsPending) {
				req.cancel();
			}		
			removeAll();
			receivedPages = new Array();
			requestedPages = new Array();
			itemsPending = new Dictionary();
			requestsWaiting = new Array();
			requestsPending = new Dictionary();
		}

		
		protected function requestPage( page_num:int ):void 
		{		
			requestedPages[page_num] = true;
			if(!countReceived) {
				requestsWaiting.push(page_num);
			} else {
				doRequest(page_num);
			}
		}

		
		protected function doRequest( page_num:int ):void 
		{
			loading = true;
			trace('[LazyArrayCollection] requesting page # ' + page_num );
			var req:IRequest = lazyItemProvider.getItems(page_num * pageSize, pageSize);
			req.addResponder(new Callback(getItemsResultHandler, null, page_num));
			requestsPending[page_num] = req;
		}
		
		/**
		 * Receives page result from the lazy item provider
		 * 
		 * @param resultList IList or array
		 * @param page_num int
		 */
		private function getItemsResultHandler(resultList:*, page_num:int):void 
		{			
			var result:Array = getDataFromObject( resultList );
			var startIndex:int = (page_num) * _pageSize ;
			
			// add the page to the received pages cache
			receivedPages[ page_num ] = result;
			
			// add the data to the underlying list
			for(var i:int = 0 ;i != result.length;i++) {
				
				try {					
					super.replaceItemAt(result[i], (i + startIndex));
				} catch (e:RangeError) {
					// looks like we tried to add something at an invalid index
					// it's possible that our remote record set has new items that
					// weren't around when we got a total
					if(i + startIndex > length) {
						addItem(result[i]);
					}
				}
			}
			
			//Update any responders on the ItemPendingError
			//updateResponders(result, page_num);
			
			//Clear the ItemPendingError for this page
			itemsPending[page_num] = null;
			delete itemsPending[page_num];
			requestsPending[page_num] = null;
			delete requestsPending[page_num];
			
			loading = false;
			
			for each (var req:IRequest in requestsPending) {
				if(req != null) loading = true;
			}
			
		}

		
//		private function updateResponders( result:Object, page_num:int ):void 
//		{
//			
//			/*
//			 * We throw ItemPendingErrors per RPC request,
//			 * so as we make RPC requests per page,
//			 * get the ItemPendingError for this page
//			 */
//			var itemPendingError:ItemPendingError = getItemPendingError(page_num);
//			var responders:Array = itemPendingError.responders;
//			if(responders)
//			for( var j:int = 0;j != responders.length;j++) {
//				var responder:IResponder = responders[ j ] as IResponder;
//				responder.result(new ResultEvent(ResultEvent.RESULT, false, true, result));
//			}
//		}

		
		private function pageBeingRequested( page:int ):Boolean 
		{
			return requestedPages[ page ] as Boolean ;
		}

		
		private function pageAvailable( page:int ):Boolean 
		{
			return receivedPages[ page ] != null ;
		}

		
		//		private function getItemPendingError( page : int ) : ItemPendingError {
		//			if( itemsPending[ page ] == null ){
		//				itemsPending[ page ] = createItemPendingError() ;
		//			}
		//			return itemsPending[ page ] as ItemPendingError ;
		//		}
		
		//		private function createItemPendingError() : ItemPendingError {
		//			return new ItemPendingError("Order pending");
		//		}
		public function get lazyItemProvider():ILazyItemProvider {
			return _lazyItemProvider;
		}

		
		public function get pageSize():uint {
			return _pageSize;
		}

		
		public function get _countRequested():Boolean {
			return countRequested;
		}

		
		public function set _countRequested(countRequested:Boolean):void {
			this.countRequested = countRequested;
		}
	}
}
