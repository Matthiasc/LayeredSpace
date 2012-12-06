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
package be.dreem.ui.layeredSpace.cameras {
	
	import be.dreem.ui.layeredSpace.data.*;
	import be.dreem.ui.layeredSpace.geom.*;
	import be.dreem.ui.layeredSpace.layers.VisualLayer;
	import be.dreem.ui.layeredSpace.objects.*;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	
	public class StandardCamera extends CameraObject {
		
		private const TORADIANS:Number = Math.PI / 180;
		private const TODEGREES:Number = 180 / Math.PI;
		
		/**
		 * DISTANCE_RATIO, the relation between point positioning and Distance (2 points seperated 10 pixels away on the 3d x axis will result in a 10 pixels distances on the 2d x axis if the camera is 1000 pixels away);
		 */
		private const DISTANCE_RATIO:Number = 1000;
		
		/**
		 * round the 2D projected x and y values of the layers
		 */
		public var roundPoints:Boolean = false;
		
		
		public static const DEFAULT_POSITION:Point3D = new Point3D(0, 0, 1000);
		
		private var _nViewingDistanceStart:Number = 0;
		private var _nViewingDistanceEnd:Number = 0;
		
		
		/**
		 * The source/layeredSpace to let the camera capture from
		 */
		
		public function StandardCamera(){
			super.position = DEFAULT_POSITION;
		}
		
		override public function project(layer:VisualObject):Projection2D {
				
				var projection:Projection2D = new Projection2D();			
				
				var x:Number = layer.x - x;
				var y:Number = layer.y - y;				
				projection.zDepth = z - layer.z;
				var angleRatio:Number = 45/angle;
				var depthRatio:Number = DISTANCE_RATIO / projection.zDepth;
				var s:Number = Math.sin( -rotation * TORADIANS);
				var c:Number = Math.cos( -rotation * TORADIANS);
				
				projection.x = -(y * s - x * c) * angleRatio * depthRatio;									
				projection.y = (y * c + x * s) * angleRatio * depthRatio;				
				projection.rotation =  layer.rotation - rotation;
				
				if (roundPoints && !layer.ignoreRoundPoints) {
					projection.x = Math.round(projection.x);
					projection.y = Math.round(projection.y);
				}
				
				projection.scale = angleRatio * layer.scale * layer.scaleDistance / projection.zDepth;
				
				return projection;
		}
		
		/**
		 * a check to see it it's worthy to project the layer or not. 
		 * @param	layer
		 * @return
		 */
		override public function seesVisual(layer:VisualObject):Boolean {
			var depth:Number = z - layer.z;
			return (depth > viewingDistanceStart && ((depth < viewingDistanceEnd) || (viewingDistanceEnd == 0)))
		}
		
		override public function seesPoint(p:Point3D):Boolean {
			//TODO: create function
			return super.seesPoint(p);
		}
		
		/*
		* GETTERS
		*/		
		
		
		/**
		 * The z distance from the camera to the point from wich layers can be seen
		 * Example: If viewingDistanceStart is set at 100, all layers that are closer to the camera then 100 will not be seen.
		 */
		public function get viewingDistanceStart():Number { return _nViewingDistanceStart; }
		
		/**
		 * The z distance from the camera to the point from wich layers can not be seen.
		 * Example: If viewingDistanceEnd is set at 5000, all layers that are further away then 5000 will not be seen.
		 */
		public function get viewingDistanceEnd():Number { return _nViewingDistanceEnd; }
		
		
		/*
		* SETTERS
		*/
		
		
		/**
		 * The z distance from the camera to the point from wich layers can be seen
		 * Example: If viewingDistanceStart is set at 100, all layers that are closer to the camera then 100 will not be seen.
		 */
		public function set viewingDistanceStart(n:Number):void {
			_nViewingDistanceStart = (n < 0) ? 0 : n;
		}
		
		/**
		 * The z distance from the camera to the point from wich layers can not be seen.
		 * The viewingDistanceEnd will always be greater then the viewingDistanceStart
		 * If set 0 the camera will see infinity.
		 * Example: If viewingDistanceEnd is set at 5000, all layers that are further away then 5000 will not be seen.
		 */
		public function set viewingDistanceEnd(n:Number):void {
			_nViewingDistanceEnd = (n < _nViewingDistanceStart) ? _nViewingDistanceStart : n;
		}
		
			
		
	}	
}
