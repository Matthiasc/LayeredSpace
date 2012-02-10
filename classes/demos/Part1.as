package  demos {
	
	import be.dreem.ui.layeredSpace.*;
	import be.dreem.ui.layeredSpace.cameras.*;
	import be.dreem.ui.layeredSpace.layers.*;
	import be.dreem.ui.layeredSpace.objects.*;
	import be.dreem.ui.layeredSpace.screens.*;
	import flash.events.Event;
	
	import flash.display.*;
	import flash.geom.Rectangle;
	
	/**
	* ...
	* @author Matthias Crommelinck
	*/
	public class Part1 extends MovieClip {
		
		/**
		 * _layeredSpace is het object dat de wiskundige 3d wereld bevat, er is niks grafish aan het LayeredSpace object
		 */
		private var _layeredSpace:LayeredSpace;
		
		/**
		 * _camera is het object dat de 3d informatie van het _layeredSpace object zal lezen
		 */
		private var _camera:StandardCamera;
		
		/**
		 * het _screen object zal opvangen het geen wat de camera output
		 */
		private var _screen:StandardScreen;
		
		/**
		 * _visualLayer is het object waarmee je layeredSpace kan vullen met visuele objecten (displayObjects).
		 */
		private var _visualLayer:VisualLayer;
		
		public function Part1() {
			
			//we maken onze 3D ruimte aan
			_layeredSpace = new LayeredSpace();
			
			//aanmaken van de canvas 
			_screen = new StandardScreen(new Rectangle(0, 0, 400, 200));
			
			//aanmaken van de camera
			_camera = new StandardCamera();
			
			//we koppelen de canvas aan layeredSpace
			_camera.screen = _screen;
			
			//we koppelen de camera aan de canvas
			_layeredSpace.camera = _camera;
			
			//de standaard positie van de camera staat op (0, 0, 1000)
			
			//we maken onze visualLayer aan
			var spSquare:Sprite = new Sprite();
			spSquare.graphics.beginFill(0x00FF00);
			spSquare.graphics.drawRect(-50, -50, 100, 100);
			spSquare.graphics.endFill();
			
			_visualLayer = new VisualLayer(spSquare);			
			
			//we voegen onze visualLayer toe aan de 3Druimte
			_layeredSpace.addLayer(_visualLayer);
			
			//en om iets te zien te krijgen voegen we onze canvas (het enige layeredSpace object dat een displayObject extend) toe aan de displayList
			addChild(_screen);
			
			//en we updaten de 3D wereld
			_layeredSpace.update();
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void {
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