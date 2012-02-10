package  demos {
	
	import be.dreem.ui.layeredSpace.cameras.*;
	import be.dreem.ui.layeredSpace.effects.FogEffect;
	import be.dreem.ui.layeredSpace.objects.*;
	import be.dreem.ui.layeredSpace.layers.*;
	import be.dreem.ui.layeredSpace.screens.CircularScreen;
	import be.dreem.ui.layeredSpace.screens.StandardScreen;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Rectangle;
	
	/**
	* ...
	* @author Matthias Crommelinck
	*/
	public class Part2 extends MovieClip {
		
		private var _layeredSpace:LayeredSpace;
		private var _camera:StandardCamera;
		private var _screen:CircularScreen;
		private var _visualLayer1:VisualLayer;
		private var _visualLayer2:VisualLayer;
		private var _visualLayer3:VisualLayer;
		
		public function Part2() {
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			//layeredspace setup
			_layeredSpace = new LayeredSpace();
			_screen = new CircularScreen(200);
			_camera = new StandardCamera();
			
			_layeredSpace.camera = _camera;
			_camera.screen = _screen;
			
			addChild(_screen);			
			
			//we voegen onze visualLayers toe aan de 3Druimte met een asset uit de library
			_visualLayer1 = new VisualLayer(new Square());
			_layeredSpace.addLayer(_visualLayer1).showAnchorPoint = true;
			
			_visualLayer2 = new VisualLayer(new Square());
			_layeredSpace.addLayer(_visualLayer2).showAnchorPoint = true;
			
			_visualLayer3 = new VisualLayer(new Square());
			_layeredSpace.addLayer(_visualLayer3).showAnchorPoint = true;
			
			//we passen de positie aan van de layers
			_visualLayer1.z = 0;
			_visualLayer2.z = 100;
			_visualLayer3.z = 200;			
			
			_layeredSpace.effects.add(new FogEffect());
			
			//events
			stage.addEventListener(Event.RESIZE, onStageResize, false, 0, true);
			addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMove, false, 0, true);
			addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel, false, 0, true);
			
			updateDimensions();
		}
		
		private function onMouseWheel(e:MouseEvent):void {
			_camera.z += 10 * e.delta;
		}
		
		private function onStageMouseMove(e:MouseEvent):void {
			if (e.buttonDown) {
				_camera.x = -(e.stageX - (stage.stageWidth * .5));
				_camera.y = -(e.stageY - (stage.stageHeight * .5));
			}
		}
		
		private function onEnterFrame(e:Event):void {
			//update the 3D world
			_layeredSpace.update();
		}
		
		private function onStageResize(e:Event):void {
			updateDimensions();
		}
		
		private function updateDimensions():void {
			//adjust the dimensions of the canvas
			//_screen.dimensions = new Rectangle(100, 100, stage.stageWidth - 200, stage.stageHeight - 200);
			_screen.radius = ((stage.stageWidth > stage.stageHeight) ? stage.stageHeight : stage.stageWidth) * .5;
			_screen.x = (stage.stageWidth*.5) - _screen.radius
			_screen.y = (stage.stageHeight*.5) - _screen.radius
		}
		
	}
	
}