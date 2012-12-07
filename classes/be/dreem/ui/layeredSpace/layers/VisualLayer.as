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
		 * Ignore the DOF effect for this layer
		 */
		//public var ignoreDepthOfField:Boolean = false;
		
		/**
		 * Ignore the fog effect of this layer
		 */
		//public var ignoreFog:Boolean = false;
		
		
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
	}	
}
