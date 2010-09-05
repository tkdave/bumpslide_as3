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
	import flash.net.URLRequest;	
	
	import com.bumpslide.net.HTTPRequest;
	
	/**
	 * Basic XML request, returns result as XML object
	 * 
	 * @author David Knape
	 */
	public class XMLRequest extends HTTPRequest {

		public function XMLRequest(request:URLRequest, responder:IResponder = null) {
			super(request, responder);
		}
		
		override protected function getResult():* {
			XML.ignoreWhitespace=true;
			try {				
				return new XML( data );
			} catch (e:Error) {
				raiseError( e );
			}
			return null;
		}
	}
}
