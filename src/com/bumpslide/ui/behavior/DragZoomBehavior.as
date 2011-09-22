﻿/**
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

package com.bumpslide.ui.behavior {	import com.bumpslide.events.DragEvent;	import com.bumpslide.tween.FTween;	import com.bumpslide.ui.IZoomable;		import flash.display.InteractiveObject;	import flash.geom.Point;	import flash.utils.Dictionary;		/**	 * Provides FTween-powered pan/zoom control over IZoomable content	 * 	 * This is used by the ZoomPanel	 * 	 * @author David Knape	 */	public class DragZoomBehavior {				// track instances locally to aid in event management		static private var _targets:Dictionary = new Dictionary(true);				// the drag source and the zoomable content		private var dragTarget:InteractiveObject;		private var zoomContent:IZoomable;				// target states for tweens		private var _targetZoom:Number = 1;		private var _targetPanX:Number=0;		private var _targetPanY:Number=0;						private var panStart:Point;				// public options		public var tweenEaseFactor:Number  = .15;		public var tweenUpdateDelay:Number = 30;		public var tweenOnPan:Boolean = false;		public var tweenOnZoom:Boolean = false;				public var zoomFactor:Number;		private var _maxZoom:Number=8;		private var _minZoom:Number=.125;		/**		 * Attaches behavior to a button		 */		static public function init( drag_target:InteractiveObject, zoomable_content:IZoomable ):DragZoomBehavior {			return new DragZoomBehavior( drag_target, zoomable_content );			}				/**		 * Removes behavior from a button		 */		static public function destroy(target:InteractiveObject) : void {			if(_targets[target]!=null) (_targets[target] as DragZoomBehavior).remove();		}						/**		 * Adds drag and zoom behavior to a display object and zoomable content		 */		function DragZoomBehavior( drag_target:InteractiveObject, zoomable_content:IZoomable ) {								zoomFactor = Math.sqrt( Math.SQRT2 );						DragZoomBehavior.destroy( drag_target );						dragTarget = drag_target;			zoomContent = zoomable_content;					_targets[dragTarget] = this;						DragBehavior.init( drag_target, null, false );						drag_target.addEventListener( DragEvent.EVENT_DRAG_START, handleDragStart);			drag_target.addEventListener( DragEvent.EVENT_DRAG_MOVE, handleDrag);		}		/**		 * removes event listeners, thus removing behavior		 */		public function remove() : void {						DragBehavior.destroy( dragTarget );						delete _targets[dragTarget];		}				private function handleDragStart(event:DragEvent):void {			if(event.target!=event.currentTarget) return;			panStart = new Point( zoomContent.panX, zoomContent.panY );		}		private function handleDrag(event:DragEvent):void {			if(event.target!=event.currentTarget) return;			_targetPanX = panStart.x - (event.delta.x/zoomContent.zoom);			_targetPanY = panStart.y - (event.delta.y/zoomContent.zoom);						panTo( _targetPanX, _targetPanY, tweenOnPan);		}				public function panTo( panX:Number, panY:Number, tween:Boolean=true, easeFactor:Number=-1  ) : void {			if(tween) {				panToX( panX, easeFactor);				panToY( panY, easeFactor);			} else {				FTween.stopTweening( zoomContent, 'panX');				FTween.stopTweening( zoomContent, 'panY');				zoomContent.panX = _targetPanX = panX;				zoomContent.panY = _targetPanY = panY;			}		}				public function zoomTo( z:Number, tween:Boolean=true, easeFactor:Number=-1 ) : void {			_targetZoom = Math.round( z / .01 ) * .01;			_targetZoom = Math.min( maxZoom, Math.max( minZoom, _targetZoom ));			//trace('targetZoom='+_targetZoom);			if(tween) {				FTween.ease( zoomContent, 'zoom', _targetZoom, easeFactor==-1 ? tweenEaseFactor : easeFactor, {minDelta:.005, updateDelay: tweenUpdateDelay});			} else {				FTween.stopTweening( zoomContent, 'zoom' );				zoomContent.zoom = _targetZoom;			}		}				public function panToX( x:Number, easeFactor:Number=-1 ) : void {			_targetPanX = x;			FTween.ease( zoomContent, 'panX', _targetPanX, easeFactor==-1 ? tweenEaseFactor : easeFactor, {minDelta:.0002, updateDelay: tweenUpdateDelay});					}				public function panToY( y:Number, easeFactor:Number=-1 ) : void {			_targetPanY = y;			FTween.ease( zoomContent, 'panY', _targetPanY, easeFactor==-1 ? tweenEaseFactor : easeFactor, {minDelta:.0002, updateDelay: tweenUpdateDelay});		}				public function zoomIn() : void {			if(!FTween.isTweening(zoomContent, 'zoom')) {				_targetZoom = zoomContent.zoom;			}						_targetZoom*=zoomFactor;						zoomTo( _targetZoom, tweenOnZoom);		}				public function zoomOut() : void {			if(!FTween.isTweening(zoomContent, 'zoom')) {				_targetZoom = zoomContent.zoom;			}						_targetZoom/=zoomFactor;			zoomTo( _targetZoom, tweenOnZoom );		}				public function panRight(amount:Number=64):void {			if(!FTween.isTweening(zoomContent, 'panX')) {				_targetPanX = zoomContent.panX;			}						_targetPanX+=amount/zoomContent.zoom;			panToX( _targetPanX );		}				public function panLeft(amount:Number=64):void {			if(!FTween.isTweening(zoomContent, 'panX')) {				_targetPanX = zoomContent.panX;			}						_targetPanX-=amount/zoomContent.zoom;			panToX( _targetPanX );		}				public function panDown(amount:Number=64):void {			if(!FTween.isTweening(zoomContent, 'panY')) {				_targetPanY = zoomContent.panY;			}						_targetPanY+=amount/zoomContent.zoom;			panToY( _targetPanY );		}				public function panUp(amount:Number=64):void {			if(!FTween.isTweening(zoomContent, 'panY')) {				_targetPanY = zoomContent.panY;			}						_targetPanY-=amount/zoomContent.zoom;			panToY( _targetPanY);		}				public function get targetZoom():Number {			return _targetZoom;		}				public function get maxZoom():Number {			return _maxZoom;		}				public function set maxZoom(maxZoom:Number):void {			_maxZoom = maxZoom;			zoomTo(_targetZoom, false);		}				public function get minZoom():Number {			return _minZoom;		}				public function set minZoom(minZoom:Number):void {			_minZoom = minZoom;			zoomTo(_targetZoom, false);		}	}}