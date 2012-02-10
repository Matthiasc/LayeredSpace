package  demos {
	
	import be.dreem.ui.layeredSpace.*;
	import be.dreem.ui.layeredSpace.constants.FogModes;
	import be.dreem.ui.layeredSpace.effects.DofEffect;
	import be.dreem.ui.layeredSpace.effects.FogEffect;
	import be.dreem.ui.layeredSpace.objects.*;
	import be.dreem.ui.layeredSpace.cameras.*;
	import be.dreem.ui.layeredSpace.layers.*;
	import be.dreem.ui.layeredSpace.screens.StandardScreen;
	
	import be.dreem.ui.layeredSpace.geom.Point3D;
	
	import gs.easing.Elastic;
	import gs.TweenLite;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	/**
	* ...
	* @author Matthias Crommelinck
	*/
	public class Part4Extended2 extends MovieClip {
		
		public var _layeredSpace:LayeredSpace;
		public var _camera:StandardCamera;
		private var _screen:StandardScreen;
		
		private var _t:Timer;
		
		public function Part4Extended2() {
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			//layeredspace setup
			_layeredSpace = new LayeredSpace();
			//_layeredSpace.roundPoints = true;
			_screen = new StandardScreen(new Rectangle(0, 0, 400, 200));
			
			_camera = new StandardCamera();
			
			
			_layeredSpace.camera = _camera;
			_camera.screen = _screen;
			//_screen.showAnchorPoints = true;
			//_screen.showRenderDetails = true;
			
			addChild(_screen);
			
			var iSquareSize:int = 5;
			var vl:VisualLayer;
			var iCounter:int = 0;
			for (var i:int = 0; i < iSquareSize; i++) 
				for (var j:int = 0; j < iSquareSize; j++) {
					iCounter++;
					vl = _layeredSpace.addLayer(new VisualLayer(new PicThumb())) as VisualLayer;
					vl.showAnchorPoint = false;
					MovieClip(vl.content).gotoAndStop(iCounter);
					vl.position = _layeredSpace.projectPointOnZdepth(new Point3D((j * 100) - ((iSquareSize - 1) * 100 * .5),(i * 100) - ((iSquareSize - 1) * 100 * .5), 0), Math.random() * -1000);
					//vl.scaleDistance = vl.z - _camera.z;
				}	
			
			var fxFog:FogEffect = new FogEffect();
			fxFog.color = 0;
			fxFog.startDistance = 1000;
			fxFog.fogMode = FogModes.TINT;
			fxFog.value = 1;
			
			var fxDof:DofEffect = new DofEffect();
			fxDof.startDistance = 0;
			fxDof.value = 20;
			
			
			_layeredSpace.effects.add(fxFog);
			_layeredSpace.effects.add(fxDof);
			
			
			//events
			stage.addEventListener(Event.RESIZE, onStageResize, false, 0, true);
			addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
			addEventListener(MouseEvent.CLICK, onMouseClick, false, 0, true);
			
			updateDimensions();
			
			_t = new Timer(6000);
			_t.addEventListener(TimerEvent.TIMER, onTimer, false, 0, true);
		}
		
		private function onTimer(e:TimerEvent):void {
			createRandomCameraMovement();
		}
		
		private function onMouseClick(e:MouseEvent):void {
			if (_t.running) {
				_t.stop();
				moveCameraToStartPosition();
			}
			else {
				createRandomCameraMovement();
				_t.start();
			}
		}
		
		private function moveCameraToStartPosition():void {
			TweenLite.to(_camera, 1, { ease:Elastic.easeOut,depthOfFieldValue:0, angle:45, rotation:0, x:0, y:0, z:1000 } );
			TweenLite.to(_layeredSpace, 1, { ease:Elastic.easeOut,fogValue:0} );
		}
		
		private function createRandomCameraMovement():void {
			TweenLite.to(_camera, 5, { ease:Elastic.easeOut, depthOfFieldValue:10,angle:45 + Math.random() * 0, rotation:(Math.random() - .5) * 60, x:(Math.random() * 1000) - 500, y:(Math.random() * 1000) - 500, z:1000 + (Math.random() * 1000) - 500 } );
			TweenLite.to(_layeredSpace, 5, { ease:Elastic.easeOut,fogValue:0.4} );
		}
		
		private function onMouseWheel(e:MouseEvent):void {
			_camera.z += 10 * e.delta;
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