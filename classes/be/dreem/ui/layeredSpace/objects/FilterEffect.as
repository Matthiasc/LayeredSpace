package be.dreem.ui.layeredSpace.objects {
	import be.dreem.ui.layeredSpace.data.Projection2D;
	import be.dreem.ui.layeredSpace.objects.VisualObject;
	import flash.filters.BitmapFilter;
	/**
	 * ...
	 * @author Matthias Crommelinck
	 */
	public class FilterEffect {
		
		/**
		 * enable of disable this filter
		 */
		public var enable:Boolean = true;
		
		public function FilterEffect() {
			
		}
		
		/**
		 * render the effect
		 * @param	visualObject
		 * @param	projection
		 * @return	true if the layer is visible, false if not;
		 */
		public function render(visualObject:VisualObject, projection:Projection2D, camera:CameraObject):BitmapFilter {
			throw new Error("Effect: override render method");
			return null;
		}
	}

}