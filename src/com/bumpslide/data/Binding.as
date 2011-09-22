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

package com.bumpslide.data {	import com.bumpslide.events.ModelChangeEvent;	import flash.events.IEventDispatcher;	import flash.utils.Dictionary;	/**     * Minimal one-way weak-referenced binding implementation for AS3     *      * This class represents a binding between a source object and a target.       * The source object is usually a BindableModel, but it can be anything     * that dispatches ModelChangeEvents.     *      * var binding:Binding = new Binding( state, 'section', mainView, onSectionChange );     *      * @author David Knape     */    public class Binding {    	    	    	// keep bindings in memory as long as targets are around		static public var bindings:Dictionary = new Dictionary( true );					   	private var _source				: IEventDispatcher;		private var _property			: String;		private var _target				: Object;		private var _targetSetter		: String;		private var _targetFunction     	: Function;		private var _bound : Boolean = false;				public function get property () : String {			return _property;		}						public function get target () : Object {			return _target;		}				public function get bound () : Boolean {			return _bound;		}				function Binding(source:IEventDispatcher, property:String, target:Object, setterOrFunction:*=null  ) {						// if no callback setter name or function is provided, call the			// setter with name the same as the key we are watching			if(setterOrFunction==null) setterOrFunction=property;						if(source==null || property==null || setterOrFunction==null)  {								trace('Unable to create ModelBinding from "'+property+'" to '+setterOrFunction);					return;			} 							_source = source;			_property = property;			_target = target;					if(typeof(setterOrFunction)=='function') {				_targetSetter = null;				_targetFunction = setterOrFunction as Function;							} else {				_targetSetter = setterOrFunction as String;				_targetFunction = null;			}							_bound = true;						// bootstrap to initial state			executeBinding( _source[_property] );						//trace('Binding '+property+' to '+setterOrFunction );						// listen to value change events			// use weak keys so we don't have to worry about unbinding			// this will stay active as long as this binding exists			_source.addEventListener( ModelChangeEvent.PROPERTY_CHANGED, onChangeEvent, false, 0, true );							// however, we need to make sure binding object sticks around, so we			// store binding in bindings dictionary to keep in memory as long as target exists			// note use of weak keys in Dictionary			if(bindings[target]==null) bindings[target] = new Array();			(bindings[target] as Array).push( this );		}						public function unbind() : void {			//trace('Removing Binding for '+property+' from '+_target);			_source.removeEventListener( ModelChangeEvent.PROPERTY_CHANGED, onChangeEvent, false );			_bound = false;		}					private function onChangeEvent( e:ModelChangeEvent ) : void {			if(e.property==_property) {				executeBinding(e.newValue, e.oldValue);			}		}				private function executeBinding(newValue:*, oldValue:*=null) : void{						if(_target==null && (_targetSetter!=null || _targetFunction==null) ) {				//trace('Unbinding orphaned ModelBinding');				// notify model (so it can remove this binding from it's list)				//model.unregisterBinding( this );				unbind();			} else if(_targetSetter!=null) {								// callback as setter 				// if target is text (as in TextField.text, 				// let's go ahead and cast as string to avoid errors				if(_targetSetter=='text') {					newValue = String(newValue);				}								try {					// apply change to setter only if necessary					// catch cases where there is a write-only setter				   	if(target[_targetSetter]==newValue) {						return;					}				} catch (e:ReferenceError) {  					//trace('[Binding] caught reference error while reading a write-only property');				}				target[_targetSetter] = newValue;    							} else if (_targetFunction!=null) {												// callback as function								// Try passing new and old values, then just new value, then nothing.				// We are just catching argument errors - any other errors should be 				// handled by the developer (any better way to do this in AS3?)								try { 					_targetFunction.call( _target, newValue, oldValue ); 				} catch (e1:ArgumentError) {					try { 						_targetFunction.call( _target, newValue ); 					} catch (e2:ArgumentError) {					   	_targetFunction.call( _target ); 					}				}			}		}				static public function get totalBindings () : int {			var total:int = 0;			for each( var a:Array in bindings ) {				total+=a.length;			}			return total;		}						static public function create( source:IEventDispatcher, property:String, target:Object, setterOrFunction:*=null  ) : Binding {			return new Binding( source, property, target, setterOrFunction );		}				static public function remove( target:Object, property:String=null ) : void {			if(bindings[target]!=null) {				for each (var b:Binding in bindings[target]) {
					if(b.property==property || property==null) {						b.unbind();
					}				}				delete bindings[target];			}		}    	    }}