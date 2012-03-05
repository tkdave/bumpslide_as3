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

package com.bumpslide.data {	import com.bumpslide.net.IResponder;		/**	 * Barebones IResponder implementation	 * 	 * @author David Knape	 */	public class Callback implements IResponder {				private var _resultHandler:Function;		private var _faultHandler:Function;		private var _passThruData:Object;				public function Callback( result_handler:Function, fault_handler:Function=null, pass_thru_data:Object=null) {			_resultHandler = result_handler;			_faultHandler = fault_handler;			_passThruData = pass_thru_data;		}		public function fault(info:Error):void {			if(_faultHandler is Function) {				try {					_faultHandler.call( null, info, _passThruData );				} catch (e1:ArgumentError) {					try { 						_faultHandler.call( null, info );					} catch (e:ArgumentError) {						_faultHandler.call( null );					}				}			}		}				public function result(data:Object):void {			if(_resultHandler is Function) {				try {					_resultHandler.call( null, data, _passThruData );				} catch (e1:ArgumentError) {					try { 						_resultHandler.call( null, data );					} catch (e:ArgumentError) {						_resultHandler.call( null );					}				}			}		}	}}