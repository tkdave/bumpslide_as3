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
 
package com.bumpslide.util
{

	import flash.external.ExternalInterface;
	
	/**
	 * Log to the browser console log
	 *
	 * @author David Knape, http://bumpslide.com/
	 */
	public class Console
	{
		static public function Log( ...args ):void {
			args.unshift( 'console.log' );
			if (ExternalInterface.available) ExternalInterface.call.apply( null, args );
		}
	}
}
