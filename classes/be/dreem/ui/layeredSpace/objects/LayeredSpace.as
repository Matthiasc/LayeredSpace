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

/**
 * changes v2.1
 * 
 * - new core part of layeredSpace, faster cleaner and with less code
 * - renamed object (canvas is now named screen)
 * - layeredSpace only holds the camera and the camera now holds the screen object 
 * - layeredSpace Y axis has now the same behavior as the Y axis of the stage
 * - the projection of 3D to 2D is now handled within the camera itself. Now its possible to create your own camera which might see the world completely different (fish eye, incremental motion detection, ...)
 */

/**
 * changes v1.1
 * 
 * - dof and fog effects moved towards the visualLayer class
 * - ignore flags for different propertys added in visualLayer class
 * - use of different DepthOfField modes: 	- STATIC, will render cached versions of the blurred visual, ONLY WORKS WITH 1 DISPLAYOBJECT ADDED TO THE LAYER
 * 											- INTERACTIVE, same as above but with interativety
 * 											- ANIMATION, filter based DOF
 * - if set to true, the removeLayer property of the VisualObject will snap back to false once the layer has been removed
 */

package be.dreem.ui.layeredSpace.objects {
	
	import be.dreem.ui.layeredSpace.*;
	import be.dreem.ui.layeredSpace.data.*;
	import be.dreem.ui.layeredSpace.events.*;
	import be.dreem.ui.layeredSpace.geom.*;
	import be.dreem.ui.layeredSpace.constants.*;	
	import be.dreem.ui.layeredSpace.objects.*;
	
	import flash.utils.Timer;
	import flash.system.System;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	
	public class LayeredSpace extends EventDispatcher { 
		
		public static const VERSION:String = "1.2.1";
		
		//Collections
		private var _aLayers:Array;
		
		//the array that will store the layer add/removes during a render cycle
		private var _aLayersIncremental:Array;
		
		//private var _aCanvas:Array;
		private var _screen:ScreenObject;
		
		//the camera layer
		private var _camera:CameraObject;
		
		public var effects:Effects;
		
		/**
		 * the sortMode determines the way LayeredSpace handles the sorting of the layers
		 */
		public var sortingMode:String = SortingModes.LAYER;
		
		//stats
		private var _renderStats:RenderStats;
		//TODO: sample crap heeft niks te maken met layeredspace... moet eruit
		private var _aFpsSamples:Array = new Array(30);
		//private var _iCurrentFpsSample:int = 0;
		private var _iTempVisibleLayerCount:int;
		//private var _iFrameCount:int;
		private var sp:Sprite;
		private var _t:Timer;
		private var _time:int;
		
		private var _bZSortUpdate:Boolean = false;
		
		//loop stuff
		//private var i:int;
		private var l:int;
		
		//internal vars
		private var _spCanvas:Sprite;
		private var _bVisible:Boolean;
		private var _spLayer:Sprite;		
		
		/**
		* LayeredSpace is the core class that represents and holds the actual 3D space
		*/
		function LayeredSpace(){
			_aLayers = new Array();
			_aLayersIncremental = new Array();
			_renderStats = new RenderStats();
			
			effects = new Effects();
			
			sp = new Sprite();
			sp.addEventListener(Event.ENTER_FRAME, updateFrameCount, false, 0, true);
			
			//fill fpsSamples with 0;
			for (var i:int = 0; i < _aFpsSamples.length; i++)
				_aFpsSamples[i] = 0;
				
			_time = new Date().getTime();
			
			_t = new Timer(100);
			_t.addEventListener(TimerEvent.TIMER, updateRenderStats, false, 0, true);
			//_t.start();
		}
		
		/*
		* FUNCTIONS
		*/ 
		
		/**
		* render scene frame.
		*/
		public function update():void {
			
			_iTempVisibleLayerCount = 0;
			
			updateLayersIncrement();
			
			if((_bZSortUpdate  && sortingMode != SortingModes.NONE ) || sortingMode == SortingModes.FRAME)
				arrangeDepths();
			
			l = _aLayers.length;
			
			_screen = _camera.screen;
			
			for (var i:int = 0; i < l; i++)
				renderLayer(_aLayers[i], i);
			
			_renderStats.numberOfViewedLayers = _iTempVisibleLayerCount;			
		}
		
		private function renderLayer(layer:VisualObject, zIndex:uint):void {			
			
			_spCanvas = _screen.container;
			_bVisible = true;
			_spLayer = layer.container;
			
			
			//layer.showAnchorPoint = _screen.showAnchorPoints;
			
			if (_camera.seesVisual(layer)) {
				
				//PLOT THE 3D World throught the camera into 2D
				var projection:Projection2D = _camera.project(layer);
				projection.zIndex = zIndex;
				
				//PLACE LAYER IN SCREEN 
				//_screen.placeLayer(layer, projection);
				
				projection.x += /*_screen.xOffset +*/ _screen.getZeroPoint().x;
				projection.y += /*_screen.yOffset + */_screen.getZeroPoint().y;
				
				layer.transform(projection);
				
				//don't render the layer if he did not ask to
				if (layer.hide)
					_bVisible = false;
					
				if(_screen.canSeeVisual(layer) ){
					layer.setIsInCanvas(true);	
					
					//if (!effects.render(layer, projection, _camera))
						//_bVisible = false;
					_spLayer.filters = effects.render(layer, projection, _camera);
					
				}else {					
					//the layer is completely outside the screen's viewing area so do not render the layer.
					_bVisible = false;
					layer.setIsInCanvas(false);
				}
				
			}else{
				//object is out of the viewing area of the camera
				_bVisible = false;
			}
			
			//Add the layer to the display list only if not present yet, don't want the displaylist to redraw unnessecary
			if(!layer.isAdded){
				//only addchild if it wasn't added yet, should only trigger once
				_spCanvas.addChild(layer.container);
				layer.setIsAdded(true);
			}
			
			//Sorting the layers according to the z depth
			if(projection)
				if (_spCanvas.getChildIndex(layer.container) != projection.zIndex)
					_spCanvas.setChildIndex(layer.container, projection.zIndex);
			
			//SHOW OR HIDE (flash engine will render the layer or not)
			layer.setVisible(_bVisible);			
			
			//stats
			if(_bVisible)
				_iTempVisibleLayerCount++;	
		}
		
		/**
		 * The next time LayeredSpace will render a frame the layers will be depth sorted.
		 * This method only applys on the next rendered frame.
		 */
		public function sortDepthsNextUpdate():void {
			_bZSortUpdate = true;
		}
		
		private function arrangeDepths():void{
			//in as2.0 u can't use sortOn on getter propertys/fields, in as3 u can, woohoo...
			_aLayers.sortOn("z", Array.NUMERIC); //aLayers.sortOn("z", Array.NUMERIC | Array.DESCENDING);
			_bZSortUpdate = false;
		}
		
		public function addLayer(layer:VisualObject):VisualObject{
			_aLayersIncremental.push( { add:true, layer:layer } );			
			return layer;
		}
		
		public function removeLayer(layer:VisualObject):VisualObject{
			_aLayersIncremental.push( { add:false, layer:layer } );
			return layer;
		}
		
		private function updateLayersIncrement():void {
			//TODO: create 2 arrays one with things to add and one with things to remove
			//first search and remove, then add 
			//check if any layer itself has the removeLayer flag
			l = _aLayers.length;
			var i:int
			for ( i = 0; i < l; i++ )
				if (VisualObject(_aLayers[i]).removeLayer) {
					VisualObject(_aLayers[i]).removeLayer = false;
					removeLayer(_aLayers[i] as VisualObject);
				}
			
			if (_aLayersIncremental.length) {
				
				var o:Object;
				var vo:VisualObject;
				
				while (_aLayersIncremental.length) { 
					
					o = _aLayersIncremental.shift();
					vo = o.layer as VisualObject;
					
					if (o.add as Boolean) {
						//add the layer
						//TODO: Check if it ain't allready there? don't wanna have dupes
						_aLayers.push(vo);
						
						dispatchEvent(new LayeredSpaceEvent(LayeredSpaceEvent.LAYER_ADDED, o.layer));
						
					}else {
						//remove the layer						
						l = _aLayers.length;
			
						for(i = 0; i < l; i++){
							if(_aLayers[i] as VisualObject == vo){
								
								//remove the layer sprite from the displaylist
								if(_screen.container.contains(vo.content)){
									_screen.container.removeChild(vo.container);
									vo.setIsAdded(false);
								}
								//remove layer from collection
								_aLayers.splice(i,1);
								
								dispatchEvent(new LayeredSpaceEvent(LayeredSpaceEvent.LAYER_REMOVED, vo));
								
								break;
							}
						}
					}
				}
				
				_renderStats.numberOfLayers = _aLayers.length;
				
				_bZSortUpdate = true;	
			}
		}
		
		private function renderCheck():Boolean{
		
			var b:Boolean = true;
			
			//check layers			
			if(_aLayers.length == 0){
				throw new Error("LayeredSpace: no Layers added");
				b = false;
			}
			
			//check screen
			//var length:Number = _aCanvas.length;
			if(camera.screen == null){
				throw new Error("LayeredSpace: no Screen set");
				b = false;
			}
			//check for a camera
			if(camera == null){
				throw new Error("LayeredSpace: no Camera set");
				b = false;
			}
			
			return b;
		}
		
		private function updateFrameCount(e:Event):void{
			//_iFrameCount++;
			
			updateRenderStats(null);
		}
		
		private function updateRenderStats(e:TimerEvent):void {
			//_renderStats.currentFps = _iFrameCount;
			
			var _now:int = new Date().getTime();			
			
			//trace( );
			_renderStats.currentFps = 1 / ((_now - _time) * .001);
			
			if (!_renderStats.averageFps)
				_renderStats.averageFps = 0;
			
			//add fps sample
			_aFpsSamples.shift();
			_aFpsSamples.push(_renderStats.currentFps);
			/*
			_iCurrentFpsSample++;
			_iCurrentFpsSample = (_iCurrentFpsSample >= _aFpsSamples.length) ? 0 : _iCurrentFpsSample;
			_aFpsSamples[_iCurrentFpsSample] = _renderStats.currentFps;
			*/
			var nTotal:int = 0;
			for (var i:int = 0; i < _aFpsSamples.length; i++)
				nTotal += _aFpsSamples[i];
			
			_renderStats.averageFps = Math.round(nTotal / _aFpsSamples.length);
			//_iFrameCount = 0;
			
			_time = _now;
		}
		
		/**
		 * Project a given point onto another Zdepth in relation with the current camera
		 * @param	p	the point that will be projected
		 * @param	z	the zdepth on wich the point will be projected
		 * @return	the projected point
		 */
		public function projectPointOnZdepth(p:Point3D, z:Number):Point3D {
			var ratio:Number = (z - _camera.position.z) / (p.z - _camera.position.z);
			return new Point3D(ratio * p.x, ratio * p.y, z);
		}
		
		/**
		 * Project a given value onto another zdepth in relation with the current camera
		 * @param	v	the value you want to project
		 * @param	z1	the zdepth in relation with that value
		 * @param	z2	the new zdepth u want the value to be projected on
		 * @return	the projected value
		 */
		public function projectValueOnZdepth(v:Number,z1:Number, z2:Number):Number {
			return v * (z2 - _camera.position.z) / (z1 - _camera.position.z);
		}
		
		public function getRenderStats():RenderStats {
			_renderStats.memory =  System.totalMemory / 1024;
			return _renderStats.clone(); 
		}
		
		//SETTERS		
		public function set camera(value:CameraObject):void {
			_camera = value;
		}
		
		//GETTERS
		public function get layers():Array { return _aLayers; }
		
		public function get camera():CameraObject {
			return _camera;
		}		
	}	
}
