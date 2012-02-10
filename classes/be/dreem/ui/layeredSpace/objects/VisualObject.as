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
	
	/*
	* The BaseLayer class: basic 3D space object
	*/ 
	
	import be.dreem.ui.layeredSpace.data.*;
	import be.dreem.ui.layeredSpace.events.LayerEvent;
	import flash.display.*;
	import flash.geom.*;
	
	import flash.events.EventDispatcher;
	
	public class VisualObject extends SpaceObject {
		
		/**
		 * The sprite that holds the layer contents
		 */
		public var container:Sprite;
		
		/**
		 * The visual/content of the Layer
		 */
		public var content:DisplayObject;
		
		/**
		 * If true this layer won't be rendered by the engine
		 */
		public var hide:Boolean = false;
		
		/**
		 * If true, the next time layeredspace is beeing rendered the visualLayer will be removed
		 */
		public var removeLayer:Boolean = false;
		
		/**
		 * shows or hides the anchor points
		 */
		private var _bShowAnchorPoint:Boolean = false;
		
		/**
		 * enable or disable mouseInteractivity on this layer
		 */
		private var _bIsInteractive:Boolean = true;
		
		private var _shAnchorPoint:Shape;
		
		/**
		 * if true, the 2D mapped position for this layer will not be rounded
		 */
		public var ignoreRoundPoints:Boolean = false;
		
		//flags
		private var _bIsInCanvas:Boolean = false;
		private var _bIsAdded:Boolean = false;		
				
		
		/**
		 * the distance at wich the layer will be 100% scaled
		 */
		public var scaleDistance:Number = 1000;
		
		internal var filterCollection:Array;
		
		//CONSTRUCTOR
		
		function VisualObject(visual:DisplayObject):void {			
			//store the DisObj
			content = visual;

			//create layer container
			container = new Sprite();
			
			container.addChild(content);			
		};
		
		public function transform(projection:Projection2D):void {
			trace("LayerObject: override project function!");
		}		
		
		/**
		 * returns the 2D bounding of the layer
		 */
		public function get2dBounds():Rectangle {
			//TODO: get the parent out.
			return container.getBounds(container.parent);
		}
		
		/**
		 * inCanvas Flag
		 */
		internal function setIsInCanvas(b:Boolean):void {
				
			if(b != _bIsInCanvas){				
				_bIsInCanvas = b;
				dispatchEvent(new LayerEvent((b) ? LayerEvent.MOVE_IN_CANVAS : LayerEvent.MOVE_OUT_CANVAS));
			}
		}
		
		/**
		 * isAdded Flag
		 */		
		internal function setIsAdded(b:Boolean):void {				
			if(b != _bIsAdded){				
				_bIsAdded = b;				
				dispatchEvent(new LayerEvent((b) ? LayerEvent.ADDED : LayerEvent.REMOVED));
			}
		}
		
		internal function setVisible(b:Boolean):void {
			
			if (container.visible != b) {
				//TODO: things are still being redrawn, eventhough the displayObject is not visible...
				//trace(b);
				container.visible = b;
				//if (!container.visible)
					//trace("not visible");
				//content.visible = b;
				//removing childs will fuck up the bounding calculation with the canvas
				/*
				if (b)
					container.addChild(content)
				else if (container.contains(content))
					container.removeChild(content);
				//*/
				dispatchEvent(new LayerEvent(b ? LayerEvent.VISIBLE : LayerEvent.HIDDEN));
			}
		}
		
		/**
		 * Anchors 
		 */
		private function showAnchorPointVisual():void {
			
			if (!_shAnchorPoint) {
				_shAnchorPoint = new Shape();
				_shAnchorPoint.graphics.beginFill(0xFFFFFF);
				_shAnchorPoint.graphics.drawCircle(0, 0, 8);
				_shAnchorPoint.graphics.beginFill(0);
				
				_shAnchorPoint.graphics.drawRect(-1, -8, 2,16);
				_shAnchorPoint.graphics.drawRect( -8, -1, 16, 2);
				//_shAnchorPoint.graphics.drawCircle(0, 0, 3);
				
				_shAnchorPoint.graphics.endFill();
			}
			
			container.addChild(_shAnchorPoint);	
		}
		
		private function hideAnchorPointVisual():void{
			if (_shAnchorPoint) 
				if (container.contains(_shAnchorPoint))
					container.removeChild(_shAnchorPoint);
		}
		
		//GETTERS
		
		/**
		 * Flag that keeps track of the position of the layer. If true the layer is inside the canvas.
		 */
		public function get isInCanvas():Boolean {
			return _bIsInCanvas;
		}
		
		/**
		 * Flag that is true when the Layer has been added to the LayeredSpace display list.
		 * You are able to add the layer to layerspace but this will not mean this flag will be true.
		 * If, for example, the layer is initialy outside the canvas the layer will not be added to the displaylist thus this flag will be still false.
		 */
		public function get isAdded():Boolean { return _bIsAdded; }
		
		/**
		 * returns the 2D position of the layer
		 */
		public function get position2D():Point {
			return new Point(container.x, container.y);
		}		
		
		/**
		 * Enable or disables mouse interactivity
		 */
		public function get interactive():Boolean { return _bIsInteractive; }
		
		
		//SETTERS
		
		/**
		 * Enable or disables mouse interactivity
		 */
		public function set interactive(value:Boolean):void {
			container.mouseChildren = container.mouseEnabled = _bIsInteractive = value;			
		}
		
		public function get showAnchorPoint():Boolean { return _bShowAnchorPoint; }
		
		public function set showAnchorPoint(value:Boolean):void {
			
			if (_bShowAnchorPoint != value) {
				
				_bShowAnchorPoint = value;
				
				if (value)
					showAnchorPointVisual();
				else
					hideAnchorPointVisual();
			}
			
		}
	}	
}
