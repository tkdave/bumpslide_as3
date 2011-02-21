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

package com.bumpslide.ui {	import com.bumpslide.data.Binding;	import com.bumpslide.data.IBindable;	import com.bumpslide.data.constant.Position;	import com.bumpslide.events.ModelChangeEvent;	import com.bumpslide.events.UIEvent;	import com.bumpslide.ui.skin.ISkin;	import com.bumpslide.ui.skin.ISkinnable;	import com.bumpslide.util.Align;	import com.bumpslide.util.Delegate;	import flash.display.BlendMode;	import flash.display.DisplayObject;	import flash.display.Shape;	import flash.events.Event;	/**	 * Universal Base Class for UI Components	 * 	 * This class extends BaseClip by adding validation/update routines as well as	 * a basic IResizable and IBindable implementation.	 * 		 * @author David Knape	 */	 		// notifies listenerers that we've been redrawn	[Event(name="redraw",type="com.bumpslide.events.UIEvent")]	// fired after mxml children are created, or 1ms after constructor has finished	[Event(name="creationComplete",type="flash.events.Event")]	// MXML Default property	[DefaultProperty("children")]	public class Component extends BaseClip implements IResizable, IBindable, ISkinnable 	{
		public static const EVENT_DRAW:String = "redraw";		public static const EVENT_CREATION_COMPLETE:String = "creationComplete";

		public static const EVENT_SIZE_CHANGED:String = "sizeChanged";

		// whether or not to wait a frame before drawing updates		public var delayUpdate:Boolean = true;
		// whether or not to round x/y coordinates automatically		public var roundedPosition:Boolean = true;
		// change types (aka. validation constants) 		protected static const VALID_SIZE:String = "validSize";  // size has changed		protected static const VALID_DATA:String = "validData";  // data has changed
				protected static const VALID_SKIN_STATE : String = "validSkinState";
						// map of invalidation flags		private var _invalidated:Array;
		// explicit height and width		private var _width:Number = -1;		private var _height:Number = -1;		private var _minWidth:Number = 0;		private var _minHeight:Number = 0;		// current skin state		protected var _skinState:String = "default";		// previous skin state		private var _previousSkinState:String = null;		// skin class to create		private var _skinClass:Class;		// attached skin		private var _skin:DisplayObject;
		// true when we are drawing		protected var _drawing:Boolean;				private var _alignH:String;		private var _alignV:String;
		private var _showBounds:Boolean = false;		protected var boundsShape:Shape;				/**		 * Initialize size and scale, calls addChildren and triggers validation		 */		override protected function init():void 		{			super.init();						initSize();        				addChildren();						invalidate();			callLater(1, postConstruct);			addEventListener( Component.EVENT_DRAW, handleChildRedraw);		}		// TODO: This stuff needs to go in a container class		protected function handleChildRedraw(event:UIEvent):void 		{						if(contains(DisplayObject(event.target)) && !_drawing) {				layoutChildren();			}
		}
				/**		 * Called once constructor has finished executing		 * 		 * Component may or may not be 'validated'		 */		protected function postConstruct():void 		{			log('creation complete');			dispatchEvent(new Event(EVENT_CREATION_COMPLETE));		}				/**		 * Initializes height and width properties to match measured height and width		 * of component as it was found on the stage (in flash).  		 * 		 * Accomodates height/width issue with rotated components.		 * 		 * Restores scaleX and scaleY to 1.0 		 */		protected function initSize():void 		{						// hack for components that are rotated on the stage			// (only handles those rotated by increments of 90 degrees)			// to account for issues related to height/width of rotated components			var rot:Number = (rotation < 0) ? rotation + 360 : rotation;			var rotated:Boolean = ( Math.round((rot) / 90) * 90 % 180 ) == 90;											// use placed height/width by default and reset scale to 100%			if(_width == -1) {								_width = rotated ? super.height : super.width;				invalidate(VALID_SIZE);			}			if(_height == -1) {				_height = rotated ? super.width : super.height;				invalidate(VALID_SIZE);			}						scaleX = scaleY = 1;		}				/**		 * Removes all listeners, prepares for destruction		 */		override public function destroy():void 		{			super.destroy();			removeEventListener(Event.ENTER_FRAME, updateNow);			}		
				/**		 * Adds and Initializes Child Components		 * 		 * This method should be overriden in your subclass.		 */		protected function addChildren():void 		{					}				/**		 * Called after invalidation delay, but before draw		 * 		 * This is a good place to perform calculations, update derived properties, and prepare data for display.		 */		protected function commitProperties():void 		{		}				/**		 * Updates the  Display List 		 * 		 * By default, this is where we call the draw method on the attached skin.		 * This method can be overriden in your subclass to do custom layout and rendering.		 */		protected function draw():void 		{			// update skin			if(skin!=null) {
				
				if(hasChanged(VALID_SKIN_STATE) && (skin is ISkin)) {
					
					// render the skin state
					(skin as ISkin).renderSkin( skinState );
					
					// now, invalidate stage and wait for render event
					// so we can update content inside the frames of movieclip skins
					if (stage) {
						stage.addEventListener( Event.RENDER, handleStageRender );
						stage.invalidate();
					} else {
						Delegate.onEnterFrame( render );
					}
					validate( VALID_SKIN_STATE );
				}
				
				if(hasChanged(VALID_SIZE)) {
					if(skin is IResizable) {
						(skin as IResizable).setSize( width, height );
					} else {
						skin.width = width;
						skin.height = height;
					}
				}
				
							}		}
		
		protected function handleStageRender( e:Event ):void
		{
			if(stage) {
				stage.removeEventListener( Event.RENDER, handleStageRender );
			}
			render();
		}
		
		/**
		 * Called on the first render event after a skin state change has been applied
		 * 
		 * If using movieclip frames, this is a good time to update the content in that frame.
		 * 
		 * By default, we update size. Use case for this is Buttons with flash movieclips as skin states.
		 */
		protected function render():void {
			invalidate(VALID_SIZE);
			updateNow();
		}				/**		 * Send the EVENT_DRAW UIEvent		 */		protected function notifyDrawn(event:Event = null):void 		{			sendEvent(Component.EVENT_DRAW);		}
				/**		 * Triggers an update/draw on the next frame		 */		protected function invalidate(change_type:String = null, allow_validation_during_draw:Boolean=false):void 		{			if(_drawing && !allow_validation_during_draw) {				//trace("You shouldn't be invalidating during a draw cycle.");				return;			}			if(change_type != null) {				// mark this change type as invalid				if(_invalidated == null) _invalidated = new Array();				_invalidated[change_type] = true;			}						if(delayUpdate || initializing) {				addEventListener(Event.ENTER_FRAME, updateNow);			} else {				updateNow();			}		}
						private function _onAddedToStage( event:Event ) : void {			removeEventListener( Event.ADDED_TO_STAGE, _onAddedToStage );			stage.invalidate();		}				/**		 * Whether or not a given change type (validation constant) has changed		 */		protected function hasChanged( changeType:String ):Boolean 		{			if(_invalidated == null) return false;			else return _invalidated[changeType] != null;		}
				/**		 * Marks a change type (validation constant) as valid		 */		protected function validate( changeType:String):void 		{			if(_invalidated != null) {				_invalidated[changeType] = null;				delete _invalidated[changeType];			}		}
				/**		 * Force instant update by calling draw(), and cancels any pending update		 */		public function updateNow( e:Event = null ):void 		{			removeEventListener(Event.RENDER, updateNow);			removeEventListener(Event.ENTER_FRAME, updateNow);						// Do we need a commitProperties hook? ignore it if you want.			commitProperties();						if(boundsShape) {				boundsShape.visible = false;			}						// call draw			_drawing = true;			draw();			_drawing = false;						layoutChildren();						if(showBounds) {				drawBounds();			}
			
			if(hasChanged(VALID_SIZE)) {
				UIEvent.send( this, EVENT_SIZE_CHANGED );
			}									validate(VALID_SIZE);			validate(VALID_DATA);			notifyDrawn();		}
		/**		 * Draw a red box representing the boundary of this clip		 * 		 * Note, this box is drawn in boundsShape.		 */		protected function drawBounds():void {						if(boundsShape==null) boundsShape = new Shape();			addChild( boundsShape );			boundsShape.blendMode = BlendMode.SUBTRACT;			boundsShape.visible = true;			boundsShape.graphics.clear();			boundsShape.graphics.lineStyle( 0, 0xDF6559, .5, true);			try {				boundsShape.graphics.drawRect(0, 0, width, height);			} catch(e:Error) {				trace(e);			}					}				/**		 * Align the children based on halign and valign props (experimental)		 */		public function layoutChildren():void 		{						// align children			for each ( var c:DisplayObject in children) {				if(c is Component) {					var comp:Component = c as Component;					var a:Array;					var al:String;					var al_offset:int;										if(comp.alignH || comp.alignV) {						//comp.updateNow();					}										if(comp.alignH) {						a = comp.alignH.split(' ');						al = a[0];						al_offset = parseInt(a[1]);						//trace( al, al_offset, width, comp.width );						switch(al) {							case Position.RIGHT: Align.right( comp, width + al_offset, comp.width  ); break;							case Position.CENTER: Align.center( comp, width + al_offset, comp.width ); break;						}					}					if(comp.alignV) {						a = comp.alignV.split(' ');						al = a[0];						al_offset = parseInt(a[1]);						//trace( al, al_offset, height, comp.height );						switch(al) {							case Position.BOTTOM: Align.bottom( comp, height + al_offset, comp.height ); break;							case Position.MIDDLE: Align.middle( comp, height + al_offset, comp.height ); break;						}					}				}			}
		}
				/**		 * Moves the component to the specified position.		 * 		 * @param xpos the x position to move the component		 * @param ypos the y position to move the component		 */		public function move(xpos:Number, ypos:Number):void 		{			x = xpos;			y = ypos;		}
				//------------------------------//		// IResizable Implementation    //		//------------------------------//				/**		 * Sets the size of the component and triggers instant redraw if size needs to change. 		 * 		 * @param w The width of the component.		 * @param h The height of the component.		 */		public function setSize( w:Number, h:Number ):void 		{			width = w;			height = h;				if(hasChanged(VALID_SIZE)) updateNow();		}
				//------------------------------//		// IBindable Implementation     //		//------------------------------//				/**		 * Bind to a property on this component (only certain properties are bindable)		 */		public function bind( property:String, target:Object, setterOrFunction:*= null ):Binding 		{			return Binding.create(this, property, target, setterOrFunction);		}				/**		 * Remove all bindings from this component to the target object		 */		public function unbind( target:Object ):void 		{			Binding.remove(target);		}				/**		 * Dispatch ModelChangeEvent for a property to execute binding		 */		protected function sendChangeEvent( propertyName:String, value:*, oldValue:*= null):void 		{			dispatchEvent(new ModelChangeEvent(this, propertyName, value, oldValue));		}				/******************************		 * ISkinnable Implementation		 ******************************/				/**		 * Current skin state		 */		public function get skinState():String {			return _skinState;		}						public function set skinState(s:String):void {			if(s == _skinState) return;			_previousSkinState = _skinState;			_skinState = s;			invalidate(VALID_SKIN_STATE);
			invalidate(VALID_SIZE);		}				public function get previousSkinState():String {			return _previousSkinState;		}				/**		 * Skin Class		 */		public function get skinClass():Class {			return _skinClass;		}						public function set skinClass(c:Class):void {			if(c == _skinClass) return;			_skinClass = c;						try {				var s:* = new skinClass();				skin = s;			} catch (e:Error) {				// If skinClass was specified via an MXML binding, 				// any errors during component construction are quietly lost				// Let's tract them out at least				trace(e, e.getStackTrace());			}		}
				/**		 * Skin Class, preferably something implementing ISkin		 */		public function get skin():DisplayObject {			return _skin;		}						public function set skin(s:DisplayObject):void {			if(s == _skin) return;						if(_skin) {				destroySkin();			}					_skin = s;
			
			if(skin is ISkin) {
				(skin as ISkin).initHostComponent(this);
			}
			
			if(skin != null) {								initSkinParts();
				
				if(skin!=this) addChildAt(skin, 0);			}						invalidate(VALID_SIZE);		}					/**		 * Register skin parts here		 * 		 * ex:		 * background = getSkinPart('background')		 */		protected function initSkinParts():void 		{			
		}				/**		 * Returns a piece of a skin		 */		protected function getSkinPart(name:String):* 		{						// look for skinPart in the skin			if(skin != null && skin.hasOwnProperty(name)) {				return skin[name];			}			return null;		}
				/**		 * Remove exisiting skin and nullify references to skin parts that were setup in initSkin		 */		protected function destroySkin():void 		{			destroyChild(_skin);			_skin = null;		}				//------------------------------//		// GETTERS / SETTERS            //		//------------------------------//				/**		 * Overrides the setter for x to always place the component on a whole pixel		 * 		 * This behavior can be disabled by setting the 'roundedPosition' property to false		 */		override public function set x(value:Number):void {			super.x = roundedPosition ? Math.round(value) : value;		}				/**		 * Overrides the setter for y to always place the component on a whole pixel.		 * 		 * This behavior can be disabled by setting the 'roundedPosition' property to false		 */		override public function set y(value:Number):void {			super.y = roundedPosition ? Math.round(value) : value;		}				/**		 * Overrides the 'enabled' setter to also enable mouse access		 * to children.  Note, that the Button class has it's own implementation		 * that works a little differently.		 */		override public function set enabled( isEnabled:Boolean ):void {			super.enabled = isEnabled;			mouseEnabled = isEnabled;			// let buttons handle their own mouse children			if(!(this is Button)) mouseChildren = isEnabled;     			sendChangeEvent('enabled', isEnabled, !isEnabled);			invalidate();		}				/**		 * Sets/gets the width of the component.		 */		override public function set width(w:Number):void {			if(w == _width || isNaN(w)) return;			_width = w;			invalidate(VALID_SIZE);		}		/**		 * Width constrained to minWidth		 */		[Bindable(name='sizeChanged')] 
		override public function get width():Number {			if(_width<=0) return Math.max( super.width, minWidth);
			else return Math.max(_width, minWidth);		}		/**		 * Sets/gets the height of the component.		 */		override public function set height(h:Number):void {			if(h == _height || isNaN(h)) return;			_height = h;			invalidate(VALID_SIZE);		}				/**		 * Height constrained to minHeight		 */				[Bindable(name='sizeChanged')]
		override public function get height():Number {
			if(_height<=0) return Math.max(super.height, minHeight);			else return Math.max(_height, minHeight); 		}				/**		 * Measured height as returned by DisplayObject.height		 */		public function get actualHeight():Number {			return super.height;		}				/**		 * Measured width as returned by DisplayObject.width		 */		public function get actualWidth():Number {			return super.width;		}				/**		 * MXML DefaultProperty, receieves references to classes added as child nodes 		 * after this component has been initialized		 */		public function set children(display_objects:Array):void {			for each(var o:* in display_objects) {				var child:DisplayObject = (o as DisplayObject);				if(child != null) {					// add to the display list					addChild(child as DisplayObject);										// give reference to parent class 					// so we can use for skinning 					try { 						this[child['id']] = child; 					} catch (e:Error) {					} // fail silently				} 			}		}					/**		 * Array of all children on the display list, not just those added via the children setter		 */		public function get children():Array {			var a:Array = [];			for( var i:int = 0;i < numChildren;i++) {				a.push(getChildAt(i));			}			return a;		}				public function get minWidth():Number {			return _minWidth;		}				public function set minWidth(minWidth:Number):void {			_minWidth = minWidth;			invalidate();		}				public function get minHeight():Number {			return _minHeight;		}				public function set minHeight(minHeight:Number):void {			_minHeight = minHeight;			invalidate();		}				/**		 * Unconstrained width		 */		public function get explicitWidth():Number {			return _width;		}				/**		 * Unconstrained height		 */		public function get explicitHeight():Number {			return _height;		}						public function get alignH():String {			return _alignH;		}						public function set alignH(position:String):void {			_alignH = position;			invalidate();		}						public function get alignV():String {			return _alignV;		}						public function set alignV(position:String):void {			_alignV = position;			invalidate( );		}						public function get showBounds():Boolean {			return _showBounds;		}						public function set showBounds(showBounds:Boolean):void {			_showBounds = showBounds;			invalidate();		}	}}