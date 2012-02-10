package be.dreem.ui.layeredSpace.cameras {
	import be.dreem.ui.layeredSpace.data.Projection2D;
	import be.dreem.ui.layeredSpace.geom.Point3D;
	import be.dreem.ui.layeredSpace.objects.CameraObject;
	import be.dreem.ui.layeredSpace.objects.VisualObject;
	
	/**
	 * ...
	 * @author Matthias Crommelinck
	 */
	public class IsoMetricCamera extends CameraObject {
		
		private const TORADIANS:Number = Math.PI / 180;
		private const TODEGREES:Number = 180 / Math.PI;
		
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
		public function IsoMetricCamera(){
			super.position = DEFAULT_POSITION;
		}
		
		override public function project(layer:VisualObject):Projection2D {
				
				var projection:Projection2D = new Projection2D();			
				
				var x:Number = layer.x - x;
				var y:Number = layer.y - y;				
				projection.zDepth = z - layer.z;
				var angleRatio:Number = angle / 45;
				var depthRatio:Number = 1;
				var s:Number = Math.sin( -rotation * TORADIANS);
				var c:Number = Math.cos( -rotation * TORADIANS);
				
				projection.x = -(y * s - x * c) * angleRatio * depthRatio;									
				projection.y = (y * c + x * s) * angleRatio * depthRatio;				
				projection.rotation =  layer.rotation - rotation;
				
				if (roundPoints) {
					projection.x = Math.round(projection.x);
					projection.y = Math.round(projection.y);
				}
				
				projection.scale = angleRatio;
				
				return projection;
		}
		
		override public function seesVisual(layer:VisualObject):Boolean {
			var depth:Number = z - layer.z;
			return (depth > viewingDistanceStart && ((depth < viewingDistanceEnd) || (viewingDistanceEnd == 0)))
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