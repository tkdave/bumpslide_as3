package com.bumpslide.net {

	/**
	 * Interface for Basic Service Call
	 * 
	 * @author David Knape
	 */
	public interface IRequest {
		
		function set retryCount (n:uint):void;	
		function get retryCount ():uint;
								
		function set timeout(seconds:uint):void;
		function get timeout():uint;
		
		function load():void;
		
		function cancel():void;
						
		function addResponder( responder:IResponder ):void;
		
		
	}
}
