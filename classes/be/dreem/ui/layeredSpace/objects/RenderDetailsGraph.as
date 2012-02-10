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

package be.dreem.ui.layeredSpace.objects {
	
	import be.dreem.ui.layeredSpace.data.RenderStats;

	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.display.*;
	import flash.text.*;

	public class RenderDetailsGraph extends Sprite {
		
		private var _shBg:Shape;
		private var _shFrameRate:Shape;
		private var _tf:TextField;
		
		private var _renderStats:RenderStats;
		private var _nRenderWidth:Number;
		private var _nRenderHeight:Number = 20;
		
		public function RenderDetailsGraph(renderWidth:Number = 100) {
			
			_nRenderWidth = renderWidth;
			
			mouseChildren = mouseEnabled = buttonMode = false;
			
			_shBg = new Shape();
			_shFrameRate = new Shape();
			_tf = new TextField();
		
			addChild(_shBg);
			addChild(_shFrameRate);
			addChild(_tf);
			
			blendMode = BlendMode.LAYER;
			alpha = .9;
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true);
			addEventListener(Event.ENTER_FRAME, onRenderDetailsGraphEnterFrame, false, 0, true);
		}
		
		private function onRenderDetailsGraphEnterFrame(e:Event):void {
			
		}
		
		private function onAddedToStage(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			init();
		}
		
		private function init():void{
			
		}
		
		private function updateFrameRate():void {			
			_shFrameRate.graphics.clear();
			//_shFrameRate.graphics.beginFill(0x5AF72E);
			//_shFrameRate.graphics.beginFill(0x4488DD);
			_shFrameRate.graphics.beginFill(0xFF6600);
			
			if(stage && _renderStats)
				_shFrameRate.graphics.drawRoundRect(0, 0, _nRenderWidth * ((_renderStats.currentFps > stage.frameRate) ? 1 : _renderStats.currentFps / stage.frameRate), _nRenderHeight, 4, 4);
			
			_shFrameRate.graphics.endFill();
		}
		
		private function updateRenderStats():void {
			_tf.text = _renderStats.toString();
			updateFrameRate();
		}
		
		private function createRenderStats():void {
			
			//BG
			_shBg.graphics.clear();
			_shBg.graphics.beginFill(0x000000);
			_shBg.graphics.drawRoundRect(0, 0, _nRenderWidth, _nRenderHeight, 4, 4);
			_shBg.graphics.endFill();
			///*
			
			//framerate
			updateFrameRate();
			
			//txt
			_tf.height = 1;
			_tf.autoSize = TextFieldAutoSize.LEFT;
			_tf.x = 2;
			_tf.textColor = 0xFFFFFF;
		}
		
		//GETTERS SETTERS
		
		public function get renderStats():RenderStats { return _renderStats; }
		
		public function set renderStats(value:RenderStats):void {
			_renderStats = value;
			updateRenderStats();
		}
		
		public function get renderWidth():Number { return _nRenderWidth; }
		
		public function set renderWidth(value:Number):void {
			_nRenderWidth = value;
			createRenderStats();
		}
		
	}
	
}