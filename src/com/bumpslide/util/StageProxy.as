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
package com.bumpslide.util {
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Timer;	import flash.geom.Rectangle;        
	
	/**
	 * Intercepts stage resize events to enforce min/max 
	 * and provides singleton access to the stage.
	 * 
	 * @see com.bumpslide.ui.Applet for usage info
	 */
	public class StageProxy extends EventDispatcher {                                 
        
        static public const EVENT_RESIZE:String = "onStageResize";
                
        private var _maxWidth:Number = 3200;
		private var _maxHeight:Number = 1600;
        private var _minWidth:Number = 4;
		private var _minHeight:Number = 4;
        private var _width:Number = 100;
        private var _height:Number = 100;

        private var _pendingUpdate:Timer;
        
        private var _updateDelay:int = 30;        
        private var _stage:Stage;
        
        static private var instance:StageProxy;
    
        public static function getInstance() : StageProxy {
            if(instance==null) instance = new StageProxy();
            return instance;
		}
		
		public static function isInitialized () : Boolean {
			return (instance!=null && instance._stage!=null);
		}

        public function init(inStage:Stage) : void { 
            
            // If we already have a stage, don't initialize again
            if(_stage) return;
            
            _stage = inStage;                                
            
            // disable scaling and listen for size updates
            _stage.scaleMode = StageScaleMode.NO_SCALE;
            _stage.align = StageAlign.TOP_LEFT;
            _stage.stageFocusRect = false;
            _stage.addEventListener( Event.RESIZE, update );
            
            // while we're at it, let's just always init mac mousewheel
            MacMouseWheel.setup( stage ); 
            
            // trigger update
            updateNow();
        }
        
        /**
         * Triggers a stage resize event after a brief delay has elapsed
         * If a previous update was pending, it will be canceled
         */
        public function update(e:Event=null) : void  {
            Delegate.cancel( _pendingUpdate );
            var delay:int = (e==null) ? Math.max( 100, updateDelay) : updateDelay;
            _pendingUpdate = Delegate.callLater( delay, updateNow );
        }
           
        /**
         * Actual stage
         */
        public function get stage () : Stage {
            return _stage;
        }
        
        /**
         * Constrained stage width
         */
        public function get width () : Number {
            return _width;
        }
        
        /**
         * Constrained stage height
         */
        public function get height () : Number {
            return _height;
        }
        
        public function updateNow(e:Event=null):void 
        {   
        	Delegate.cancel( _pendingUpdate ); 
        	
        	if(!stage) return;
        	
            // constrain stageHeight and stageWidth to min and max dimensions
            _height = Math.min( Math.max( stage.stageHeight, minHeight), maxHeight );
            _width = Math.min( Math.max( stage.stageWidth, minWidth), maxWidth );
            
            //trace('[StageProxy] - Event.RESIZE - '+_width+'x'+_height);
            dispatchEvent(new Event(Event.RESIZE));
        }  
        		
		public function get updateDelay():int {
			return _updateDelay;
		}
		
		public function set updateDelay(updateDelay:int):void {
			_updateDelay = updateDelay;
			update();
		}
		
		public function setBounds( minwidth:Number, minheight:Number, maxwidth:Number, maxheight:Number ) : void {
			_minWidth = minwidth;			_minHeight = minheight;			_maxWidth = maxwidth;			_maxHeight = maxheight;
			update();
		}
		
		public function get maxWidth():Number {
			return _maxWidth;
		}
		
		public function set maxWidth(maxWidth:Number):void {
			_maxWidth = maxWidth;
			update();
		}
		
		public function get minHeight():Number {
			return _minHeight;
		}
		
		public function set minHeight(minHeight:Number):void {
			_minHeight = minHeight;
			update();
		}
		
		public function get maxHeight():Number {
			return _maxHeight;
		}
		
		public function set maxHeight(maxHeight:Number):void {
			_maxHeight = maxHeight;
			update();
		}
		
		public function get minWidth():Number {
			return _minWidth;
		}
		
		public function set minWidth(minWidth:Number):void {
			_minWidth = minWidth;
			update();
		}
		
		public function getRect() : Rectangle { return new Rectangle(0,0,width,height); }
	}
}