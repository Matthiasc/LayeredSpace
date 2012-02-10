/**
* Copyright (c) 2009 Matthias Crommelinck
* 
* Permission is hereby granted, free of charge, to any person
* obtaining a copy of this software and associated documentation
* files (the "Software"), to deal in the Software without
* restriction, including without limitation the rights to use,
* copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the
* Software is furnished to do so, subject to the following
* conditions:
* 
* The above copyright notice and this permission notice shall be
* included in all copies or substantial portions of the Software.
* 
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
* OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
* NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
* HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
* OTHER DEALINGS IN THE SOFTWARE.
*/

/**
* @author Matthias Crommelinck
*/

package be.dreem.ui.layeredSpace.screens {
	import be.dreem.ui.layeredSpace.objects.ScreenObject;
	import be.dreem.ui.layeredSpace.objects.VisualObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.*;
	
	/**
	 * a simple rectangular screen
	 * @author 
	 */
	public class CircularScreen extends ScreenObject {		
		
		private var _nRadius:Number;
		private var _pCenter:Point;
		private var _mask:Shape;	
		private var _bMask:Boolean = true;
		private var _bBackground:Boolean = true;
		private var _nBackgroundColor:Number = 0x000000;
		
		public function CircularScreen(pRadius:Number) {
			_nRadius = pRadius;
			_mask = new Shape();
			
			update();
		}
		
		override public function canSeeVisual(visualObject:VisualObject):Boolean {
			//TODO: for now a rectangular approximation of the circular dimensions
			return visualObject.get2dBounds().intersects(new Rectangle(0,0,_nRadius*2, _nRadius*2));
		}
		
		private function update():void {
			_pCenter = new Point(_nRadius, _nRadius);
			
			graphics.clear();
			
			if (_bBackground) {
				graphics.beginFill(_nBackgroundColor);
				graphics.drawCircle(_nRadius, _nRadius, _nRadius);
				graphics.endFill();
			}
				
			if (_bMask) {
				_mask.graphics.clear();
				_mask.graphics.beginFill(0x0FF00);
				_mask.graphics.drawCircle(_nRadius, _nRadius, _nRadius);
				_mask.graphics.endFill();
				
				if (!_spContainer.mask) {
					addChild(_mask);
					_spContainer.mask = _mask;					
				}
			}else {
				if (_spContainer.mask) {
					removeChild(_mask);
					_spContainer.mask = null;					
				}
			}			
		}
		
		override public function getZeroPoint():Point {
			return _pCenter;
		}
		
		
		public function get radius():Number{
			return _nRadius;
		}	
		
		public function set radius(n:Number):void{
			_nRadius = n;
			update();
		}	
		
		public function get maskScreen():Boolean{
			return _bMask;
		}	
		
		public function set maskScreen(b:Boolean):void{
			_bMask = b;
			update();
		}	
		
		public function get showBackground():Boolean {
			return _bBackground;
		}		
		
		public function set showBackground(value:Boolean):void {
			_bBackground = value;
			update();
		}
		
		public function get backgroundColor():Number {
			return _nBackgroundColor;
		}
		
		public function set backgroundColor(value:Number):void {
			_nBackgroundColor = value;
			update();
		}
	}
}



