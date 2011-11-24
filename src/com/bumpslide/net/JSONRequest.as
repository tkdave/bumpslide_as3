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
	import com.adobe.serialization.json.JSON;
	import com.bumpslide.net.HTTPRequest;

	import flash.net.URLRequest;		

	/**
	 * JSON Request - requires adobe corelib JSON decoder
	 * 
	 * @author David Knape
	 */
	public class JSONRequest extends HTTPRequest {

		public function JSONRequest(request:URLRequest, responder:IResponder = null) {
			super(request, responder);
		}
		
		override protected function getResult():* {
			return com.adobe.serialization.json.JSON.decode(data, false);
		}
	}
}
