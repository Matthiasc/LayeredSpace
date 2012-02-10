package  demos {
	
	import be.dreem.ui.layeredSpace.cameras.*;
	import be.dreem.ui.layeredSpace.constants.*;
	import be.dreem.ui.layeredSpace.effects.DofEffect;
	import be.dreem.ui.layeredSpace.effects.FogEffect;
	import be.dreem.ui.layeredSpace.layers.*;
	import be.dreem.ui.layeredSpace.geom.*;
	import be.dreem.ui.layeredSpace.objects.*;
	import be.dreem.ui.layeredSpace.screens.*;
	import com.greensock.easing.Sine;
	import com.greensock.easing.Expo;
	import com.greensock.OverwriteManager;
	import com.greensock.plugins.GlowFilterPlugin;
	import flash.geom.Point;
	import com.greensock.TweenLite;

	import flash.display.*;
	import flash.events.*;
	import flash.geom.Rectangle;
	
	/**
	* ...
	* @author Matthias Crommelinck
	*/
	public class Particle02 extends MovieClip {
		
		private var _layeredSpace:LayeredSpace;
		private var _camera:StandardCamera;
		private var _screen:StandardScreen;
		
		
		private var _trails:Array;
		private const _numberOfTrails:int = 1;
		
		private var _glow:VisualLayer;
		
		public function Particle02() {
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = StageQuality.LOW;
			
			//layeredspace setup
			_layeredSpace = new LayeredSpace();
			_layeredSpace.sortingMode = SortingModes.LAYER;
			
			_screen = new StandardScreen(new Rectangle(0, 0, 400, 200));
			_screen.backgroundColor = 0x999999;
			_screen.showBackground = false;
			//_screen.blendMode = BlendMode.ADD;			
			
			_camera = new StandardCamera();
			
			_layeredSpace.camera = _camera;
			_camera.screen = _screen;
			//_screen.showRenderDetails = true;
			
			//camera
			//_camera.useDepthOfField = true;
			//_camera.depthOfFieldValue = 20;
			//_camera.viewingDistanceStart = 400;
			//_camera.viewingDistanceEnd = 4000;
			
			var fogEffect:FogEffect = new FogEffect();
			fogEffect.value = .1;
			fogEffect.fogMode = FogModes.ALPHA;
			_layeredSpace.effects.add(fogEffect);
			
			var dofEffect:DofEffect = new DofEffect();
			dofEffect.value = 1;
			dofEffect.quality = 1;
			_layeredSpace.effects.add(dofEffect);
			//dofEffect.enable = false;
			
			addChild(_screen);
			
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
			_trails = new Array();			
			for (var i:int = 0; i < _numberOfTrails; i++) {				
				_trails.push(new Point3D(Math.random() * 1000, Math.random() * 1000, - 8000));
				moveXPoint(_trails[i]);
				moveYPoint(_trails[i]);
				moveZPoint(_trails[i]);
			}
		}
		
		private function updatePoint():void {
			
			//_movingVector.x = ((stage.mouseX- (stage.stageWidth * .5)) / stage.stageWidth) * 20;
			//_movingVector.y = ((stage.mouseY - (stage.stageHeight * .5)) / stage.stageHeight) * 20;			
			//_movingPoint.add(_movingVector);
			
			for (var i:int = 0; i < _trails.length; i++)
				placeParticle(_trails[i]);
			
			if (!_glow) {
				
				_glow = _layeredSpace.addLayer(new VisualLayer(new Glow())) as VisualLayer;
				_glow.container.blendMode = BlendMode.ADD;
			}
				
			_glow.position = Point3D(_trails[0]);
			_glow.scale = .7 + Math.random() * .3;
			_glow.container.alpha = .7 + Math.random() * .3;
				
			shakeCamera(1 - (Point3D(_trails[0]).z / -8000));
			//_camera.focusToPoint(_movingPoint);
		}
		
		///*
		private function moveZPoint(p:Point3D):void {			
			TweenLite.to(p, 14, {overwrite:OverwriteManager.NONE, ease:Sine.easeInOut, z:(p.z == -8000) ? 0 : -8000,onCompleteParams:[p], onComplete:moveZPoint} );
		}
		
		private function moveYPoint(p:Point3D):void {
			TweenLite.to(p, 5 + Math.random() * 3, {overwrite:OverwriteManager.NONE, ease:Sine.easeInOut, y:(p.y == -800) ? 0 : -800,onCompleteParams:[p], onComplete:moveYPoint} );
		}
		
		private function moveXPoint(p:Point3D):void {
			TweenLite.to(p, 5 + Math.random() * 3, { overwrite:OverwriteManager.NONE, ease:Sine.easeInOut, x:(p.x == -800) ? 0 : -800, onCompleteParams:[p], onComplete:moveXPoint });
		}
		
		private function shakeCamera(ratio:Number):void {
			ratio = Math.pow(ratio, 3);
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