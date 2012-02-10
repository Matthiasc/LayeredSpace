package  demos {
	
	import be.dreem.ui.layeredSpace.constants.*;
	import be.dreem.ui.layeredSpace.geom.*;
	import be.dreem.ui.layeredSpace.*;
	import gs.easing.Quad;
	import gs.TweenLite;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Rectangle;
	
	/**
	* ...
	* @author Matthias Crommelinck
	*/
	public class DepthOfField1 extends MovieClip {
		
		private var _layeredSpace:LayeredSpace;
		private var _camera:StandardCamera;
		private var _canvas:Screen;
		
		private var _visualLayer1:VisualLayer;
		private var _visualLayer2:VisualLayer;
		private var _visualLayer3:VisualLayer;
		
		public function DepthOfField1() {
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			//layeredspace setup
			_layeredSpace = new LayeredSpace();
			_canvas = new Screen(new Rectangle(0, 0, 400, 200),false);
			_camera = new StandardCamera();
			_camera.useDepthOfField = true;
			_camera.depthOfFieldMode = DepthOfFieldModes.STATIC;
			
			_layeredSpace.canvas = _canvas;
			//_layeredSpace.useFog = true;
			_layeredSpace.fogValue = .2;
			_canvas.camera = _camera;
			_canvas.showAnchorPoints = true;
			_canvas.showRenderDetails = true;
			
			addChild(_canvas);
			
			//visualLayers aanmaken
			_visualLayer1 = new VisualLayer(new Square());
			_visualLayer2 = new VisualLayer(new Square());
			_visualLayer3 = new VisualLayer(new Square());
			
			_layeredSpace.addLayer(_visualLayer1);
			_layeredSpace.addLayer(_visualLayer2);
			_layeredSpace.addLayer(_visualLayer3);
			
			//posities
			_visualLayer1.x = 0;
			_visualLayer2.x = 50 + 25 * .5;
			_visualLayer3.x = 100 - 25 * .5;
			
			_visualLayer2.position = _layeredSpace.projectPointOnZdepth(_visualLayer2.position, -2000);
			_visualLayer3.position = _layeredSpace.projectPointOnZdepth(_visualLayer3.position, -4000);
			
			//events
			stage.addEventListener(Event.RESIZE, onStageResize, false, 0, true);
			addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
			addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, false, 0, true);
			addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel, false, 0, true);
			
			
			getChildByName("spToggle").addEventListener(MouseEvent.CLICK, onToggleClick, false, 0, true);
			
			updateDimensions();
			
			moveOut();
		}
		
		private function moveIn():void {
			TweenLite.to(_camera, 5, {z:4000, x:0, ease:Quad.easeInOut, onComplete:onMoveInComplete } );
		}
		
		private function onMoveInComplete():void{
			moveOut();
		}
		
		
		private function moveOut():void {
			TweenLite.to(_camera, 10, {z: 200, x:0, ease:Quad.easeInOut, onComplete:onMoveOutComplete } );
		}
		
		private function onMoveOutComplete():void{
			moveIn();
		}
		
		private function onToggleClick(e:MouseEvent):void {
			_layeredSpace.useFog = !_layeredSpace.useFog;
		}
		
		private function onMouseWheel(e:MouseEvent):void {
			_camera.z += 10 * e.delta;
		}
		
		private function onMouseMove(e:MouseEvent):void {
			if (e.buttonDown) {
				_camera.x = -(e.stageX - (stage.stageWidth * .5))
				_camera.y = e.stageY - (stage.stageHeight * .5)
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
			_canvas.dimensions = new Rectangle(10, 10, stage.stageWidth - 20, stage.stageHeight - 20);
		}
		
	}
	
}