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

package com.bumpslide.net {

	/**
	 * Interface for asynchronous commands such as web API calls and requests for assets
	 * 
	 * All methods are chainable
	 * 
	 * @author David Knape
	 */
	public interface IRequest {
		
		/**
		 * Load the request
		 */
		function load():IRequest;
		
		/**
		 * Cancel the request
		 */
		function cancel():IRequest;
		
		/**
		 * Cancel and reset so request can be reused. Optionally remove all responders.
		 */
		function reset( remove_responders:Boolean = false ):IRequest;
			
		/**
		 * Add responder with result and fault handlers
		 */					
		function addResponder( responder:IResponder ):IRequest;
		
		/**
		 * Remove responder
		 */
		function removeResponder( responder:IResponder ):IRequest;
		
	}
}
