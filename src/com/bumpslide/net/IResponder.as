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
	 * Like the mx.rpc.responder interface
	 * 
	 * Represents a pair of callback functions (result and fault) used to 
	 * handle the results and/or errors coming from asynchronous calls  
	 * 
	 * @author David Knape
	 */
	public interface IResponder {
		function fault(info : Error) : void;
		function result(data : Object) : void;
	}
}
