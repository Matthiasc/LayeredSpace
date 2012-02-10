package  demos {
	
	import be.dreem.ui.layeredSpace.*;
	import be.dreem.ui.layeredSpace.cameras.*;
	import be.dreem.ui.layeredSpace.constants.SortingModes;
	import be.dreem.ui.layeredSpace.effects.DofEffect;
	import be.dreem.ui.layeredSpace.effects.FogEffect;
	import be.dreem.ui.layeredSpace.geom.Point3D;
	import be.dreem.ui.layeredSpace.layers.*;
	import be.dreem.ui.layeredSpace.objects.*;
	import be.dreem.ui.layeredSpace.screens.*;
	import flash.events.*;
	import flash.ui.Keyboard;
	import gs.TweenFilterLite;
	
	import flash.display.*;
	import flash.geom.*;
	
	/**
	* ...
	* @author Matthias Crommelinck
	*/
	public class TopView extends MovieClip {
		
		
		private var _layeredSpace:LayeredSpace;
		private var _camera:StandardCamera;
		private var _screen:StandardScreen;
		
		private var _fogEffect:FogEffect;
		private var _dofEffect:DofEffect;
		
		
		public function TopView() {
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			_layeredSpace = new LayeredSpace();
			_layeredSpace.sortingMode = SortingModes.LAYER;
			
			_screen = new StandardScreen(new Rectangle(0, 0, 400, 200));
			
			_camera = new StandardCamera();
			_camera.roundPoints = true;
			_camera.focusDistance = 1000;
			
			_camera.screen = _screen;
			_layeredSpace.camera = _camera;			
			
			//create map
			createPlane(200, .9, 0xFFFFFF * Math.random());
			createPlane(0, .1, 0xFFFFFF * Math.random());
			createPlane(-200, .9, 0xFFFFFF * Math.random());
			
			//we voegen onze visualLayer toe aan de 3Druimte
			//_layeredSpace.addLayer(vl);
			
			_fogEffect = _layeredSpace.effects.add(new FogEffect()) as FogEffect;
			_fogEffect.fogValue = 2;
			_fogEffect.fogColor = 0;
			_fogEffect.startDistance = _camera.z - 200;
			
			
			_dofEffect = _layeredSpace.effects.add(new DofEffect()) as DofEffect;
			_dofEffect.value = 40;
			//;
			
			addChild(_screen);
			
			//en we updaten de 3D wereld
			_layeredSpace.update();
			
			
			//events
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(Event.RESIZE, onStageResize, false, 0, true);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyBoardKeyDown,false,0,true);
		}
		
		private function onKeyBoardKeyDown(e:KeyboardEvent):void {
			switch(e.keyCode) {
				case Keyboard.LEFT :
					TweenFilterLite.to(_camera, 1, { x: Math.round((_camera.x - 100) * .01) *100 } );
				break;
				
				case Keyboard.RIGHT :
					TweenFilterLite.to(_camera, 1, { x:Math.round((_camera.x + 100) * .01) *100  } );
				break;
				
				case Keyboard.UP :
					TweenFilterLite.to(_camera, 1, { y:Math.round((_camera.y - 100) * .01) *100 } );
				break;
				
				case Keyboard.DOWN :
					TweenFilterLite.to(_camera, 1, { y:Math.round((_camera.y + 100) * .01) *100 } );
				break;
			}
		}
		
		private function createPlane(zDepth:int = 0, holeRatio:Number = 0, color:int = 0xFFFFFF) {
			var mapWidth:int = 20;
			var mapHeight:int = 20;
			var tileSize:int = 100;
			var vl:VisualLayer;
			
			for (var i:int = 0; i < mapHeight; i++)
				for (var j:int = 0; j < mapWidth; j++) 		
					if(Math.random() > holeRatio)
						_layeredSpace.addLayer(new VisualLayer(createTile(tileSize, color))).position = new Point3D((i - (mapWidth *.5))* tileSize, (j - (mapHeight *.5)) * tileSize, zDepth);
		}
		
		private function createTile(dimensions:int = 100, color:int = 0xFFFFFF):Shape {
			var sh:Shape = new Shape();
			sh.graphics.beginFill(color);
			sh.graphics.drawRect( -dimensions *.5, -dimensions *.5, dimensions, dimensions);
			sh.graphics.endFill();			
			return sh;
		}
		
		private function onEnterFrame(e:Event):void {
			_layeredSpace.update();
		}
		
		private function onStageResize(e:Event):void {
			updateDimensions();
		}
		
		private function updateDimensions():void {
			//adjust the dimensions of the canvas
			_screen.dimensions = new Rectangle(100, 100, stage.stageWidth - 200, stage.stageHeight - 200);
		}
		
	}
	
}