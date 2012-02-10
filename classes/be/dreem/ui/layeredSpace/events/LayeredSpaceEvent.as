/**
* Copyright (c) 2009 Matthias Crommelinck
* 
* Permission is hereby granted, free of charge, to any person
* obtaining a copy of this software and associated documentation
* files (the "Software"), to deal in the Software without
* restriction, including without limitation the rights to use,
* copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the
* Software is furnished to do so, subject to the following
* conditions:
* 
* The above copyright notice and this permission notice shall be
* included in all copies or substantial portions of the Software.
* 
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
* OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
* NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
* HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
* OTHER DEALINGS IN THE SOFTWARE.
*/

/**
* @author Matthias Crommelinck
*/

package be.dreem.ui.layeredSpace.events {
	
	import be.dreem.ui.layeredSpace.objects.*;
	
	import flash.events.Event;
	
	public class LayeredSpaceEvent extends Event {
		
		public static const LAYER_ADDED:String = "layerAdded";
		public static const LAYER_REMOVED:String = "layerRemoved";
		
		private var _layer:SpaceObject;
		
		public function LayeredSpaceEvent(type:String, layer:SpaceObject = null, bubbles:Boolean=false, cancelable:Boolean=false) { 
			super(type, bubbles, cancelable);
			_layer = layer;
			
		} 
		
		public override function clone():Event { 
			return new LayeredSpaceEvent(type, layer, bubbles, cancelable);
		} 
		
		public override function toString():String { 
			return formatToString("LayeredSpaceEvent", "type", "layer", "bubbles", "cancelable", "eventPhase"); 
		}
		
		//GETTERS
		
		public function get layer():SpaceObject { return _layer; }
		
	}
	
}