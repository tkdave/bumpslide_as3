package com.bumpslide.net
{

	import com.bumpslide.data.Callback;
	import flash.events.TimerEvent;
	import flash.utils.Timer;


	/**
	 * Make a request repeatedly and provide conditions for an exit
	 *
	 * @author David Knape, http://bumpslide.com/
	 */
	public class RequestPoller extends AbstractRequest
	{
		public static const DEFAULT_POLL_INTERVAL:uint = 5000;
		
		private var pollInterval:uint = DEFAULT_POLL_INTERVAL;
		private var request:IRequest;
		private var timer:Timer;
		private var stopWhen:Function;
		private var responder:Callback;

		public function RequestPoller( the_request:IRequest, poll_interval:uint = DEFAULT_POLL_INTERVAL, stop_when:Function = null, responder:IResponder = null )
		{
			
			
			debugEnabled = true;

			debug('created');
			request = the_request;
			pollInterval = poll_interval;
			stopWhen = stop_when==null ? NeverStop : stop_when;

			super( responder );
			
			if (the_request == null) {
				throw new Error( 'Request cannot be null' );
			}
		}

		
		static public function NeverStop( result:Object ):Boolean
		{
			return false;
		}


		override protected function initRequest():void
		{
			debug('initRequest()');
			
			killRequest();			
					
			responder = new Callback( handleRequestResult, handleRequestError );
			
			request.reset(true);
			request.addResponder( responder );

			timer = new Timer( pollInterval, 0 );
			timer.addEventListener( TimerEvent.TIMER, doRequest );
			timer.start();
		}


		override protected function killRequest():void
		{
			if(timer) {
				timer.stop();
				timer.removeEventListener( TimerEvent.TIMER, doRequest );
				timer = null;
			}
			
			if(request && responder) {
				request.removeResponder( responder );
			}
		}


		private function doRequest( event:TimerEvent ):void
		{
			debug('reloading service');
			request.load();
		}


		override public function cancel():IRequest
		{
			request.cancel();
			return super.cancel();
		}


		public function handleRequestError( info:Error ):void
		{
			raiseError( info );
		}

		public function handleRequestResult( data:Object ):void
		{	
			debug('poll result:'+data);
			
			if (stopWhen.call( null, data )) {
				
				debug('all done');
				finishCompletedRequest( data )
				
			} else {
				
			}
		}
	}
}
