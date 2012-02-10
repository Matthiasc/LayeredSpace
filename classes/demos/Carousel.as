package  demos {
	
	
	import be.dreem.ui.layeredSpace.constants.*;
	import be.dreem.ui.layeredSpace.effects.*;
	import be.dreem.ui.layeredSpace.geom.*;
	import be.dreem.ui.layeredSpace.objects.*;
	import be.dreem.ui.layeredSpace.layers.*;
	import be.dreem.ui.layeredSpace.cameras.*;
	import be.dreem.ui.layeredSpace.screens.*;
	import com.greensock.easing.Back;
	import com.greensock.TweenLite;
	
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	public class Carousel extends MovieClip {		
		
		public var ls:LayeredSpace;
		public var camera:IsoMetricCamera;
		public var camera2:StandardCamera;
		public var camera3:StandardCamera;
		public var currentCamera:CameraObject;
		public var screen:StandardScreen;
		public var controls:Sprite;
		
		private var handShakeX:Number = 0;
		private var handShakeY:Number = 0;
		private var handShakeZ:Number = 0;
		private var handShakeR:Number = 0;
		
		private var aBalls:Array;
		private var globalRotation:Number = 0;
		private var uiItemCount:uint = 16;
		private var uiDiameter:uint = 600;
		
		private var _t2:Timer;
		
		private var _fogEffect:FogEffect;
		private var _dofEffect:DofEffect;
		
		function Carousel(){
			
			var $Ref:Carousel = this;
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			//create layeredSpace
			ls = new LayeredSpace();
			//ls.useFog = true;
			//ls.fogMode = FogModes.TINT;
			//ls.fogValue = .1;
			//ls.fogDistanceStart = 1800 + 600;
			ls.sortingMode = SortingModes.FRAME;
			
			_fogEffect = new FogEffect();
			_fogEffect.color = 0xFFFFFF;
			_fogEffect.value = 0.03;
			
			_dofEffect = new DofEffect();
			_dofEffect.value = 1;
			
			ls.effects.add(_fogEffect);
			ls.effects.add(_dofEffect);
			
			//create screen
			screen = new StandardScreen(new Rectangle(0, 0, 300, 300));
			screen.backgroundColor = 0xFFFFFF;
			screen.blendMode = BlendMode.ADD;
			
			//create camera
			camera2 = new StandardCamera();
			camera2.position = new Point3D(-100, -500, 800);
			camera2.focusDistance = camera2.z - uiDiameter;
			camera2.rotation = 45;		
			camera2.angle = 20;
			camera2.focusDistance = 1200;
			//camera2.depthOfFieldValue = 3;
			//camera2.useDepthOfField = true;
			camera2.screen = screen;
			
			camera3 = new StandardCamera();
			camera3.position = new Point3D(600, -300, 6000);
			camera3.angle = 30;
			camera3.screen = screen;
			
			currentCamera = camera = new IsoMetricCamera();
			camera.z = 1800;
			camera.y = -1000;
			//camera.depthOfFieldValue = 3;
			//camera.useDepthOfField = true;
			camera.screen = screen;
			
			//Tweener.addTween(camera,{y:200,time:3,transition:"easeInOutBack"});
			TweenLite.to(camera, 1, { y:-200, ease:Back.easeOut } );
			
			//screen.showRenderDetails = true;
			
			addChild(screen);
			
			//link 
			ls.camera = camera;
			
			
			//create circular			
			aBalls = new Array();
			
			
			for (var i:uint = 0; i < uiItemCount; i++) { 
				
				//create sprites
				var s:Sprite = new Ball();
				//s.n = i;
				//s.addEventListener(MouseEvent.CLICK,onBallClick);
				
				//create layer
				var l:VisualLayer = new VisualLayer(s);
				l.scale = 0.2 + Math.random() * 0.8;
					
				//add to layeredSpace
				ls.addLayer(l);
				
				aBalls.push(l);
			}
			
			updateRotation();			
			
			
			addEventListener(Event.ENTER_FRAME, update);
			
			_t2 = new Timer(1000);
			_t2.addEventListener(TimerEvent.TIMER,randomCamSwitch);
			_t2.start();
				
			stage.addEventListener(Event.RESIZE,onStageResize);
			
			//createControls
			createControls();
			
			onStageResize();
			
		}
		
		private function update(e:Event):void {
			updateRotation();
			ls.update();
		}
		
		private function randomCamSwitch(e:TimerEvent){
			var n:Number = Math.random();
			if(n < 0.33){
				ls.camera = camera3;
			}else if(n < 0.5){
				ls.camera = camera2;
			}else {
				ls.camera = camera;
			}
		}
		
		private function updateRotation():void {
			
			globalRotation += 0.25;
			
			for(var i:uint = 0; i< aBalls.length;i++)	
				rotateLayer(aBalls[i], (i * 360/uiItemCount) + globalRotation);
		}
		
		private function rotateLayer(layer:VisualLayer,rotation:Number):void{
			
			var n:Number = Math.PI * rotation / 180;
			
			var xPos:Number = Math.sin(n) * uiDiameter;
			var zPos:Number = Math.cos(n) * uiDiameter;
			
			layer.x = xPos;
			layer.z = zPos;
		}
		
		
		public function onStageResize(e:Event=null):void{
			//resize screen
			screen.dimensions = new Rectangle(100,100,stage.stageWidth - 200,stage.stageHeight - 200 - controls.height);
			
			//reposition controls
			controls.x = Math.round((stage.stageWidth - controls.width)/2)
			controls.y = stage.stageHeight - controls.height;
		}
		
		private function createControls():void{
			controls = new Controls();
			
			addChild(controls);
			
			var s:Sprite;
			
			s = controls.getChildByName("xUp_mc") as Sprite;
			s.buttonMode = true;
			s.addEventListener(MouseEvent.CLICK,xUp, false, 0, true);
			
			s = controls.getChildByName("xDown_mc") as Sprite;
			s.buttonMode = true;
			s.addEventListener(MouseEvent.CLICK,xDown, false, 0, true);
			
			s = controls.getChildByName("yUp_mc") as Sprite;
			s.buttonMode = true;
			s.addEventListener(MouseEvent.CLICK,yUp, false, 0, true);
			
			s = controls.getChildByName("yDown_mc") as Sprite;
			s.buttonMode = true;
			s.addEventListener(MouseEvent.CLICK,yDown, false, 0, true);
			
			s = controls.getChildByName("zUp_mc") as Sprite;
			s.buttonMode = true;
			s.addEventListener(MouseEvent.CLICK,zUp, false, 0, true);
			
			s = controls.getChildByName("zDown_mc") as Sprite;
			s.buttonMode = true;
			s.addEventListener(MouseEvent.CLICK,zDown, false, 0, true);
			
			s = controls.getChildByName("focusUp_mc") as Sprite;
			s.buttonMode = true;
			s.addEventListener(MouseEvent.CLICK,focusUp, false, 0, true);
			
			s = controls.getChildByName("focusDown_mc") as Sprite;
			s.buttonMode = true;
			s.addEventListener(MouseEvent.CLICK,focusDown, false, 0, true);
			
			s = controls.getChildByName("angleUp_mc") as Sprite;
			s.buttonMode = true;
			s.addEventListener(MouseEvent.CLICK,angleUp, false, 0, true);
			
			s = controls.getChildByName("angleDown_mc") as Sprite;
			s.buttonMode = true;
			s.addEventListener(MouseEvent.CLICK,angleDown, false, 0, true);
			
			s = controls.getChildByName("rotationUp_mc") as Sprite;
			s.buttonMode = true;
			s.addEventListener(MouseEvent.CLICK,rotationUp, false, 0, true);
			
			s = controls.getChildByName("rotationDown_mc") as Sprite;
			s.buttonMode = true;
			s.addEventListener(MouseEvent.CLICK,rotationDown, false, 0, true);
			
			s = controls.getChildByName("dof_mc") as Sprite;
			s.buttonMode = true;
			s.addEventListener(MouseEvent.CLICK, dof, false, 0, true);
			
			s = controls.getChildByName("fog_mc") as Sprite;
			s.buttonMode = true;
			s.addEventListener(MouseEvent.CLICK,fog, false, 0, true);
			
			s = controls.getChildByName("details_mc") as Sprite;
			s.buttonMode = true;
			s.addEventListener(MouseEvent.CLICK,details, false, 0, true);
			
			s = controls.getChildByName("cam1_mc") as Sprite;
			s.buttonMode = true;
			s.addEventListener(MouseEvent.CLICK,cam1, false, 0, true);
			
			s = controls.getChildByName("cam2_mc") as Sprite;
			s.buttonMode = true;
			s.addEventListener(MouseEvent.CLICK,cam2, false, 0, true);
			
			s = controls.getChildByName("cam3_mc") as Sprite;
			s.buttonMode = true;
			s.addEventListener(MouseEvent.CLICK, cam3, false, 0, true);
		}
	
		private function xUp(e:MouseEvent):void { 
			TweenLite.to(currentCamera, 1, {ease:Back.easeOut, x:ls.camera.x + 100  } );
		}
		
		private function xDown(e:MouseEvent):void {
			TweenLite.to(currentCamera, 1, {ease:Back.easeOut, x:ls.camera.x - 100 } );
		}
		
		private function yUp(e:MouseEvent):void { 
			TweenLite.to(currentCamera, 1, {ease:Back.easeOut, y:ls.camera.y - 100  } );
		}
		
		private function yDown(e:MouseEvent):void { 
			TweenLite.to(currentCamera, 1, {ease:Back.easeOut, y:((currentCamera.y > -100) ? -100 : currentCamera.y + 100) } );			
		}
		
		private function zUp(e:MouseEvent):void { 
			TweenLite.to(currentCamera, 1, {ease:Back.easeOut, z:currentCamera.z + 100 } );
		}
		
		private function zDown(e:MouseEvent):void { 
			TweenLite.to(currentCamera, 1, {ease:Back.easeOut, z:currentCamera.z - 100 } );
		}
		
		private function focusUp(e:MouseEvent):void { 
			TweenLite.to(currentCamera, 1, {ease:Back.easeOut, focusDistance:currentCamera.focusDistance + 100 } );
		}
		
		private function focusDown(e:MouseEvent):void { 
			TweenLite.to(currentCamera, 1, {ease:Back.easeOut, focusDistance:currentCamera.focusDistance - 100 } );
		}
		
		private function angleUp(e:MouseEvent):void{
			TweenLite.to(currentCamera, 1, {ease:Back.easeOut, angle:currentCamera.angle + 25 } );
		}
		
		private function angleDown(e:MouseEvent):void { 
			TweenLite.to(currentCamera, 1, {ease:Back.easeOut, angle:currentCamera.angle - 25 } );
		}
		
		private function rotationUp(e:MouseEvent):void { 
			TweenLite.to(currentCamera, 1, {ease:Back.easeOut, rotation:currentCamera.rotation + 45 } );
		}
		
		private function rotationDown(e:MouseEvent):void { 
			TweenLite.to(currentCamera, 1, {ease:Back.easeOut, rotation:currentCamera.rotation - 45 } );
		}
		
		private function dof(e:MouseEvent):void{
			//currentCamera.useDepthOfField = !currentCamera.useDepthOfField;
			_dofEffect.enable = !_dofEffect.enable;
		}
		
		private function details(e:MouseEvent):void{
			//screen.showRenderDetails = !screen.showRenderDetails;
		}
		
		private function fog(e:MouseEvent):void {
			_fogEffect.enable = !_fogEffect.enable;
		}
		
		private function cam1(e:MouseEvent):void {
			_t2.stop();
			ls.camera = currentCamera = camera;
		}
		
		private function cam2(e:MouseEvent):void {
			_t2.stop();
			ls.camera = currentCamera = camera2;
		}
		
		private function cam3(e:MouseEvent):void {
			_t2.stop();
			ls.camera = currentCamera = camera3;
		}
	}	
}

