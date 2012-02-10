package be.dreem.ui.layeredSpace.objects {
	import be.dreem.ui.layeredSpace.data.Projection2D;
	import flash.filters.BitmapFilter;
	/**
	 * ...
	 * @author Matthias Crommelinck
	 */
	public class Effects {
		
		private var _a:Array;
		
		public function Effects() {
			_a = new Array();
		}		
		
		internal function render(visualObject:VisualObject, projection2D:Projection2D, camera:CameraObject):Array {
			
			//var bVisible = true;
			var filterCollection:Array = new Array();
			var bf:BitmapFilter;
			
			for (var i:int = 0; i < _a.length; i++)
				if (FilterEffect(_a[i]).enable) {
					bf = FilterEffect(_a[i]).render(visualObject, projection2D, camera);
					if(bf)
						filterCollection.push(bf)
					//bVisible = (FilterEffect(_a[i]).render(visualObject, projection2D, camera)) ? bVisible : false;
				}
			//return bVisible;			
			return filterCollection;			
		}
		
		public function add(e:FilterEffect):FilterEffect {
			
			//check for dupes
			for (var i = 0; i < _a.length; i++) 			
				if (_a[i] as FilterEffect == e)					
					return e;
			
			_a.push(e);
			
			return e;
		}
		
		
		public function remove(e:FilterEffect):FilterEffect {
			
			for (var i = 0; i < _a.length; i++) {
				
				if (_a[i] as FilterEffect == e) {
					
					//remove effect from collection
					_a.splice(i,1);
					
					break;
				}
			}
			
			return e;
		}
		
		
		public function removeAll():void {
			_a = new Array();
		}
	}

}