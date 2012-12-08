package  demos {
	
	import be.dreem.ui.layeredSpace.constants.*;
	import be.dreem.ui.layeredSpace.control.KeyboardControl;
	import be.dreem.ui.layeredSpace.effects.*;
	import be.dreem.ui.layeredSpace.feedback.RenderStatsGraph;
	import be.dreem.ui.layeredSpace.geom.*;
	import be.dreem.ui.layeredSpace.objects.*;
	import be.dreem.ui.layeredSpace.layers.*;
	import be.dreem.ui.layeredSpace.cameras.*;
	import be.dreem.ui.layeredSpace.screens.*;
	import com.greensock.easing.Back;
	import com.greensock.easing.Cubic;
	import com.greensock.TweenLite;	
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	public class Carousel extends MovieClip {		
		
		public var ls:LayeredSpace;
		public var camera:StandardCamera;
		public var camera2:StandardCamera;
		public var camera3:StandardCamera;
		public var screen:StandardScreen;
		public var renderStatsGraph:RenderStatsGraph;
		
		private var aBalls:Array;
		private var globalRotation:Number = 0;
		private var uiItemCount:uint = 16;
		private var uiDiameter:uint = 600;
		
		private var _t2:Timer;
		
		private var _fogEffect:FogEffect;
		private var _dofEffect:DofEffect;
		
		private var _keyboardControl:KeyboardControl;
		
		private var _controlInfo:Sprite;
		
		function Carousel(){
			
			var $Ref:Carousel = this;
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			//create layeredSpace
			ls = new LayeredSpace();
			ls.sortingMode = SortingModes.FRAME;
			
			_fogEffect = new FogEffect();
			_fogEffect.color = 0xFFFFFF;
			_fogEffect.value = 0.08;
			
			_dofEffect = new DofEffect();
			_dofEffect.value = 6;
			
			ls.effects.add(_fogEffect);
			ls.effects.add(_dofEffect);			
			
			//create screen
			screen = new StandardScreen(new Rectangle(0, 0, 300, 300));
			screen.backgroundColor = 0xFFFFFF;
			
			//create cameras
			camera = new StandardCamera();
			camera.z = 5000;
			camera.y = -1000;
			camera.focusDistance = 1800;
			camera.viewingDistanceStart = 500;		
			
			camera2 = new StandardCamera();
			camera2.position = new Point3D(-200, -300, 1000);
			camera2.focusDistance = camera2.z + uiDiameter;
			camera2.viewingDistanceStart = 100;
			camera2.rotation = 45;		
			camera2.angle = 150;						
			
			camera3 = new StandardCamera();
			camera3.position = new Point3D(600, -100, 6000);
			camera3.focusDistance = camera3.z - uiDiameter;
			camera3.viewingDistanceStart = 500;
			camera3.angle = 40;		
			
			//renderStatistics
			renderStatsGraph = new RenderStatsGraph(ls);
			renderStatsGraph.visible = false;
			
			//control info
			_controlInfo = new ControlInfo();
			
			addChild(screen);
			addChild(renderStatsGraph);
			addChild(_controlInfo);
			
			//link 
			ls.camera = camera;		
			camera.screen = screen;
			camera2.screen = screen;
			camera3.screen = screen;
			
			//create circular			
			aBalls = new Array();			
			
			for (var i:uint = 0; i < uiItemCount; i++) { 
				
				//create sprites
				var s:Sprite = new Ball();
				
				//create layer
				var l:VisualLayer = new VisualLayer(s);
				l.scale = 0.2 + Math.random() * 0.8;
					
				//add to layeredSpace
				ls.addLayer(l);
				
				aBalls.push(l);
			}
			
			updateRotation();			
			
			addEventListener(Event.ENTER_FRAME, update);
			
			//switch between cameras
			_t2 = new Timer(3000);
			_t2.addEventListener(TimerEvent.TIMER,randomCamSwitch);
			_t2.start();
				
			stage.addEventListener(Event.RESIZE,onStageResize);	
			
			onStageResize();			
			
			//control
			_keyboardControl = new KeyboardControl(stage);
			_keyboardControl.camera = ls.camera;
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onStageKeyDown, false, 0, true);	
			
			//animation
			TweenLite.to(camera, 2, { z:2000, y: -100, ease:Cubic.easeOut } );					
		}
		
		private function onStageKeyDown(e:KeyboardEvent):void {		
			_t2.stop();
			
			if (parseInt(String.fromCharCode(e.charCode))) {
				//switch camera				
				
				switch(parseInt(String.fromCharCode(e.charCode))) {
					case 1:
						ls.camera = camera;
					break;
					
					case 2:
						ls.camera = camera2;
					break;
					
					case 3:
						ls.camera = camera3;
					break;
				}				
			}
		}
		
		private function update(e:Event):void {
			updateRotation();
			
			if(ls.camera.y > -100)
				ls.camera.y =  -100;
			
			ls.update();
		}
		
		private function randomCamSwitch(e:TimerEvent){
			var n:Number = Math.random();
			
			if(ls.camera == camera){
				ls.camera = camera2;
			}else if(ls.camera == camera2){
				ls.camera = camera3;
			}else {
				ls.camera = camera;
			}
			
			_keyboardControl.camera = ls.camera;
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
			screen.dimensions = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
			
			_controlInfo.x = stage.stageWidth * .5;
			_controlInfo.y = stage.stageHeight;
		}
		
		private function dof(e:MouseEvent):void{
			_dofEffect.enable = !_dofEffect.enable;
		}
		
		private function details(e:MouseEvent):void{
			renderStatsGraph.visible = !renderStatsGraph.visible;
		}
		
		private function fog(e:MouseEvent):void {
			_fogEffect.enable = !_fogEffect.enable;
		}
	}	
}

