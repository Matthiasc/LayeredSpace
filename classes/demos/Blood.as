package  demos {
	
	
	import be.dreem.ui.layeredSpace.cameras.*;
	import be.dreem.ui.layeredSpace.constants.SortingModes;
	import be.dreem.ui.layeredSpace.effects.DofEffect;
	import be.dreem.ui.layeredSpace.effects.FogEffect;
	import be.dreem.ui.layeredSpace.feedback.RenderStatsGraph;
	import be.dreem.ui.layeredSpace.geom.*;
	import be.dreem.ui.layeredSpace.objects.*;
	import be.dreem.ui.layeredSpace.screens.*;
	import be.dreem.ui.layeredSpace.layers.*;
	import com.greensock.easing.Back;
	import com.greensock.easing.Cubic;
	import com.greensock.TweenLite;
	

	import flash.display.*;
	import flash.geom.Rectangle;
	import flash.events.*;
	
	public class Blood extends MovieClip{
		
		public var ls:LayeredSpace;
		public var camera:StandardCamera
		public var screen:StandardScreen;
		public var controls:Sprite;
		
		private var text:Sprite;
		
		public var btnRestart:Sprite;
		
		public var handShakeX:Number = 0;
		public var handShakeY:Number = 0;
		public var handShakeZ:Number = 0;
		public var handShakeR:Number = 0;
		
		var fxFog:FogEffect;
		var fxDof:DofEffect;
		
		private var _bloodCollection:Array;
		private var _splatCount:uint = 0
		private const MAX_SPLATS:uint = 3;
		
		private var _renderStatsGraph:RenderStatsGraph;
		
		function Blood(){
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.quality = StageQuality.MEDIUM;
			
			//layeredSpace aanmaken
			ls = new LayeredSpace();
			ls.sortingMode = SortingModes.FRAME;			
			
			//camera
			camera = new StandardCamera();
			camera.z = 1000;
			camera.x = -1000;
			camera.y = 0;
			camera.focusDistance = 1000;
			camera.viewingDistanceStart = 50;
			
			//effects
			fxFog = new FogEffect();
			fxFog.color = 0xFFFFFF;
			fxFog.value = .3;
			fxFog.startDistance = 1000;
			
			fxDof = new DofEffect();
			fxDof.quality = 2;
			fxDof.value = 8;
			
			camera.effects.add(fxFog);
			camera.effects.add(fxDof);
			
			//screen		
			screen = new StandardScreen(new Rectangle(0, 0, 200, 200));		
			screen.backgroundColor = 0xFFFFFF;
			addChild(screen);
			screen.blendMode = BlendMode.ADD;
			
			//linkage
			ls.camera = camera;
			camera.screen = screen;
			
			//visuals
			
			_bloodCollection = new Array();
			
			var layer:VisualLayer;
			var spBlood:Sprite;
			
			text = new bloodText();
			text.buttonMode = true;
			text.addEventListener(MouseEvent.CLICK, createBloodSplat, false, 0, true);
			ls.addLayer(new VisualLayer(text));
			
			spBlood = new blood1();
			layer = new VisualLayer(spBlood);
			layer.position = new Point3D(120, -60, 20);
			ls.addLayer(layer);
			
			spBlood = new blood18();
			layer = new VisualLayer(spBlood);
			layer.position = new Point3D(120, -30, 40);
			layer.rotation = -20;
			ls.addLayer(layer);
			
			spBlood = new blood20();
			layer = new VisualLayer(spBlood);
			layer.position = new Point3D(130, -10, 60);
			layer.scale = 0.3;
			ls.addLayer(layer);
			
			addEventListener(Event.ENTER_FRAME, onBloodEnterFrame, false, 0, true);				
			stage.addEventListener(Event.RESIZE, onStageResize, false, 0, true);
			
			//createControls();
			btnRestart = new BtnRestart();
			btnRestart.buttonMode = true;
			btnRestart.blendMode = BlendMode.LAYER;
			btnRestart.alpha = .5;
			btnRestart.addEventListener(MouseEvent.CLICK, onBtnRestartClick, false, 0, true);
			addChild(btnRestart);
			
			onStageResize();
			
			TweenLite.to(camera, 1, { ease:Cubic.easeInOut, x:0 } );
			
			_renderStatsGraph = new RenderStatsGraph(ls);
			//_renderStatsGraph.visible = false;
			addChild(_renderStatsGraph);
		}
		
		private function onBtnRestartClick(e:MouseEvent):void {
			_splatCount = 0;
			
			while (_bloodCollection.length)
				VisualLayer(_bloodCollection.pop()).removeLayer = true;
				
			TweenLite.to(camera, 1, { rotation:0, x:0, y:0, ease:Back.easeOut } );
			
			text.buttonMode = true;
		}
		
		private function onBloodEnterFrame(e:Event):void {
			doHandShake();
			ls.update();
		}
		
		private function createBloodSplat(e:MouseEvent=null):void{
			if (_splatCount < MAX_SPLATS) {
				
				for(var i:uint=0; i < 40; i++){
					
					var s:Sprite = getRandomBlood();
					
					var px:Number = ((Math.random() > 0.5) ? -1 : 1 ) * (50 + Math.round(Math.random() * 400));
					var py:Number = ((Math.random() > 0.5) ? -1 : 1 ) * (50 + Math.round(Math.random() * 400));
					var pz:Number = ((Math.random() > 0.5) ? -1 : 1 ) * Math.round(Math.random() * 800);
				
					var l:VisualLayer = new VisualLayer(s);
					l.scale = Math.random();
					l.rotation = Math.atan(py/px) *180 / Math.PI;
					TweenLite.to(l, .12, { x:px, z:pz, y:py, ease:Cubic.easeOut } );
					ls.addLayer(l);
					
					_bloodCollection.push(l);
				}
				
				TweenLite.to(camera, .2, { z:(camera.z + 500), angle:camera.angle + 30, onComplete:moveCamBack, ease:Back.easeOut } );
				
				_splatCount++;
				
				if (_splatCount >= MAX_SPLATS)
					text.buttonMode = false;
			}
		}
		
		private function moveCamBack():void{
			TweenLite.to(camera, 4, { z:(1000), angle:45, ease:Back.easeInOut } );
		}
		
		private function getRandomBlood():Sprite{
			var s:Sprite;
			var n:Number = Math.round(Math.random() * 25);
			
			switch(n){
				case 1 :
					s = new blood1();
				break;
				case 2 :
					s = new blood2();
				break;
				case 3 :
					s = new blood3();
				break;
				case 4 :
					s = new blood4();
				break;
				case 5 :
					s = new blood5();
				break;
				case 6 :
					s = new blood6();
				break;
				case 7 :
					s = new blood7();
				break;
				case 8 :
					s = new blood8();
				break;
				case 9 :
					s = new blood9();
				break;
				case 10 :
					s = new blood10();
				break;
				case 11 :
					s = new blood11();
				break;
				case 12 :
					s = new blood12();
				break;
				case 12 :
					s = new blood12();
				break;
				case 13 :
					s = new blood13();
				break;
				case 14 :
					s = new blood14();
				break;
				case 15 :
					s = new blood15();
				break;
				case 16 :
					s = new blood16();
				break;
				case 17 :
					s = new blood17();
				break;
				case 18 :
					s = new blood18();
				break;
				case 19 :
					s = new blood19();
				break;
				case 20 :
					s = new blood20();
				break;
				case 21 :
					s = new blood21();
				break;
				case 22 :
					s = new blood22();
				break;
				case 23 :
					s = new blood23();
				break;
				case 24 :
					s = new blood24();
				break;
				case 25 :
					s = new blood25();
				break;
				
				default :
					s = new blood25();
				break;
			}
			
			return s;
		}
		
		public function onStageResize(e:Event=null):void{
			//resize screen
			screen.dimensions = new Rectangle(0,0,stage.stageWidth,stage.stageHeight);
			
			btnRestart.x = stage.stageWidth - btnRestart.width - 10;
			btnRestart.y = 10;
			
			//reposition controls
			//controls.x = Math.round((stage.stageWidth - controls.width)/2)
			//controls.y = stage.stageHeight - controls.height;
		}
		
		
		public function doHandShake():void{
		
			handShakeX += difference(handShakeX);
			handShakeY += difference(handShakeY);
			handShakeZ += difference(handShakeZ);
			handShakeR += difference(handShakeR);
				
			camera.x += handShakeX;
			camera.y += handShakeY;
			camera.z += handShakeZ;
			camera.rotation += handShakeR * .1;
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
			s.addEventListener(MouseEvent.CLICK,dof, false, 0, true);
			
			s = controls.getChildByName("details_mc") as Sprite;
			s.buttonMode = true;
			s.addEventListener(MouseEvent.CLICK, details, false, 0, true);
			
			s = controls.getChildByName("fog_mc") as Sprite;
			s.buttonMode = true;
			s.addEventListener(MouseEvent.CLICK, fog, false, 0, true);
		}
		
		private function difference(n:Number):Number{
			var direction:Number;
			if(n > 0.5){
				direction = -1;
			}else if( n < -0.5){
				direction = 1;
			}else{
				direction = ((Math.random() < 0.5) ? 1 : -1)
			}
			return ( direction * Math.random() * 0.2);
		}
	
		private function xUp(e:MouseEvent):void { 
			TweenLite.to(camera, 1, {ease:Back.easeOut, x:camera.x + 100  } );
		}
		
		private function xDown(e:MouseEvent):void {
			TweenLite.to(camera, 1, {ease:Back.easeOut, x:camera.x - 100 } );
		}
		
		private function yUp(e:MouseEvent):void { 
			TweenLite.to(camera, 1, {ease:Back.easeOut, y:camera.y - 100 } );
		}
		
		private function yDown(e:MouseEvent):void { 
			TweenLite.to(camera, 1, {ease:Back.easeOut, y:camera.y + 100 } );
		}
		
		private function zUp(e:MouseEvent):void { 
			TweenLite.to(camera, 1, {ease:Back.easeOut, z:camera.z + 100 } );
		}
		
		private function zDown(e:MouseEvent):void { 
			TweenLite.to(camera, 1, {ease:Back.easeOut, z:camera.z - 100 } );
		}
		
		private function focusUp(e:MouseEvent):void { 
			TweenLite.to(camera, 1, {ease:Back.easeOut, focusDistance:camera.focusDistance + 100 } );
		}
		
		private function focusDown(e:MouseEvent):void { 
			TweenLite.to(camera, 1, {ease:Back.easeOut, focusDistance:camera.focusDistance - 100 } );
		}
		
		private function angleUp(e:MouseEvent):void{
			TweenLite.to(camera, 1, {ease:Back.easeOut, angle:camera.angle + 25 } );
		}
		
		private function angleDown(e:MouseEvent):void { 
			TweenLite.to(camera, 1, {ease:Back.easeOut, angle:camera.angle - 25 } );
		}
		
		private function rotationUp(e:MouseEvent):void { 
			TweenLite.to(camera, 1, {ease:Back.easeOut, rotation:camera.rotation + 45 } );
		}
		
		private function rotationDown(e:MouseEvent):void { 
			TweenLite.to(camera, 1, {ease:Back.easeOut, rotation:camera.rotation - 45 } );
		}
		
		private function dof(e:MouseEvent):void{
			fxDof.enable = !fxDof.enable;
		}
		
		private function details(e:MouseEvent):void{
			_renderStatsGraph.visible = !_renderStatsGraph.visible;
		}
		
		private function fog(e:MouseEvent):void {
			//ls.useFog = !ls.useFog;
			fxFog.enable = !fxFog.enable;
		}
		
	}	
}