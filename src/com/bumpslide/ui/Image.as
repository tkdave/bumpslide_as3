/** * This code is part of the Bumpslide Library maintained by David Knape * Fork me at http://github.com/tkdave/bumpslide_as3 *  * Copyright (c) 2010 by Bumpslide, Inc.  * http://www.bumpslide.com/ * * This code is released under the open-source MIT license. * See LICENSE.txt for full license terms. * More info at http://www.opensource.org/licenses/mit-license.php */package com.bumpslide.ui {	import com.bumpslide.net.LoaderQueue;	import com.bumpslide.net.LoaderRequest;	import com.bumpslide.tween.FTween;	import com.bumpslide.util.ImageUtil;	import flash.display.Bitmap;	import flash.display.DisplayObject;	import flash.display.Loader;	import flash.events.Event;	import flash.events.IOErrorEvent;	import flash.events.ProgressEvent;	import flash.net.URLRequest;	import flash.system.LoaderContext;	import flash.utils.ByteArray;	[Event(name='onImageLoaded',type='com.bumpslide.events.UIEvent')]	[Event(name='onImageError',type='com.bumpslide.events.UIEvent')]	[Event(name='onImageProgress',type='com.bumpslide.events.UIEvent')]		/**	 * Image Loader Component that handles resizing and cropping	 * 	 * @author David Knape	 */	public class Image extends Component 	{		// Events...		public static const EVENT_LOADED:String = "onImageLoaded";		public static const EVENT_ERROR:String = "onImageError";		public static const EVENT_PROGRESS:String = "onImageProgress";		// debug status colors		private static const COLOR_ERROR:Number = 0xDF665A;		// error		private static const COLOR_ENQUEUED:Number = 0xF2A044;    // enqueued		private static const COLOR_PROGRESS:Number = 0xF9D575;     // in progress		private static const COLOR_LOADED:Number = 0x82B4C4;      // loaded		private static const COLOR_UNLOADED:Number = 0x253C4B;      // loaded				// Scale Modes...				// Crop to fill height and width		public static const SCALE_CROP:String = "crop";				// resize to height and width, but preserve aspect ratio		public static const SCALE_RESIZE:String = "resize";				// no resize, height and width will always be that of loaded image		public static const SCALE_NONE:String = "none";		// Shared Loading Queue		private static var _loadingQueue:LoaderQueue = new LoaderQueue(); 		//protected static var _loadingQueue:RequestQueue = new RequestQueue(4);		// private				// debug status indicator		protected var _status:Box;		// raw bitmap		//protected var _bitmap:Bitmap; 		// the loader		protected var _loader:Loader;		// content source		protected var _url:String = null;		// whether or not image is loaded		protected var _imageLoaded:Boolean = false;		// our image scale mode		protected var _scaleMode:String = SCALE_NONE;		// fade in when load is complete?		protected var _fadeOnLoad:Boolean = false;		protected var _fadeEasingFactor:Number = .2;		protected var _constructorArgs:Array;		protected var _useLoadingQueue:Boolean = true;		protected var _loaderRequest:LoaderRequest;		// loader context used to load url's		public var loaderContext:LoaderContext = new LoaderContext(true);		private var _attachment:DisplayObject;		private var _source:*;				/**		 * Reference to global image queue		 */		static public function get queue():LoaderQueue {			return _loadingQueue;		}				/**		 * Cancel all pending image loads		 */		static public function clearQueue():void 		{			queue.clear();		}				public function Image(source:* = null, scale_mode:String = SCALE_NONE, w:Number = -1, h:Number = -1, loadCompleteHandler:Function = null) 		{			_constructorArgs = arguments as Array;			super();		}				override protected function addChildren():void 		{				// create image _loader, setup on_imageLoaded listener, add to stage			_loader = new Loader();			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoaded, false, 0, true);			_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onImageProgress, false, 0, true);			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onImageError, false, 0, true);			addChild(_loader);                           			_status = new Box(COLOR_UNLOADED, 8, 8, 2, 2, 3);			addChild(_status);            			source = _constructorArgs[0];			scaleMode = _constructorArgs[1];			width = _constructorArgs[2];			height = _constructorArgs[3];        				var loadCompleteHandler:Function = _constructorArgs[4];			if(loadCompleteHandler != null) {				addEventListener(EVENT_LOADED, loadCompleteHandler, false, 0, true);			}			delayUpdate = false;        				super.addChildren();		}				override public function destroy():void 		{			//trace('destroy image');			if(_constructorArgs[4]) { 				removeEventListener(EVENT_LOADED, _constructorArgs[4]); 			}			if(_loader) {				_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onImageLoaded);				_loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onImageProgress);				_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onImageError);			}			unload();			destroyChild(_loader);			_loader = null;						super.destroy();		}				override protected function draw():void 		{						_status.visible = (logEnabled);        	 			if(loaded) {				if(!image.visible) {					image.alpha = 0;					image.visible = true;					if(fadeOnLoad) FTween.ease(image, 'alpha', 1, _fadeEasingFactor);        			else image.alpha = 1;				}				if(_url != 'bytes' && bitmap != null) {					bitmap.smoothing = true;				} 				if(explicitWidth!=-1 && explicitHeight!=-1) {					switch( scaleMode ) {						case SCALE_CROP: 								ImageUtil.crop(image, explicitWidth, explicitHeight); 							break;						case SCALE_RESIZE:								ImageUtil.resize(image, explicitWidth, explicitHeight, true); 							break;    						case SCALE_NONE:							ImageUtil.reset(image);							break;    									}   					}			} else {				if(image != null) FTween.stopTweening(image, 'alpha');			}			super.draw();		}						/**		 * Load the image		 */        		public function load( image_url:String, priority:int = 1, loader_context:LoaderContext = null):Boolean 		{       			if(loader_context != null) loaderContext = loader_context; 			if(image_url == _url) return false;			unload();			_url = image_url;           	        			if(_url != null) { 				log('loading image ' + _url);				_status.backgroundColor = COLOR_ENQUEUED;								doLoadUrl( _url, priority);				return true;			}               			return false; 		}				protected function doLoadUrl( image_url:String, priority:int = 1):void {			if(useLoadingQueue) {				_loaderRequest = new LoaderRequest(loader, url, loaderContext);				//_loadingQueue.load(_loaderRequest, priority);				_loadingQueue.load( url, loader, priority, loaderContext );			} else {				_loader.load(new URLRequest(_url), loaderContext);			}		}				/**		 * Load the image as bytes		 */        		public function loadBytes( data:ByteArray ):Boolean 		{			unload();			_url = 'bytes';			_loader.loadBytes(data);			//onImageLoaded();			return true;		}				/**		 * Attach display object such as a Bitmap		 */        		public function attach( obj:DisplayObject ):void 		{        			unload();						if(obj != null) {								_attachment = addChild(obj);				onImageLoaded();			} else {				sendEvent(EVENT_ERROR, "Invalid Bitmap"); 			}           	  		}				/**		 * Once image is loaded, display it		 */		private function onImageLoaded(e:Event = null):void 		{   			log('image loaded');			_status.backgroundColor = COLOR_LOADED;			loaded = true;      			invalidate(VALID_SIZE);   				updateNow();			sendEvent(EVENT_LOADED, _url);           		}				/**		 * Progress Handler		 */		private function onImageProgress(e:ProgressEvent = null):void 		{    			_status.backgroundColor = COLOR_PROGRESS;			sendEvent(EVENT_PROGRESS, e.bytesLoaded / e.bytesTotal);           		}				/**		 * Error handler		 */		private function onImageError(e:IOErrorEvent = null):void 		{    			log('onImageError ' + e.text);			sendEvent(EVENT_ERROR, e.text);  			_status.backgroundColor = COLOR_ERROR;         		}				/**		 * Unload image		 **/		public function unload():void 		{            			// hide			//visible = false;			loaded = false;			_url = null;			if(image != null) {				FTween.stopTweening(image);				image.alpha = 0;				image.visible = false;			}						// unload content and/or cancel pending load			if(_loaderRequest != null) {				_loaderRequest.unload();  			}						            if(_attachment != null && contains(_attachment)) removeChild(_attachment);            _attachment = null;            			_status.backgroundColor = COLOR_UNLOADED;         		}				//-------------------------------		// GETTERS and SETTERS		//-------------------------------		public function get scaleMode():String {			return _scaleMode;		}				public function set scaleMode(mode:String):void {			_scaleMode = mode;			invalidate();		}				override public function get width():Number {			return (loaded && scaleMode != SCALE_CROP ) ? image.width : explicitWidth;		}						override public function get height():Number {			return (loaded && scaleMode != SCALE_CROP ) ? image.height : explicitHeight;		}				public function get loaded():Boolean {			return _imageLoaded;		}				public function set loaded( val:Boolean ):void {			if(val == _imageLoaded) return;			_imageLoaded = val;			sendChangeEvent('loaded', val);		}				public function get fadeOnLoad():Boolean {			return _fadeOnLoad;		}				public function set fadeOnLoad(fadeIn:Boolean):void {			_fadeOnLoad = fadeIn;		}				public function get fadeEasingFactor():Number {			return _fadeEasingFactor;		}				public function set fadeEasingFactor(fadeEasingFactor:Number):void {			_fadeEasingFactor = fadeEasingFactor;		}				public function get url():String {			return _url;		}				public function set url( image_url:String ):void {			load(image_url);		}				public function get loader():Loader {			return _loader;		}				public function get aspectRatio():Number {			return width / height;		}				public function get useLoadingQueue():Boolean {			return _useLoadingQueue;		}				public function set useLoadingQueue(useLoadingQueue:Boolean):void {			_useLoadingQueue = useLoadingQueue;		}				public function get image():DisplayObject {			if(_attachment != null) return _attachment;			else return _loader;		}				public function get bitmap():Bitmap {			if(loaded) {				if(_url != null) { 					try {						return _loader.content as Bitmap;					} catch (error:Error) {						// no smoothing for you					}				} else { 					if(_attachment is Bitmap) return _attachment as Bitmap;				} 			}			return null;		}				public function set bitmap( b:Bitmap ) : void {			attach( b );		}				/**		 * Flex-ible source property		 */		public function set source( src:*):void {					if(_source==src) return;			_source = src;				if(src is Class) {				attach( new src() );			} else if (src is DisplayObject) {				attach( src );			} else if( src is String) {				load( src );			}		}				public function get source():* {			return _source;		}			}}