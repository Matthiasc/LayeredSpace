package  demos {
	
	
	import be.dreem.ui.layeredSpace.cameras.*;
	import be.dreem.ui.layeredSpace.constants.*;
	import be.dreem.ui.layeredSpace.layers.*;
	import be.dreem.ui.layeredSpace.geom.*;
	import be.dreem.ui.layeredSpace.objects.*;
	import be.dreem.ui.layeredSpace.screens.*;

	import flash.display.*;
	import flash.events.*;
	import flash.geom.Rectangle;
	
	/**
	* ...
	* @author Matthias Crommelinck
	*/
	public class Part3 extends MovieClip {
		
		private var _layeredSpace:LayeredSpace;
		private var _camera:StandardCamera;
		private var _screen:StandardScreen;
		
		public function Part3() {
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			//layeredspace setup
			_layeredSpace = new LayeredSpace();
			_screen = new StandardScreen(new Rectangle(0, 0, 400, 200));
			_camera = new StandardCamera();
			
			_layeredSpace.camera = _camera;
			_camera.screen = _screen;
			//_screen.showRenderDetails = true;
			
			addChild(_screen);
			_layeredSpace.addLayer(new VisualLayer(new Square())).position = new Point3D(100,0,0);
			//cube aanmaken
			var iCubeSize:int = 3;	
			for (var i:int = 0; i < iCubeSize; i++)
				for (var j:int = 0; j < iCubeSize; j++)
					for (var k:int = 0; k < iCubeSize; k++) {
						_layeredSpace.addLayer(new VisualLayer(new Square())).position = new Point3D((i * 110) - 110, (j * 110) - 110, -(k * 110));
					}
			
			//camera
			//_camera.useDepthOfField = true;
			//_camera.depthOfFieldValue = 20;
			_camera.viewingDistanceStart = 400;
			_camera.viewingDistanceEnd = 4000;
			
			//fog
			//_layeredSpace.useFog = true;
			//_layeredSpace.fogMode = FogModes.TINT;
			//_layeredSpace.fogColor = 0;
			//_layeredSpace.fogValue = 1;
			//_layeredSpace.fogDistanceStart = 1000;
			
			//events
			stage.addEventListener(Event.RESIZE, onStageResize, false, 0, true);
			addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
			addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, false, 0, true);
			addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel, false, 0, true);
			
			updateDimensions();
		}
		
		private function onMouseWheel(e:MouseEvent):void {
			_camera.z += 10 * e.delta;
			//_camera.rotation += 45 * e.delta/2;
		}
		
		private function onMouseMove(e:MouseEvent):void {
			if (e.buttonDown) {
				_camera.x = -(e.stageX - (stage.stageWidth * .5));
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