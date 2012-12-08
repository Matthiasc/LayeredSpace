package be.dreem.ui.layeredSpace.objects {
	import be.dreem.ui.layeredSpace.data.Projection2D;
	import be.dreem.ui.layeredSpace.geom.Point3D;
	/**
	 * ...
	 * @author Matthias Crommelinck
	 */
	public class CameraObject extends SpaceObject {
		
		public var screen:ScreenObject;
		
		public static const ANGLE_MAX:Number = 170;
		public static const ANGLE_MIN:Number = 10;
		
		private var _nAngle:Number = 45;
		
		private var _nFocusDistance:Number = 1000;
		
		private var _nViewingDistanceStart:Number = 100;
		private var _nViewingDistanceEnd:Number = 0;
		
		public var effects:Effects;
		
		public function CameraObject() {
			effects = new Effects();
		}
		
		/**
		 * will map the 3d points of the layer into 2D
		 * @param	layer
		 * @return	the projection data;
		 */
		public function project(layer:VisualObject):Projection2D {
			throw new Error("CameraObject: Override projectLayer function!");
			return null;
		}
		
		/**
		 * method that checks if the visual can be seen, for whatever reason you might implement, based on the CameraObject properties
		 * (if a layer is way behind the camera, you might not want to project it cause you won't see it anyway)
		 * @param	visual
		 * @return	
		 */
		public function seesVisual(visual:VisualObject):Boolean {
			throw new Error("CameraObject: Override canSeeVisual function!");
			return false;
		}
		
		public function seesPoint(p:Point3D):Boolean {
			throw new Error("CameraObject: Override seesPoint function!");
			return false;
		}
		
		public function focusToObject(object:SpaceObject):SpaceObject {			
			focusDistance = z - object.z;			
			return object;
		}
		
		public function focusToPoint(p:Point3D):Point3D {			
			focusDistance = z - p.z;			
			return p;
		}
		
		/**
		 * The focus distance
		 */
		public function get focusDistance():Number{
			return _nFocusDistance;
		}
		
		public function set focusDistance(n:Number):void{
			//negative focus distance is stupid, right? :/
			_nFocusDistance = (n < 0 ) ? 0 : n;
		}
		
		/**
		 * the angle of the camera, the default is set at 45 degrees
		 */
		public function get angle():Number{
			return _nAngle;
		}
		
		/**
		 * the angle of the camera, the default is set at 45 degrees
		 */
		public function set angle(n:Number):void{
			if(n > ANGLE_MAX){
				_nAngle = ANGLE_MAX;
			}
			else if(n < ANGLE_MIN){
				_nAngle = ANGLE_MIN;
			}else{
				_nAngle = n;
			}
		}	
		
		/**
		 * The z distance from the camera to the point from wich layers can be seen
		 * Example: If viewingDistanceStart is set at 100, all layers that are closer to the camera then 100 will not be seen.
		 */
		public function get viewingDistanceStart():Number { return _nViewingDistanceStart; }
		
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
		 * If set 0 the camera will see without restriction.
		 * Example: If viewingDistanceEnd is set at 5000, all layers that are further away then 5000 will not be seen.
		 */
		public function get viewingDistanceEnd():Number { return _nViewingDistanceEnd; }
		
		/**
		 * The z distance from the camera to the point from wich layers can not be seen.
		 * The viewingDistanceEnd will always be greater then the viewingDistanceStart
		 * If set 0 the camera will see without restriction.
		 * Example: If viewingDistanceEnd is set at 5000, all layers that are further away then 5000 will not be seen.
		 */
		public function set viewingDistanceEnd(n:Number):void {
			_nViewingDistanceEnd = (n < _nViewingDistanceStart) ? _nViewingDistanceStart : n;
		}
		
		override public function toString():String {
			return "CameraObject: x:" + x + " y:" + y + " z:" + z + " rotation:" + rotation + " angle:" + angle + " focusDistance:" + focusDistance;
		}
	}
}