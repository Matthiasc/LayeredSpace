package  demos {
	
	import be.dreem.ui.layeredSpace.cameras.StandardCamera;
	import be.dreem.ui.layeredSpace.layers.VisualLayer;
	import be.dreem.ui.layeredSpace.objects.LayeredSpace;
	import be.dreem.ui.layeredSpace.screens.StandardScreen;
	//import be.dreem.ui.layeredSpace.constants.FogTypes;
	import be.dreem.ui.layeredSpace.geom.Point3D;
	
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.display.MovieClip;
	
	/**
	* ...
	* @author Matthias Crommelinck
	*/
	public class Part4 extends MovieClip {
		
		private var _layeredSpace:LayeredSpace;
		private var _camera:StandardCamera;
		private var _screen:StandardScreen;
		
		private var _visualLayer1:VisualLayer;
		private var _visualLayer2:VisualLayer;
		private var _visualLayer3:VisualLayer;
		
		public function Part4() {
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			//layeredspace setup
			_layeredSpace = new LayeredSpace();
			_screen = new StandardScreen(new Rectangle(0, 0, 400, 200));
			_camera = new StandardCamera();
			
			_layeredSpace.camera = _camera;
			_camera.screen = _screen;
			//_screen.showAnchorPoints = true;
			//_screen.showRenderDetails = true;
			//_screen.yOffset = 200;
			
			addChild(_screen);
			
			//visualLayers aanmaken
			_visualLayer1 = new VisualLayer(new Square());
			_visualLayer2 = new VisualLayer(new Square());
			_visualLayer3 = new VisualLayer(new Square());
			
			_layeredSpace.addLayer(_visualLayer1);
			_layeredSpace.addLayer(_visualLayer2);
			_layeredSpace.addLayer(_visualLayer3);
			
			//posities
			_visualLayer1.x = 0;
			//_visualLayer1.rotation = 45 / 4;
			_visualLayer2.x = 100;
			_visualLayer3.x = 200;
			//_visualLayer3.y = 100;
			//_visualLayer2.z = -500;
			//_visualLayer3.z = -1000;
			
			_visualLayer2.position = _layeredSpace.projectPointOnZdepth(_visualLayer2.position, -2000);
			_visualLayer2.scaleDistance = _visualLayer2.z - _camera.z;
			_visualLayer3.position = _layeredSpace.projectPointOnZdepth(_visualLayer3.position, -4000);
			_visualLayer3.scaleDistance = _visualLayer3.z - _camera.z;
			
			//events
			stage.addEventListener(Event.RESIZE, onStageResize, false, 0, true);
			addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
			addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, false, 0, true);
			addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel, false, 0, true);
			
			updateDimensions();
		}
		
		private function onMouseWheel(e:MouseEvent):void {
			_camera.rotation += 10 * e.delta;
		}
		
		private function onMouseMove(e:MouseEvent):void {
			if (e.buttonDown) {
				_camera.x = -(e.stageX - (stage.stageWidth * .5))
				_camera.y = -(e.stageY - (stage.stageHeight * .5));
			}			
		}
		
		private function onEnterFrame(e:Event):void {
			updateWorld();
		}
		
		private function updateWorld():void{
			//update the 3D world
			_layeredSpace.update();
		}
		
		private function onStageResize(e:Event):void {
			updateDimensions();
		}
		
		private function updateDimensions():void {
			//adjust the dimensions of the canvas
			_screen.dimensions = new Rectangle(10, 10, stage.stageWidth - 20, stage.stageHeight - 20);
		}
		
	}
	
}