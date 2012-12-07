package  demos {
	
	import be.dreem.ui.layeredSpace.cameras.*;
	import be.dreem.ui.layeredSpace.constants.*;
	import be.dreem.ui.layeredSpace.effects.DofEffect;
	import be.dreem.ui.layeredSpace.effects.FogEffect;
	import be.dreem.ui.layeredSpace.feedback.RenderStatsGraph;
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
		
		private var _renderStatGraph:RenderStatsGraph;
		
		
		private var _trails:Array;
		private const NUMBER_OF_TRAILS:int = 2;
		
		private var _glowCollection:Array;
		
		public function Particle02() {
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = StageQuality.LOW;
			
			//layeredspace setup
			_layeredSpace = new LayeredSpace();
			_layeredSpace.sortingMode = SortingModes.LAYER;
			
			//screen
			_screen = new StandardScreen(new Rectangle(0, 0, 400, 200));
			_screen.backgroundColor =0// 0x999999;
			_screen.showBackground = true;
			_screen.blendMode = BlendMode.ADD;			
			
			//camera
			_camera = new StandardCamera();
			_camera.angle = 110;
			_camera.focusDistance
			
			//linkage
			_layeredSpace.camera = _camera;
			_camera.screen = _screen;
			
			var fogEffect:FogEffect = new FogEffect();
			fogEffect.value = .09;
			fogEffect.fogMode = FogModes.ALPHA;
			_layeredSpace.effects.add(fogEffect);
			
			var dofEffect:DofEffect = new DofEffect();
			dofEffect.value = 1.5;
			dofEffect.quality = 2;
			_layeredSpace.effects.add(dofEffect);
			
			addChild(_screen);
			
			//events
			stage.addEventListener(Event.RESIZE, onStageResize, false, 0, true);
			addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
			
			updateDimensions();
			
			//create trails
			_glowCollection = new Array();
			_trails = new Array();			
			for (var i:int = 0; i < NUMBER_OF_TRAILS; i++) {				
				_trails.push(new Point3D(Math.random() * 1000, Math.random() * 1000, - 7000));
				moveXPoint(_trails[i]);
				moveYPoint(_trails[i]);
				moveZPoint(_trails[i]);
			}
			
			_renderStatGraph = new RenderStatsGraph(_layeredSpace);
			addChild(_renderStatGraph);
		}
		
		private function updatePoint():void {
				
			for (var i:int = 0; i < _trails.length; i++){
				placeParticle(_trails[i]);
			
				if (!_glowCollection[i]) {
					_glowCollection[i] = _layeredSpace.addLayer(new VisualLayer(new Glow())) as VisualLayer;
					VisualLayer(_glowCollection[i]).container.blendMode = BlendMode.ADD;
				}
					
				VisualLayer(_glowCollection[i]).position = Point3D(_trails[i]);
				VisualLayer(_glowCollection[i]).scale = .7 + Math.random() * .3;
				VisualLayer(_glowCollection[i]).container.alpha = .7 + Math.random() * .3;			
			}
			
			shakeCamera(1 - (Point3D(_trails[0]).z / -7000));
		}
		
		private function moveZPoint(p:Point3D):void {			
			TweenLite.to(p, 14, {overwrite:OverwriteManager.NONE, ease:Sine.easeInOut, z:(p.z == -7000) ? 0 : -7000,onCompleteParams:[p], onComplete:moveZPoint} );
		}
		
		private function moveYPoint(p:Point3D):void {
			TweenLite.to(p, 2 + Math.random() * 2, {overwrite:OverwriteManager.NONE, ease:Sine.easeInOut, y:(p.y == -800) ? 0 : -800,onCompleteParams:[p], onComplete:moveYPoint} );
		}
		
		private function moveXPoint(p:Point3D):void {
			TweenLite.to(p, 2 + Math.random() * 2, { overwrite:OverwriteManager.NONE, ease:Sine.easeInOut, x:(p.x == -800) ? 0 : -800, onCompleteParams:[p], onComplete:moveXPoint });
		}
		
		private function shakeCamera(ratio:Number):void {
			ratio = Math.pow(ratio, 3);
			_camera.x = ((Math.random() > .5) ? -1 : 1) * Math.random() * 15 * ratio;
			_camera.y = ((Math.random() > .5) ? -1 : 1) * Math.random() * 15 * ratio;
			_camera.z = 1000 + ((Math.random() > .5) ? -1 : 1) * Math.random() * 15 * ratio; 
		}
			
		private function placeParticle(p:Point3D):void {
			var particle:DisplayObject = createSmokeParticle();
			var vl:VisualLayer = new VisualLayer(particle);
			vl.rotation = Math.random() * 180;
			_layeredSpace.addLayer(vl).position = p;
			TweenLite.to(particle, 1 + Math.random(), { delay:.1, ease:Expo.easeIn, alpha:0, onComplete:onParticleComplete, onCompleteParams:[vl], onUpdate:onSmokeParticleUpdate, onUpdateParams:[vl] } );
						
			particle = createFireParticle();
			
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
			vl.scale += 0.05;
		}
		
		private function onParticleComplete(vl:VisualLayer):void {
			vl.removeLayer = true;
		}
		
		private function createSmokeParticle():MovieClip {
			var mc:MovieClip = new SmokeParticle();
			mc.gotoAndStop(1 + Math.round(Math.random() * (mc.totalFrames -1 )));
			return mc;
		}
		
		private function createFireParticle():MovieClip {
			var mc:MovieClip = new FireParticle();
			mc.gotoAndStop(1 + Math.round(Math.random() * (mc.totalFrames -1 )));
			return mc;
		}
		
		private function onMouseWheel(e:MouseEvent):void {
			_camera.z += 10 * e.delta;
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
			_screen.dimensions = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
		}
		
	}
	
}

