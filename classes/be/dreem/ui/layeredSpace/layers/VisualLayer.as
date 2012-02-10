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

package be.dreem.ui.layeredSpace.layers {

	import be.dreem.ui.layeredSpace.constants.*;
	import be.dreem.ui.layeredSpace.data.*;
	import be.dreem.ui.layeredSpace.events.*;
	import be.dreem.ui.layeredSpace.objects.*;

	import flash.display.*;
	import flash.geom.*;
	import flash.filters.*;

	public class VisualLayer extends VisualObject {
		
		
		
		/**
		 * Ignore the scaling of the layer in relation with it's depth
		 */
		public var ignoreDepthScaling:Boolean = false;
		
		
		/**
		 * the current ammount of FOG effect
		 */
		//private var _nFogRatio:Number = 0;
		
		/**
		 * the current tint color for the FOG effect
		 */
		//private var _nTintColor:Number = 0xFFFFFF;
		
		/**
		 * Ignore the DOF effect for this layer
		 */
		//public var ignoreDepthOfField:Boolean = false;
		
		/**
		 * Ignore the fog effect of this layer
		 */
		//public var ignoreFog:Boolean = false;
		
		/**
		 * blur value for the blurfilter
		 */
		//private var _nBlur:Number = 0;
		
		/**
		 * VisualLayer is the base class for every graphical layer in layeredspace
		 * @param	displayObject	the visual that will be placed inside the layer
		 */
		public function VisualLayer(visual:DisplayObject){
			super(visual);
		};
		
		//FUNCTIONS
		
		override public function transform(projection:Projection2D):void {
			
			//DO NOT ADJUST THE CONTENT BUT CONTAINER!
			container.x = projection.x;
			container.y = projection.y;
			container.rotation = projection.rotation;
			container.scaleX = container.scaleY = (ignoreDepthScaling) ? 1 : projection.scale;			
		}
		
		/**
		 * DepthOfFieldEffect
		 */
		/*
		internal function setDepthOfFieldEffect(blurValue:Number, quality:int):void {
			
			//round blur values to 0 - 0.5 - 1 - 1.5 - 2 - ...
			//this will have no effect on animation type blurs because the scaling will force the blurfilter to rerender the newly scaled displayObject
			blurValue = ignoreDepthOfField ? 0 : (blurValue - blurValue % 0.5);
			
			if(blurValue < 0.5){
				if(container.filters.length)
					container.filters  = [];
			}else if(blurValue != _nBlur){
				container.filters = [new BlurFilter(blurValue, blurValue, quality)];							
			}
			
			_nBlur = blurValue;			
		}
		*/
		/**
		 * FogEffect
		 */
		/*
		internal function setFogEffect(ratio:Number, fogColor:Number, fogMode:String):void {
			
			ratio = ignoreFog ? 0 : ((ratio < 0) ? 0 : ((ratio > 1) ? 1 : ratio));
			
			if (ratio != 0) {
				
				var alphaValue:Number = 1 - ratio
				var colorValue:Number = ratio;
				
				if (fogMode == FogModes.ALPHA) {
					
					if (_nFogRatio != ratio) {
						container.alpha = alphaValue;								
					}
					
				}else if (fogMode == FogModes.TINT) {
					
					if (_nTintColor != fogColor || _nFogRatio != colorValue) {
						_nTintColor = fogColor;
						_nFogRatio = colorValue;
						setTint(fogColor, colorValue, container);							
					}
				}
			
			}else{
				//clear up fog transforms
				if (_nFogRatio != ratio)
					container.transform.colorTransform = new ColorTransform();
			}
			
			_nFogRatio = ratio;
		}
		*/
		
		/*
		private function setTint(color:uint, amount:Number, target:DisplayObject) { 
			
			var red:uint = color >> 16; 
			var green:uint = (color ^ (red << 16)) >> 8; 
			var blue:uint = (color ^ (red << 16)) ^ (green << 8); 
			
			var multiplier:Number = 1-amount; 
			var red_offset:Number = red*amount; 
			var green_offset:Number = green*amount; 
			var blue_offset:Number = blue*amount; 
			
			var visual:DisplayObject = target as DisplayObject; 
			
			visual.transform.colorTransform = new ColorTransform(multiplier, multiplier, multiplier, 1, red_offset, green_offset, blue_offset, 0);
		} 
		*/
		
		
		
		
		
		
		
		
	}
	
}
