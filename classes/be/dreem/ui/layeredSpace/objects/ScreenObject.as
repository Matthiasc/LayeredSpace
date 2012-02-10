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
	
	import be.dreem.ui.layeredSpace.data.Projection2D;
	import be.dreem.ui.layeredSpace.geom.*;
	import be.dreem.ui.layeredSpace.*;
	import be.dreem.ui.layeredSpace.objects.*;
	
	import flash.text.*;
	import flash.display.*;
	import flash.geom.*;
	import flash.events.*;
	import flash.utils.Timer;
	import flash.system.System;
	
	public class ScreenObject extends Sprite {
		
		
		protected var _spContainer:Sprite;
		protected var _spScreen:Sprite;
		
		function ScreenObject(){
			
			_spContainer = new Sprite();
			
			//create containers
			_spScreen = new Sprite();
			//_shMask = new Shape();
			
			//add to view
			addChild(_spContainer);
			_spContainer.addChild(_spScreen);
		}
		
		/**
		 * method that checks if the visual can be seen, for whatever reason you might implement, based on the screenObject properties
		 * (if the layer is outside the bounding of the screen, ... )
		 * @param	visual
		 * @return	
		 */		
		public function canSeeVisual(visualObject:VisualObject):Boolean {			
			throw new Error("ScreenObject: Override canSeeVisual function!");
			return false;
		}
		
		/*
		internal function placeLayer(layer:VisualObject, projection:Projection2D):void {
			
			//adjust the projection of the layer according to canvas propertys
			projection.x += _pCenter.x + _screen.xOffset;
			projection.y += _pCenter.y + _screen.yOffset;
			
			//finally let the projection transform the layer into something 3Dish
			layer.transform(projection);
				
			//Add the layer to the display list only if not present yet, don't want the displaylist to redraw unnessecary
			if(!layer.isAdded){
				//only addchild if it wasn't added yet, should only trigger once
				_spScreen.addChild(layer.container);
				layer.setIsAdded(true);
			}
			
			//Sorting the layers according to the z depth
			if (_spScreen.getChildIndex(layer.container) != projection.zIndex)
				_spScreen.setChildIndex(layer.container, projection.zIndex);
				
		}
		*/
		
		
		public function getZeroPoint():Point{
			throw new Error("ScreenObject: Override getZeroPoint function!");
			return new Point();
		}
		
		public function get container():Sprite{
			return _spScreen;
		}
		
		
		public function set container(sp:Sprite):void{
			_spScreen = sp;
		}	
		
	}
	
}
