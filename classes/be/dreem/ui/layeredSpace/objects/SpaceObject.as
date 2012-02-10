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

package be.dreem.ui.layeredSpace.objects {
	
	/*
	* The base class: basic 3D space object
	*/ 
	
	import be.dreem.ui.layeredSpace.data.Projection2D;
	import be.dreem.ui.layeredSpace.geom.Point3D;
	import be.dreem.ui.layeredSpace.events.LayerEvent;
	
	import flash.events.EventDispatcher;
	
	public class SpaceObject extends EventDispatcher {
		
		/**
		 * The x position of the Layer
		 */
		public var x:Number = 0;
		/**
		 * The y position of the Layer
		 */
		public var y:Number = 0;
		/**
		 * The z position of the Layer
		 */
		public var z:Number = 0;
		/**
		 * The scale of the Layer
		 */
		public var scale:Number = 1;
		/**
		 * The rotation of the Layer
		 */		
		private var _nRot:Number = 0;
		
		//CONSTRUCTOR
		
		function SpaceObject():void {
			
		};
		
		//GETTERS
		
		/**
		 * The position of the Layer
		 */
		public function get position():Point3D{
			return new Point3D(x, y, z);
		}
		/**
		 * The rotation of the Layer
		 */
		public function get rotation():Number{
			return _nRot;
		}
		
		//SETTERS
		
		/**
		 * The position of the Layer
		 */
		public function set position(p:Point3D):void{
			x = p.x;
			y = p.y;
			z = p.z;
		}
		
		/**
		 * The rotation of the Layer
		 */
		public function set rotation(n:Number):void{
			_nRot = n%360;
		}
		
		
	}	
}
