package  demos {
	
	import be.dreem.ui.layeredSpace.cameras.*;
	import be.dreem.ui.layeredSpace.constants.*;
	import be.dreem.ui.layeredSpace.effects.*;
	import be.dreem.ui.layeredSpace.feedback.*;
	import be.dreem.ui.layeredSpace.layers.*;
	import be.dreem.ui.layeredSpace.geom.*;
	import be.dreem.ui.layeredSpace.objects.*;
	import be.dreem.ui.layeredSpace.screens.*;
	import com.greensock.easing.*;
	import com.greensock.*;
	import com.greensock.plugins.*;
	import flash.geom.*;
	import com.greensock.*;

	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	
	/**
	* ...
	* @author Matthias Crommelinck
	*/
	public class Particle03 extends MovieClip {
		
		public var sunGlow:Sprite;
		
		private var _layeredSpace:LayeredSpace;
		private var _camera:StandardCamera;
		private var _screen:StandardScreen;
		
		private var _meteors:Array;
		private const _numberOfMeteors:int = 1;
		
		private var _glow:VisualLayer;
		
		private var tracker:Sprite;
		
		private var _renderStatsGraph:RenderStatsGraph;
		
		public function Particle03() {
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = StageQuality.LOW;
			
			//layeredspace setup
			_layeredSpace = new LayeredSpace();
			_layeredSpace.sortingMode = SortingModes.NONE;
			
			_screen = new StandardScreen(new Rectangle(0, 0, 400, 200));
			_screen.backgroundColor = 0x999999;
			_screen.showBackground = false;
			//_screen.blendMode = BlendMode.ADD;		
			
			//camera
			_camera = new StandardCamera();
			_camera.focusDistance = 1000;
			
			_layeredSpace.camera = _camera;
			_camera.screen = _screen;
			
			_renderStatsGraph = new RenderStatsGraph(_layeredSpace);
			
			
			
			
			var fogEffect:FogEffect = new FogEffect();
			fogEffect.value = .05;
			fogEffect.fogMode = FogModes.ALPHA;
			//_layeredSpace.effects.add(fogEffect);
			
			var dofEffect:DofEffect = new DofEffect();
			dofEffect.value = 3;
			dofEffect.quality = 1;
			_layeredSpace.effects.add(dofEffect);
			
			
			tracker = new Tracker() as Sprite;
			
			
			addChild(_screen);
			addChild(sunGlow);
			addChild(tracker);
			addChild(_renderStatsGraph);
			
			//_movingPoint = new Point3D();
			//_movingPoint2 = new Point3D(1000,1000,-5000);
			//_movingVector = new Point3D(0, 0, -10);			
			
			//events
			stage.addEventListener(Event.RESIZE, onStageResize, false, 0, true);
			addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
			addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, false, 0, true);
			addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel, false, 0, true);
			
			updateDimensions();
			
			//create trails
			_meteors = new Array();			
			for (var i:int = 0; i < _numberOfMeteors; i++) {				
				_meteors.push(randomMeteor());
				//launchMeteor(_meteors[i]);
			}
		}
		
		private function randomMeteor():Object {
			return {vector:new Point3D(10 + Math.random() * 10, 30 + Math.random() * 30, 0), position:_layeredSpace.projectPointOnZdepth(new Point3D((Math.random() * 800 )-400,-400,0), Math.random()* -8000)}
		}
		
		private function updatePoint():void {
			
			//_movingVector.x = ((stage.mouseX- (stage.stageWidth * .5)) / stage.stageWidth) * 20;
			//_movingVector.y = ((stage.mouseY - (stage.stageHeight * .5)) / stage.stageHeight) * 20;			
			//_movingPoint.add(_movingVector);
			
			var pProjected:Point3D;
			
			for (var i:int = 0; i < _meteors.length; i++) {
				
				//speed, position increment
				Point3D(_meteors[i].position).add(_meteors[i].vector);
				
				//check below screen bounds
				
				pProjected = _layeredSpace.projectPointOnZdepth(Point3D(_meteors[i].position), 0);
				if (pProjected.x > 400 || pProjected.y > 400 ) {
					_meteors[i] = randomMeteor();
				}
				
				placeParticle(_meteors[i].position);
			}
			
			tracker.x = _layeredSpace.projectPointOnZdepth(Point3D(_meteors[0].position), 0).x + 400;
			tracker.y = _layeredSpace.projectPointOnZdepth(Point3D(_meteors[0].position), 0).y + 400;
			tracker.rotation-= 10;
			
			if (!_glow) {				
				_glow = _layeredSpace.addLayer(new VisualLayer(new Glow())) as VisualLayer;
				_glow.container.blendMode = BlendMode.ADD;
			}
				///*
			_glow.position = Point3D(_meteors[0].position);
			_glow.scale = .7 + Math.random() * .3;
			_glow.container.alpha = .7 + Math.random() * .3;
				//*/
			//shakeCamera(1 - (Point3D(_meteors[0]).z / -8000));
			//_camera.focusToPoint(_movingPoint);
		}
		/*
		private function launchMeteor(p:Point3D):void {
			trace("launchMeteor " + p);
			var pDestination:Point3D = _layeredSpace.projectPointOnZdepth(new Point3D((Math.random() * 800) - 400, 400, 0), Math.random() * -8000);
			TweenLite.to(p, 10, {overwrite:OverwriteManager.NONE, y:pDestination.y, x:pDestination.x, z:pDestination.z,onCompleteParams:[p], onComplete:onLaunchMeteorComplete} );
		}
		
		private function onLaunchMeteorComplete(p:Point3D):void {
			_meteors[0] = p = _layeredSpace.projectPointOnZdepth(new Point3D( -400, -400, 0), -8000);
			launchMeteor(p);
		}
		*/
		
		private function shakeCamera(ratio:Number):void {
			ratio = Math.pow(ratio, 3);
			///*
			ratio = 0;
			//*/
			_camera.x = ((Math.random() > .5) ? -1 : 1) * Math.random() * 20 * ratio;
			_camera.y = ((Math.random() > .5) ? -1 : 1) * Math.random() * 20 * ratio;
			_camera.z = 1000 + ((Math.random() > .5) ? -1 : 1) * Math.random() * 20 * ratio; 
		}
		//*/
		
		/*
		private function onMovePointZComplete():void {
			launchPoint();
		}
		//*/
		
		/*
		private function onPointUpdate():void {
			//if(Math.random() > .3)
				placeParticle();
		}
		*/
		
		private function placeParticle(p:Point3D):void {
			var particle:DisplayObject = createSmokeParticle();
			var vl:VisualLayer = new VisualLayer(particle);
			//vl.container.blendMode  = BlendMode.MULTIPLY;
			//vl.content.blendMode  = BlendMode.MULTIPLY;
			//vl.showAnchorPoint = true;
			vl.rotation = Math.random() * 180;
			_layeredSpace.addLayer(vl).position = p;
			//particle.alpha = .5 + (Math.random() * .5);
			TweenLite.to(particle, 2 + Math.random(), { delay:.1, ease:Expo.easeIn, alpha:0, onComplete:onParticleComplete, onCompleteParams:[vl], onUpdate:onSmokeParticleUpdate, onUpdateParams:[vl] } );
			
			
			particle = createFireParticle();
			//particle.blendMode = BlendMode.ADD;
			
			vl = new VisualLayer(particle);
			vl.container.blendMode = BlendMode.ADD;
			vl.rotation = Math.random() * 180;
			vl.scale = 1;
			_layeredSpace.addLayer(vl).position = p;
			
			TweenLite.to(particle, 1, {  alpha:0, onComplete:onParticleComplete, onCompleteParams:[vl], onUpdate:onFireParticleUpdate, onUpdateParams:[vl] } );
			
		}
		
		private function onFireParticleUpdate(vl:VisualLayer):void {
			vl.rotation += 5 * Math.pow( vl.content.alpha, 20);
			vl.scale += 0.05;
		}
		
		private function onSmokeParticleUpdate(vl:VisualLayer):void {
			//trace(vl.content.alpha);
			//vl.rotation += 40 * Math.pow( vl.content.alpha, 20);
			vl.scale += 0.05;
		}
		
		private function onParticleComplete(vl:VisualLayer):void {
			vl.removeLayer = true;
		}
		
		private function createSmokeParticle():MovieClip {
			var mc:MovieClip = new SmokeParticle();
			//mc.blendMode = BlendMode.MULTIPLY;
			mc.gotoAndStop(1 + Math.round(Math.random() * (mc.totalFrames -1 )));
			return mc;
		}
		
		private function createFireParticle():MovieClip {
			var mc:MovieClip = new FireParticle();
			//mc.blendMode = BlendMode.MULTIPLY;
			mc.gotoAndStop(1 + Math.round(Math.random() * (mc.totalFrames -1 )));
			return mc;
		}
		
		private function onMouseWheel(e:MouseEvent):void {
			_camera.z += 10 * e.delta;
			//_camera.rotation += 45 * e.delta/2;
		}
		
		private function onMouseMove(e:MouseEvent):void {
			if (e.buttonDown) {
				
				//trace((e.stageX - (stage.stageWidth * .5))/stage.stageWidth);
				//_camera.x = -(e.stageX - (stage.stageWidth * .5));
				//_camera.y = -(e.stageY - (stage.stageHeight * .5));
			}
		}
		
		private function onEnterFrame(e:Event):void {
			updatePoint();
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

class Rocket {
	public function Rocket() {
		
	}
}