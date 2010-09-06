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

package com.bumpslide.media {
	
	import flash.events.Event;	import flash.events.EventDispatcher;	import flash.events.IOErrorEvent;	import flash.events.ProgressEvent;	import flash.events.SecurityErrorEvent;	import flash.events.TimerEvent;	import flash.media.ID3Info;	import flash.media.Sound;	import flash.media.SoundChannel;	import flash.media.SoundLoaderContext;	import flash.media.SoundMixer;	import flash.media.SoundTransform;	import flash.net.URLRequest;	import flash.utils.Timer;		import com.bumpslide.events.UIEvent;	import com.bumpslide.util.Delegate;	
	/**
	 * Facade for the sound-related classes, not a visual interface, just logic.
	 * 
	 * This is not a visual player interface, but it does provide the logic necessary
	 * to build such an interface without too much trouble.  This is meant to be a 
	 * slightly simpler programming interface to the sound-related classes in the 
	 * flash.media package. It dispatches "playProgress" ProgressEvents and adds 
	 * pause and resume functionality.  
	 * 
	 * This is a modified version of the SoundFacade class from the PodcastPlayer 
	 * example released on the Adobe site for the Flash CS3, Programming AS3 Sample 
	 * files. see http://www.adobe.com/support/documentation/en/flash/samples/
	 *  
	 * David Knape (bumpslide.com) added:
	 * - volume setter
	 * - trackLength getter
	 * - trackPosition getter
	 * - seek()
	 * - PLAY_STATE_CHANGE event
	 */
	 
	public class Mp3Player extends EventDispatcher {

		/**
		 * The Sound object used to load the sound file.
		 */
		public var sound:Sound;

		/**
		 * The SoundChannel object used to play and track playback progess
		 * of the sound.
		 */		
		public var sc:SoundChannel;

		/**
		 * The URL of the sound file to load.
		 */
		public var url:String;

		/**
		 * The buffer time to use when loading this object's sound file.
		 */
		public var bufferTime:int = 1000;

		/**
		 * Identifies when the sound file has been fully loaded.
		 */
		public var isLoaded:Boolean = false;

		/**
		 * Identifies when the sound file has been fully loaded.
		 */
		public var isReadyToPlay:Boolean = false;

		/**
		 * Identifies when the sound file is being played.
		 */
		public var isPlaying:Boolean = false;

		/**
		 * Specifies that the sound file can be played while it is being loaded.
		 */
		public var isStreaming:Boolean = true;

		/**
		 * Indicates that sound loading should start as soon as this object is created.
		 */
		public var autoLoad:Boolean = true;

		/**
		 * Indicates that sound playing should start as soon as enough sound data has been loaded.
		 * If this is a streaming sound, playback will begin as soon as enough data, as specified
		 * by the bufferTime property, has been loaded.
		 */
		public var autoPlay:Boolean = true;

		/**
		 * The position of the playhead in the sound data when the playback was last paused.
		 */
		public var pausePosition:int = 0;

		/**
		 * Defines how often to dispatch the playback progress event.
		 */
		public var progressInterval:int = 500;

		/**
		 * The Timer that's used to update the progress display.
		 */
		public var playTimer:Timer;

		/**
		 * Defines the "playProgress" event type.
		 */
		public static const PLAY_PROGRESS:String = "playProgress";

		/**
		 * Event type dispatched whenever play state changes
		 */
		public static const PLAY_STATE_CHANGE:String = "playStateChange";

		//--------------
		// PLAY STATES
		//---------------
		
		public static const STATE_BUFFERING:uint = 1;
		public static const STATE_READY_TO_PLAY:uint = 2;
		public static const STATE_PLAYING:uint = 3;
		public static const STATE_PAUSED:uint = 4;
		public static const STATE_STOPPED:uint = 5;
		public static const STATE_ERROR:uint = 99;	
		

		// internal storage for play state
		//private var _state:uint = STATE_STOPPED;

		// play state notification delay
		private var stateChangeNotification:Timer;
		

		/**
		 * Constructor.
		 */
		public function Mp3Player(soundUrl:String, autoLoad:Boolean = true, autoPlay:Boolean = true, streaming:Boolean = true, bufferTime:int = -1):void {
			
			url = soundUrl;

			// sets boolean values that determine the behavior of this object
			this.autoLoad = autoLoad;
			this.autoPlay = autoPlay;
			this.isStreaming = streaming;
		    
			// defaults to the global bufferTime value
			if (bufferTime < 0) {
				bufferTime = SoundMixer.bufferTime;
			}
			// keeps buffer time reasonable, between 0 and 30 seconds
			this.bufferTime = Math.min(Math.max(0, bufferTime), 30);
		    
			if (this.autoLoad) {
				load();
			}
		}

		public function load():void {
			if (isPlaying) {
				stop();
				sound.close();
				pausePosition = 0;
			}
			isLoaded = false;
			
			sound = new Sound();
			
			sound.addEventListener(ProgressEvent.PROGRESS, onLoadProgress);
			sound.addEventListener(Event.OPEN, onLoadOpen);
			sound.addEventListener(Event.COMPLETE, onLoadComplete);
			sound.addEventListener(Event.ID3, onID3);
			sound.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			sound.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onIOError);
			
			var req:URLRequest = new URLRequest(url);
			
			var context:SoundLoaderContext = new SoundLoaderContext(bufferTime, true);
			sound.load(req, context);
			
			playStateChanged(STATE_BUFFERING);	
		}

		public function onLoadOpen(event:Event):void {
			if (isStreaming) {
				isReadyToPlay = true;
				if (autoPlay) {
					play();
				} else {
					playStateChanged(STATE_READY_TO_PLAY);
				}
			}
			dispatchEvent(event.clone());
		}

		public function onLoadProgress(event:ProgressEvent):void {   
			dispatchEvent(event.clone());
		}

		public function onLoadComplete(event:Event):void {
			isReadyToPlay = true;
			isLoaded = true;
			dispatchEvent(event.clone());
			
			// if the sound hasn't started playing yet, start it now
			if (autoPlay && !isPlaying) {
				play();
			}
		}

		public function play(pos:int = 0):void {
			if (!isPlaying) {
				if (isReadyToPlay && sound!=null) {
					sc = sound.play(pos);
					if(sc==null) {
						// fail silently.  something's wrong.
						trace('[Mp3Player] Sound channel is null. (weird)');
						return;
					}
					sc.addEventListener(Event.SOUND_COMPLETE, onPlayComplete, false, 0, true);
					isPlaying = true;
					
					// init volume
					volume = _volume;
					
					playStateChanged(STATE_PLAYING);
					
					playTimer = new Timer(progressInterval);
					playTimer.addEventListener(TimerEvent.TIMER, onPlayTimer, false, 0, true);
					playTimer.start();
				}
				else if (isStreaming && !isLoaded) {
					// start loading again and play when ready
					// it appears to resume loading from the spot where it left off...cool
					load();				
					return;
				}
			} 
		}

		public function seek(pos:int = 0):void {		
			// don't allow seek all the way to the end
			pos = Math.min(pos, sound.length - 500);		
				
			if(isPlaying) {						
				sc.stop();
				sc = sound.play(pos);
				sc.addEventListener(Event.SOUND_COMPLETE, onPlayComplete, false, 0, true);
			} else {
				pausePosition = pos;
			}			
		}

		public function stop(pos:int = 0):void {
			if (isPlaying) {
				pausePosition = pos;
				sc.stop();
				playTimer.stop();
				isPlaying = false;
			}
			if (isStreaming && !isLoaded) {
				// stop streaming
				try { sound.close(); } catch (e:Error) {}
				isReadyToPlay = false;
			}
			
			playStateChanged(STATE_STOPPED);	
		}

		public function pause():void {
			stop(sc.position);
			playStateChanged(STATE_PAUSED);	
		}

		public function resume():void {
			// if paused at the end, reset to 0			
			if(Math.ceil(pausePosition/1000)>=Math.ceil(trackLength/1000)-1) pausePosition=0;
			play(pausePosition);
		}

		public function get isPaused():Boolean {
			return (pausePosition > 0);
		}

		public function onPlayComplete(event:Event):void {
			pausePosition = 0;
			playTimer.stop();
			isPlaying = false;
            
			dispatchEvent(event.clone());
            
			playStateChanged(STATE_STOPPED);
		}

		public function onID3(event:Event):void {
			try {
				var id3:ID3Info = (event.target as Sound).id3;
    		    
				for (var propName:String in id3) {
					trace(propName + " = " + id3[propName]);
				}
			}
    		catch (err:SecurityError) {
				trace("[Mp3Player] Could not retrieve ID3 data.");
			}
		}

		public function get id3():ID3Info {
			return sound.id3;
		}

		public function onIOError(event:IOErrorEvent):void {
			trace("[Mp3Player] onIOError() " + event.text);
			dispatchEvent(event.clone());
			playStateChanged(STATE_ERROR);
		}

		public function onPlayTimer(event:TimerEvent):void {
			var progEvent:ProgressEvent = new ProgressEvent(PLAY_PROGRESS, false, false, sc.position, trackLength);
			dispatchEvent(progEvent);
		}

		private function playStateChanged( state:uint ):void {
			Delegate.cancel(stateChangeNotification);
			stateChangeNotification = Delegate.callLater(10, UIEvent.send, this, PLAY_STATE_CHANGE, state);
		}

		private var _volume:Number = .8;

		public function set volume( n:Number ):void {
			_volume = .8;			
			if(sc) {
				var sndTransform:SoundTransform = sc.soundTransform;
				sndTransform.volume = n;
				sc.soundTransform = sndTransform;
			}
		}

		public function get volume():Number {
			return _volume;
		}

		public function get trackLength():int {
			if(sound) return Math.ceil(sound.length / (sound.bytesLoaded / sound.bytesTotal));
			else return 1;  // avoid divide by zero (1ms is close enough)
		}

		public function get trackPosition():int {
			if(sc && isPlaying) return sc.position;
        	else return pausePosition;
		}
	}
}