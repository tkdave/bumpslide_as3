/**
 * This code is part of the Bumpslide Library by David Knape
 * http://bumpslide.com/
 * 
 * Copyright (c) 2006, 2007, 2008 by Bumpslide, Inc.
 * 
 * Released under the open-source MIT license.
 * http://www.opensource.org/licenses/mit-license.php
 * see LICENSE.txt for full license terms
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
		function fault(info : Object) : void;
		function result(data : Object) : void;
	}
}
