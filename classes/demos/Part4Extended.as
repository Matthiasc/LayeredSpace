package  demos {
	
	import be.dreem.ui.layeredSpace.cameras.StandardCamera;
	import be.dreem.ui.layeredSpace.objects.*;
	import be.dreem.ui.layeredSpace.screens.*;
	import be.dreem.ui.layeredSpace.cameras.*;
	import be.dreem.ui.layeredSpace.layers.*;	
	import be.dreem.ui.layeredSpace.geom.*;
	
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
	public class Part4Extended extends MovieClip {
		
		private var _layeredSpace:LayeredSpace;
		private var _camera:StandardCamera;
		private var _screen:StandardScreen;
		
		public function Part4Extended() {
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			//layeredspace setup
			_layeredSpace = new LayeredSpace();
			//_layeredSpace.roundPoints = true;
			_screen = new StandardScreen(new Rectangle(0, 0, 400, 200));
			_camera = new StandardCamera();
			_camera.roundPoints = true;
			
			
			_layeredSpace.camera = _camera;
			_camera.screen = _screen;
			
			//_screen.showAnchorPoints = true;
			//_screen.showRenderDetails = true;
			
			addChild(_screen);
			
			var iSquareSize:int = 5;
			var vl:VisualLayer;
			for (var i:int = 0; i < iSquareSize; i++) 
				for (var j:int = 0; j < iSquareSize; j++) {
					vl = _layeredSpace.addLayer(new VisualLayer(new Square())) as VisualLayer;
					vl.position = new Point3D((i * 100) - ((iSquareSize - 1) * 100 * .5), (j * 100) - ((iSquareSize -1) * 100 * .5), 0);
					vl.position = _layeredSpace.projectPointOnZdepth(vl.position, Math.random() * -1000);
					vl.scaleDistance = vl.z - _camera.z;
				}	
			
			/*
			_layeredSpace.useFog = true;
			_layeredSpace.fogValue = .1;
			_layeredSpace.fogColor = 0;
			_layeredSpace.fogType = FogTypes.FOG_TYPE_COLOR;
			//*/
			
			/*
			_camera.useDepthOfField = true;
			_camera.depthOfFieldValue = 2;
			//*/
			
			//events
			stage.addEventListener(Event.RESIZE, onStageResize, false, 0, true);
			addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
			addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, false, 0, true);
			addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel, false, 0, true);
			
			updateDimensions();
		}
		
		private function onMouseWheel(e:MouseEvent):void {
			_camera.z += 10 * e.delta;
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