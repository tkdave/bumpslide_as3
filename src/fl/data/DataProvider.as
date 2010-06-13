// Copyright 2007. Adobe Systems Incorporated. All Rights Reserved.
package fl.data {

	import flash.events.EventDispatcher;
	import fl.events.DataChangeEvent;
	import fl.events.DataChangeType;
	import RangeError;


    //--------------------------------------
    //  Events
    //--------------------------------------
	/**
	 * Dispatched before the data is changed.
	 *
     * @see #event:dataChange dataChange event
     *
     * @eventType fl.events.DataChangeEvent.PRE_DATA_CHANGE
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
	 */
	[Event(name="preDataChange", type="fl.events.DataChangeEvent")]

	/**
	 * Dispatched after the data is changed.
     *
     * @see #event:preDataChange preDataChange event
	 *
     * @eventType fl.events.DataChangeEvent.DATA_CHANGE
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
	 */
	[Event(name="dataChange", type="fl.events.DataChangeEvent")]


    //--------------------------------------
    //  Class description
    //--------------------------------------

	/**
	 * The DataProvider class provides methods and properties that allow you to query and modify
	 * the data in any list-based component--for example, in a List, DataGrid, TileList, or ComboBox
	 * component.
	 *
	 * <p>A <em>data provider</em> is a linear collection of items that serve as a data source--for 
	 * example, an array. Each item in a data provider is an object or XML object that contains one or 
	 * more fields of data. You can access the items that are contained in a data provider by index, by 
	 * using the <code>DataProvider.getItemAt()</code> method.</p>
     *
     * @includeExample examples/DataProviderExample.as
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0 
	 */
	public class DataProvider extends EventDispatcher {
        /**
         * @private (protected)
		 *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected var data:Array;


		/**
		 * Creates a new DataProvider object using a list, XML instance or an array of data objects
		 * as the data source. 
		 * 
         * @param data The data that is used to create the DataProvider.
         *
         * @includeExample examples/DataProvider.constructor.1.as -noswf
         * @includeExample examples/DataProvider.constructor.2.as -noswf
         * @includeExample examples/DataProvider.constructor.3.as -noswf
         * @includeExample examples/DataProvider.constructor.4.as -noswf
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		public function DataProvider(value:Object=null) {			
			if (value == null) {
				data = [];
			} else {
				data = getDataFromObject(value);				
			}
		}

		/**
         * The number of items that the data provider contains.
         *
         * @includeExample examples/DataProvider.length.1.as -noswf
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		public function get length():uint {
			return data.length;
		}

		/**
		 * Invalidates the item at the specified index. An item is invalidated after it is
		 * changed; the DataProvider automatically redraws the invalidated item. 
		 *
		 * @param index Index of the item to be invalidated.
         *
         * @throws RangeError The specified index is less than 0 or greater than 
         *         or equal to the length of the data provider.
         *
         * @see #invalidate()
         * @see #invalidateItem()
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		public function invalidateItemAt(index:int):void {
			checkIndex(index,data.length-1)
			dispatchChangeEvent(DataChangeType.INVALIDATE,[data[index]],index,index);
		}

		/**
		 * Invalidates the specified item. An item is invalidated after it is
		 * changed; the DataProvider automatically redraws the invalidated item. 
		 *
         * @param item Item to be invalidated.
         *
         * @see #invalidate()
         * @see #invalidateItemAt()
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		public function invalidateItem(item:Object):void {
			var index:uint = getItemIndex(item);
			if (index == -1) { return; }
			invalidateItemAt(index);
		}

		/**
         * Invalidates all the data items that the DataProvider contains and dispatches a 
         * <code>DataChangeEvent.INVALIDATE_ALL</code> event. Items are invalidated after they
		 * are changed; the DataProvider automatically redraws the invalidated items. 
         *
         * @see #invalidateItem()
         * @see #invalidateItemAt()
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		public function invalidate():void {
			dispatchEvent(new DataChangeEvent(DataChangeEvent.DATA_CHANGE, DataChangeType.INVALIDATE_ALL,data.concat(),0,data.length));
		}


		/**
		 * Adds a new item to the data provider at the specified index.
		 * If the index that is specified exceeds the length of the data provider,
		 * the index is ignored.
		 *
		 * @param item An object that contains the data for the item to be added.
		 *
         * @param index  The index at which the item is to be added.
         *
         * @throws RangeError The specified index is less than 0 or greater than or equal 
		 *         to the length of the data provider.
         *
         * @see #addItem()
         * @see #addItems()
         * @see #addItemsAt()
         * @see #getItemAt()
         * @see #removeItemAt()
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		public function addItemAt(item:Object,index:uint):void {
			checkIndex(index,data.length);
			dispatchPreChangeEvent(DataChangeType.ADD,[item],index,index);
			data.splice(index,0,item);
			dispatchChangeEvent(DataChangeType.ADD,[item],index,index);
		}

		/**
		 * Appends an item to the end of the data provider.
		 *
         * @param item The item to be appended to the end of the current data provider.
         *
         * @includeExample examples/DataProvider.constructor.1.as -noswf
         *
         * @see #addItemAt()
         * @see #addItems()
         * @see #addItemsAt()
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		public function addItem(item:Object):void {
			dispatchPreChangeEvent(DataChangeType.ADD,[item],data.length-1,data.length-1);
			data.push(item);
			dispatchChangeEvent(DataChangeType.ADD,[item],data.length-1,data.length-1);
		}

		/**
		 * Adds several items to the data provider at the specified index and dispatches
		 * a <code>DataChangeType.ADD</code> event.
		 *
		 * @param items The items to be added to the data provider.
		 *
		 * @param index The index at which the items are to be inserted.
         *
         * @throws RangeError The specified index is less than 0 or greater than or equal 
		 *                    to the length of the data provider.
         *
         * @see #addItem()
         * @see #addItemAt()
         * @see #addItems()
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		public function addItemsAt(items:Object,index:uint):void {
			checkIndex(index,data.length);
			var arr:Array = getDataFromObject(items);
			dispatchPreChangeEvent(DataChangeType.ADD,arr,index,index+arr.length-1);			
			data.splice.apply(data, [index,0].concat(arr));
			dispatchChangeEvent(DataChangeType.ADD,arr,index,index+arr.length-1);
		}

		/**
		 * Appends multiple items to the end of the DataProvider and dispatches
		 * a <code>DataChangeType.ADD</code> event. The items are added in the order 
		 * in which they are specified.
		 *
         * @param items The items to be appended to the data provider.
         *
         * @includeExample examples/DataProvider.addItems.1.as -noswf
         * 
         * @see #addItem()
         * @see #addItemAt()
         * @see #addItemsAt()
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		public function addItems(items:Object):void {
			addItemsAt(items,data.length);
		}

		/**
		 * Concatenates the specified items to the end of the current data provider.
         * This method dispatches a <code>DataChangeType.ADD</code> event.
		 *
         * @param items The items to be added to the data provider.
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         *
         * @see #addItems()
         * @see #merge()
         *
		 * @internal Is this method any different than addItems()? It's not clear.
		 *           I also thing "concatenates the items *to*" sounds odd. Perhaps
		 *           the concatenated items are added to the end of the data provider?
		 */
		public function concat(items:Object):void {
			addItems(items);
		}

		/**
		 * Appends the specified data into the data that the data provider
		 * contains and removes any duplicate items. This method dispatches
		 * a <code>DataChangeType.ADD</code> event.
		 *
         * @param data Data to be merged into the data provider.
         *
         * @see #concat()
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		public function merge(newData:Object):void {
			var arr:Array = getDataFromObject(newData);
			var l:uint = arr.length;
			var startLength:uint = data.length;
			
			dispatchPreChangeEvent(DataChangeType.ADD,data.slice(startLength,data.length),startLength,this.data.length-1);
			
			for (var i:uint=0; i<l; i++) {
				var item:Object = arr[i];
				if (getItemIndex(item) == -1) {
					data.push(item);
				}
			}
			if (data.length > startLength) {
				dispatchChangeEvent(DataChangeType.ADD,data.slice(startLength,data.length),startLength,this.data.length-1);
			} else {
				dispatchChangeEvent(DataChangeType.ADD,[],-1,-1);
			}
		}

		/**
         * Returns the item at the specified index.
		 *
		 * @param index Location of the item to be returned.
		 *
		 * @return The item at the specified index.
         *
         * @throws RangeError The specified index is less than 0 or greater than 
		 *         or equal to the length of the data provider.
         *
         * @see #getItemIndex()
         * @see #removeItemAt()
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		public function getItemAt(index:uint):Object {
			checkIndex(index,data.length-1);
			return data[index];
		}

		/**
         * Returns the index of the specified item.
		 *
		 * @param item The item to be located.
		 *
         * @return The index of the specified item, or -1 if the specified item is not found.
         *
         * @see #getItemAt()
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		public function getItemIndex(item:Object):int {
			return data.indexOf(item);;
		}

		/**
		 * Removes the item at the specified index and dispatches a <code>DataChangeType.REMOVE</code>
		 * event.
		 *
		 * @param index Index of the item to be removed.
         *
         * @return The item that was removed.
         *
         * @throws RangeError The specified index is less than 0 or greater than
         *         or equal to the length of the data provider.
         *
         * @see #removeAll()
         * @see #removeItem()
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		public function removeItemAt(index:uint):Object {
			checkIndex(index,data.length-1);
			dispatchPreChangeEvent(DataChangeType.REMOVE, data.slice(index,index+1), index, index);
			var arr:Array = data.splice(index,1);
			dispatchChangeEvent(DataChangeType.REMOVE,arr,index,index);
			return arr[0];
		}

		/**
		 * Removes the specified item from the data provider and dispatches a <code>DataChangeType.REMOVE</code>
		 * event.
		 *
		 * @param item Item to be removed.
         *
         * @return The item that was removed.
         *
         * @see #removeAll()
         * @see #removeItemAt()
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		public function removeItem(item:Object):Object {
			var index:int = getItemIndex(item);
			if (index != -1) {
				return removeItemAt(index);
			}
			return null;
		}

		/**
		 * Removes all items from the data provider and dispatches a <code>DataChangeType.REMOVE_ALL</code>
         * event.
         *
         * @see #removeItem()
         * @see #removeItemAt()
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		public function removeAll():void {
			var arr:Array = data.concat();
			
			dispatchPreChangeEvent(DataChangeType.REMOVE_ALL,arr,0,arr.length);
			data = [];
			dispatchChangeEvent(DataChangeType.REMOVE_ALL,arr,0,arr.length);
		}

		/**
		 * Replaces an existing item with a new item and dispatches a <code>DataChangeType.REPLACE</code>
		 * event.
		 *
		 * @param oldItem The item to be replaced.
		 *
		 * @param newItem The replacement item.
		 *
         * @return The item that was replaced.
         *
         * @throws RangeError The item could not be found in the data provider.
         *
         * @see #replaceItemAt()
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		public function replaceItem(newItem:Object,oldItem:Object):Object {
			var index:int = getItemIndex(oldItem);
			if (index != -1) {
				return replaceItemAt(newItem,index);
			}
			return null;
		}

		/**
		 *  Replaces the item at the specified index and dispatches a <code>DataChangeType.REPLACE</code>
		 *  event.
		 *
		 * @param newItem The replacement item.
		 *
		 * @param index The index of the item to be replaced.
		 *
         * @return The item that was replaced.
         * 
         * @throws RangeError The specified index is less than 0 or greater than 
         *         or equal to the length of the data provider.
         *
         * @see #replaceItem()
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		public function replaceItemAt(newItem:Object,index:uint):Object {
			checkIndex(index,data.length-1);
			var arr:Array = [data[index]];
			dispatchPreChangeEvent(DataChangeType.REPLACE,arr,index,index);
			data[index] = newItem;
			dispatchChangeEvent(DataChangeType.REPLACE,arr,index,index);
			return arr[0];
		}

		/**
		 * Sorts the items that the data provider contains and dispatches a <code>DataChangeType.SORT</code>
		 * event.
         *
		 * @param sortArg The arguments to use for sorting.
		 *
         * @return The return value depends on whether the method receives any arguments.  
         *         See the <code>Array.sort()</code> method for more information. 
         *         This method returns 0 when the <code>sortOption</code> property 
         *         is set to <code>Array.UNIQUESORT</code>.
		 *
         * @see #sortOn()
         * @see Array#sort() Array.sort()
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		public function sort(...sortArgs:Array):* {
			dispatchPreChangeEvent(DataChangeType.SORT,data.concat(),0,data.length-1);
			var returnValue:Array = data.sort.apply(data,sortArgs);
			dispatchChangeEvent(DataChangeType.SORT,data.concat(),0,data.length-1);
			return returnValue;
		}

		/**
		 * Sorts the items that the data provider contains by the specified 
		 * field and dispatches a <code>DataChangeType.SORT</code> event.
		 * The specified field can be a string, or an array of string values that
		 * designate multiple fields to sort on in order of precedence.
		 *
		 * @param fieldName The item field by which to sort. This value can be a string 
		 *                  or an array of string values.
		 *
		 * @param options Options for sorting.
		 *
		 * @return The return value depends on whether the method receives any arguments. 
		 *         For more information, see the <code>Array.sortOn()</code> method. 
		 *         If the <code>sortOption</code> property is set to <code>Array.UNIQUESORT</code>,
		 *         this method returns 0. 
		 *
         * @see #sort()
         * @see Array#sortOn() Array.sortOn()
         *
		 * @internal If an array of string values is passed, does the sort take place in
		 * the order that the string values are specified?  Also, it might be helpful if "options
		 * for sorting" was more explicit. I wondered if that meant sort type, like merge sort
		 * or bubble sort, for example, but when I looked up "uniquesort" it seemed like not.
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		public function sortOn(fieldName:Object,options:Object=null):* {
			dispatchPreChangeEvent(DataChangeType.SORT,data.concat(),0,data.length-1);
			var returnValue:Array = data.sortOn(fieldName,options);
			dispatchChangeEvent(DataChangeType.SORT,data.concat(),0,data.length-1);
			return returnValue;
		}

		/**
		 * Creates a copy of the current DataProvider object.
		 *
         * @return A new instance of this DataProvider object.
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		public function clone():DataProvider {
			return new DataProvider(data);
		}

		/**
		 * Creates an Array object representation of the data that the data provider contains.
		 *
         * @return An Array object representation of the data that the data provider contains.
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		public function toArray():Array {
			return data.concat();
		}

		/**
		 * Creates a string representation of the data that the data provider contains.
		 *
         * @return A string representation of the data that the data provider contains.
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		override public function toString():String {
			return "DataProvider ["+data.join(" , ")+"]";
		}

		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected function getDataFromObject(obj:Object):Array {
			var retArr:Array;
			if (obj is Array) {
				var arr:Array = obj as Array;
				if (arr.length > 0) {
					if (arr[0] is String || arr[0] is Number) {
						retArr = [];
						// convert to object array.
						for (var i:uint = 0; i < arr.length; i++) {
							var o:Object = {label:String(arr[i]),data:arr[i]}
							retArr.push(o);
						}
						return retArr;
					}
				}
				return obj.concat();
			} else if (obj is DataProvider) {
				return obj.toArray();
			} else if (obj is XML) {
				var xml:XML = obj as XML;
				retArr = [];
				var nodes:XMLList = xml.*;
				for each (var node:XML in nodes) {
					var obj:Object = {};
					var attrs:XMLList = node.attributes();
					for each (var attr:XML in attrs) {
						obj[attr.localName()] = attr.toString();
					}
					var propNodes:XMLList = node.*;
					for each (var propNode:XML in propNodes) {
						if (propNode.hasSimpleContent()) {
							obj[propNode.localName()] = propNode.toString();
						}
					}
					retArr.push(obj);
				}
				return retArr;
			} else {
				throw new TypeError("Error: Type Coercion failed: cannot convert "+obj+" to Array or DataProvider.");
				return null;
			}
		}
		
		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected function checkIndex(index:int,maximum:int):void {
			if (index > maximum || index < 0) {
				throw new RangeError("DataProvider index ("+index+") is not in acceptable range (0 - "+maximum+")");
			}
		}

		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected function dispatchChangeEvent(evtType:String,items:Array,startIndex:int,endIndex:int):void {
			dispatchEvent(new DataChangeEvent(DataChangeEvent.DATA_CHANGE,evtType,items,startIndex,endIndex));
		}
		
		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected function dispatchPreChangeEvent(evtType:String, items:Array, startIndex:int, endIndex:int):void {
			dispatchEvent(new DataChangeEvent(DataChangeEvent.PRE_DATA_CHANGE, evtType, items, startIndex, endIndex));
		}
	}

}