package be.dreem.ui.layeredSpace.effects {
	import be.dreem.ui.layeredSpace.constants.FogModes;
	import be.dreem.ui.layeredSpace.data.*;
	import be.dreem.ui.layeredSpace.objects.*;
	import flash.display.DisplayObject;
	import flash.filters.BitmapFilter;
	import flash.filters.ColorMatrixFilter;
	/**
	 * ...
	 * @author Matthias Crommelinck
	 */
	public class FogEffect extends FilterEffect {
		
		/**
		 * Use of fog in layeredspace
		 */
		//private var _bUseFog:Boolean = false;
		
		/**
		 * ammount of fog in relation with the depth of the layer
		 * fog value of 1 will result in 1 fog at 1000px distance
		 */
		public var value:Number = .1;
		
		/**
		 * the start zDepth of the fog
		 * fogStartDepth of 1000 in combination with a layer that's 1000 units away, will result in no fog effect for that layer
		 */
		private var _nStartDistance:Number = 0;
		
		/**
		 * The type of fog beeing used
		 */
		public var fogMode:String = FogModes.TINT;
		
		/**
		 * the color of the fog. Only used in combination with FogModes.TINT
		 */
		public var color:Number = 0xFF00FF;
		
		
		public function FogEffect() {
			
		}
		
		override public function render(visualObject:VisualObject, projection:Projection2D, camera:CameraObject):BitmapFilter {
			
			//TODO: find a solution to only set layers that have a different fog property.
			//maybe create a data property on layers which can store fog settings 
			//very bad performance wise if you keep setting the same fog on a visualObject
			
			var ratio:Number = ((projection.zDepth - _nStartDistance) * value * .001); 
			ratio = (ratio <= 0) ? 0 : ratio;
			
			var matrix:Array = new Array();
			//ratio = ignoreFog ? 0 : ((ratio < 0) ? 0 : ((ratio > 1) ? 1 : ratio));
			
			if (ratio != 0) {
				
				var alphaValue:Number = 1 - ratio
				var colorValue:Number = ratio;
				
				if (fogMode == FogModes.ALPHA) {
					
					//if (_nFogRatio != ratio) {
						
						
						matrix = matrix.concat([1, 0, 0, 0, 0]); // red
						matrix = matrix.concat([0, 1, 0, 0, 0]); // green
						matrix = matrix.concat([0, 0, 1, 0, 0]); // blue
						matrix = matrix.concat([0, 0, 0, alphaValue, 0]); // alpha

						return new ColorMatrixFilter(matrix);
					//}
					
				}else if (fogMode == FogModes.TINT) {
					
					//if (_nTintColor != color || _nFogRatio != colorValue) {
						//_nTintColor = color;
						//_nFogRatio = colorValue;
						//setTint(color, colorValue, visualObject.container);	
						
						var red:uint = color >> 16; 
						var green:uint = (color ^ (red << 16)) >> 8; 
						var blue:uint = (color ^ (red << 16)) ^ (green << 8); 
						
						var multiplier:Number = 1 - colorValue;	
						
						matrix = matrix.concat([multiplier, 0, 0, 0, red*colorValue]); // red
						matrix = matrix.concat([0, multiplier, 0, 0, green*colorValue]); // green
						matrix = matrix.concat([0, 0, multiplier, 0, blue*colorValue]); // blue
						matrix = matrix.concat([0, 0, 0, 1, 0]); // alpha

						return new ColorMatrixFilter(matrix);
					//}
				}
			
			}else{
				//clear up fog transforms
				//if (_nFogRatio != ratio)
					//visualObject.container.transform.colorTransform = new ColorTransform();
				return null;
			}
				
			return null;
		}
		/*
		private function setTint(color:uint, amount:Number, target:DisplayObject) { 
			
			var red:uint = color >> 16; 
			var green:uint = (color ^ (red << 16)) >> 8; 
			var blue:uint = (color ^ (red << 16)) ^ (green << 8); 
			
			var multiplier:Number = 1 - amount;
			
			var matrix:Array = new Array();
            matrix = matrix.concat([multiplier, 0, 0, 0, red*amount]); // red
            matrix = matrix.concat([0, multiplier, 0, 0, green*amount]); // green
            matrix = matrix.concat([0, 0, multiplier, 0, blue*amount]); // blue
            matrix = matrix.concat([0, 0, 0, 1, 0]); // alpha

			target.filters = [new ColorMatrixFilter(matrix)];
		}
		*/
		//GETTERS
		
		//public function set useFog(b:Boolean):void {
				//_bUseFog = b;
		//}
		
		public function set startDistance(n:Number):void {
			_nStartDistance = (n < 0) ? 0 : n;
		}
		
		//public function get useFog():Boolean { return _bUseFog; }
		
		public function get startDistance():Number { return _nStartDistance; }
	}

}