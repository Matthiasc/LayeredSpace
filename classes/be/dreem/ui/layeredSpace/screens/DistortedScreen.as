package be.dreem.ui.layeredSpace.screens {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.filters.*;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author 
	 */
	public class DistortedScreen extends StandardScreen {		
		
		private var _bm:Bitmap;
		
		public function DistortedScreen(pDimensions:Rectangle)  {
			super(pDimensions);
			
			_bm = new Bitmap(null);
			//_bm.filters = [new BlurFilter(10, 10)];
			//_bm.alpha = .5;
			//_bm.blendMode = BlendMode.ADD;
			addChild(_bm);
			addChild(_spContainer);
			
			_spScreen.addEventListener(Event.ENTER_FRAME, onScreenRender, false, 0, true);
		}
		
		private function onScreenRender(e:Event):void {
			//trace("RENDER");
			new ConvolutionFilter
			if (_bm) 
				if (_bm.bitmapData) {
					//_spScreen.alpha = .5;
					_bm.bitmapData.floodFill
					_bm.bitmapData.draw(_spScreen, new Matrix(1, 0, 0, 1, -dimensions.x, -dimensions.y), null, BlendMode.ADD);
					_bm.bitmapData.applyFilter(_bm.bitmapData, new Rectangle(0, 0, dimensions.width, dimensions.height), new Point(), new BlurFilter());
					//_spScreen.alpha = 1;
				}
		}
		
		override protected function update():void {
			super.update();
			
			if (dimensions && _bm) {
				_bm.x = dimensions.x;
				_bm.y = dimensions.y;
				_bm.bitmapData = new BitmapData(dimensions.width, dimensions.height, true, 0xFFFFFF);
			}
		}
		
	}

}