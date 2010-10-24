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
	import com.bumpslide.data.Callback;
	import com.bumpslide.net.IRequest;
	
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	import mx.collections.IList;
	import mx.collections.errors.ItemPendingError;
	import mx.events.CollectionEvent;
	import mx.events.PropertyChangeEvent;
	import mx.events.PropertyChangeEventKind;
	import mx.rpc.IResponder;
	import mx.rpc.events.ResultEvent;
	
	/**
	 * Lazy Loaded ArrayCollection
	 * 
	 * This class is designed to provide a paged loading mechanism built on top of 
	 * ArrayCollection. 
	 * 
	 * Parts of this code came from some blog that is no longer live.  This
	 * functionality might be built into Flex 4 when it's released, of course, 
	 * Adobe might decide to make it part of LCDS which is not free or open source.
	 * 
	 * @author David Knape
	 */
	public class LazyArrayCollection extends ArrayCollection
	{
		private var _pageSize:int = 20;
		private var _lazyItemProvider:ILazyItemProvider;
		private var _total:uint = 0;
		
		private var receivedPages:Array = new Array();
		private var requestedPages:Array = new Array();
		private var itemsPending:Dictionary = new Dictionary();
		private var requestsWaiting:Array = new Array();
		private var requestsPending:Dictionary = new Dictionary();
		
		private var countRequested:Boolean = false;
		private var countReceived:Boolean = false;
		
		[Bindable]
		public var loading:Boolean = false;
		
		public function LazyArrayCollection(lazyItemProvider:ILazyItemProvider, pageSize:int = 30)
		{
			super();
			_pageSize = pageSize;
			_lazyItemProvider = lazyItemProvider;			
			
			// request total item count
			countRequested = true;
			loading = true;
			_lazyItemProvider.getTotal().addResponder( new Callback(getTotalResultHandler, null) );			
		}
		
		public override function getItemAt(index:int, prefetch:int = 10 ) : Object 
		{
			var page_num : int = Math.floor( index/this._pageSize );
			
			var item:* = null;
			
			//If the item is in an already available page then return it
			if(pageAvailable(page_num)){
				item = super.getItemAt(index);
			} else {
				if(! pageBeingRequested( page_num ) ) {
					requestPage( page_num );
				}
				// old mx Lists are looking for these ItemPending errors, 
				// but the spark lists are not.  be sure to check for null.				
				//throw getItemPendingError( page_num );
			}
			
			// making prefetch 10 by default and using prefetch as 
			// indicator that we are prefetching (prevent endless loop)
			if(prefetch!=0) {
				try {
					getItemAt( index + prefetch, 0 );
				} catch (e:RangeError) {
					// catch out of bounds errors
				}
			}
			return item;
		}
		
		
		public function unload(): void {
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
		
		protected function requestPage( page_num:int ) : void {		
			requestedPages[page_num] = true;
			if(!countReceived) {
				requestsWaiting.push( page_num );
			} else {
				doRequest( page_num );
			}
		}
		
		protected function doRequest( page_num:int ) : void {
			loading = true;
			//trace('[LazyArrayCollection] requesting page # ' + page_num );
			var req:IRequest = lazyItemProvider.getItems( page_num * pageSize, pageSize );
			req.addResponder( new Callback( getItemsResultHandler, null, page_num ) );
			requestsPending[page_num] = req;
		}
		
		private function getTotalResultHandler( total:int ) : void {
			//trace('[LazyArrayCollection] total = ' + total );
			source = new Array( total );
			receivedPages = new Array();
			countReceived = true;
			loading = false;
			
			dispatchEvent( new CollectionEvent( CollectionEvent.COLLECTION_CHANGE ) );
			
			// request any pages that were waiting for totals to be receieved
			while( requestsWaiting.length ) {
				doRequest( requestsWaiting.shift() );
			}
		}
		
		/**
		 * Receives page result from the lazy item provider
		 * 
		 * @param resultList IList or array
		 * @param page_num int
		 */
		private function getItemsResultHandler(resultList:*, page_num:int) : void {
			
			var result:IList = (resultList is IList) ? resultList : new ArrayList( resultList );
			var startIndex:int = (page_num) * _pageSize ;
			
			// add the page to the received pages cache
			receivedPages[ page_num ] = result;
			
			// add the data to the underlying list
			for(var i:int = 0 ; i!=result.length; i++){
				
				try {
					super.setItemAt( result.getItemAt( i ), (i + startIndex) );
				} catch (e:RangeError) {
					// looks like we tried to add something at an invalid index
					// it's possible that our remote record set has new items that
					// weren't around when we got a total
					if(i+startIndex>length) {
						addItem( result.getItemAt( i ) );
					}
				}
			}
			
			//Update any responders on the ItemPendingError
			updateResponders( result, page_num );
			
			//Clear the ItemPendingError for this page
			
			itemsPending[page_num] = null;
			delete itemsPending[page_num];
			requestsPending[page_num] = null;
			delete requestsPending[page_num];
			
			loading = false;
			
			for each (var req:IRequest in requestsPending) {
				if(req!=null) loading = true;
			}
			
		}
		
		private function updateResponders( result:Object, page_num : int ) : void {
			
			/*
			* We throw ItemPendingErrors per RPC request,
			* so as we make RPC requests per page,
			* get the ItemPendingError for this page
			*/
			
			// David's note: Are you kidding me?  The error is the callback?
			// I safely ignore all this nonsense now, and I believe this 
			// is no longer relevant to either Spark or Bumpslide list rendering engines
			var itemPendingError : ItemPendingError = getItemPendingError( page_num );
			var responders : Array = itemPendingError.responders;
			if(responders)
			for( var j : int = 0; j!=responders.length; j++){
				var responder:IResponder = responders[ j ] as IResponder;
				responder.result( new ResultEvent( ResultEvent.RESULT, false, true, result ) );
			}
		}
		
		private function pageBeingRequested( page : int ) : Boolean {
			return requestedPages[ page ] as Boolean ;
		}
		
		private function pageAvailable( page : int ) : Boolean {
			return receivedPages[ page ] != null ;
		}
		
		private function getItemPendingError( page : int ) : ItemPendingError {
			if( itemsPending[ page ] == null ){
				itemsPending[ page ] = createItemPendingError() ;
			}
			return itemsPending[ page ] as ItemPendingError ;
		}
		
		private function createItemPendingError() : ItemPendingError {
			return new ItemPendingError("Order pending");
		}
		
		public function get lazyItemProvider () : ILazyItemProvider {
			return _lazyItemProvider;
		}
		
		public function get pageSize() : uint {
			return _pageSize;
		}
		
	}
}