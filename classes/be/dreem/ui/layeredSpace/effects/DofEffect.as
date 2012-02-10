package be.dreem.ui.layeredSpace.effects {
	import be.dreem.ui.layeredSpace.data.*;
	import be.dreem.ui.layeredSpace.objects.*;
	import flash.filters.*;
	
	/**
	 * ...
	 * @author Matthias Crommelinck
	 */
	public class DofEffect extends FilterEffect {
		
		/**
		 * the start zDepth of the Dof
		 */
		private var _nStartDistance:Number = 0;
		
		public var value:Number = 5; 
		public var quality:int = 1;
		
		public function DofEffect() {
			
		}
		
		override public function render(visualObject:VisualObject, projection:Projection2D, camera:CameraObject):BitmapFilter {
		
			//DOF
			var nBlur:Number = (Math.abs(camera.focusDistance - projection.zDepth - _nStartDistance) * value * .001);
			
			//TODO: now the container filters are overrided with just one BlurFilter
			//visualObject.container.filters = [new BlurFilter(nBlur, nBlur, quality)];
			
			return new BlurFilter(nBlur, nBlur, quality);
		}
		
		
		public function set startDistance(n:Number):void {
			_nStartDistance = (n < 0) ? 0 : n;
		}
		
		//public function get useFog():Boolean { return _bUseFog; }
		
		public function get startDistance():Number { return _nStartDistance; }
	}

}