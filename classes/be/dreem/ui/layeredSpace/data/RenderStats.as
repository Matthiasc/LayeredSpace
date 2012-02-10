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

package be.dreem.ui.layeredSpace.data {
	import be.dreem.ui.layeredSpace.objects.LayeredSpace;
	
	
	public class RenderStats {
		
		
		public var currentFps:int;
		public var averageFps:int;
		public var numberOfViewedLayers:int;
		public var numberOfLayers:int;
		public var memory:Number;							
							
		public function RenderStats(pCurrentFps:Number = 0, pAverageFps:Number=0, pNumberOfViewedLayers:Number = 0, pNumberOfLayers:Number = 0, pMemory:Number = 0) {
			currentFps = pCurrentFps;
			averageFps = pAverageFps;
			numberOfViewedLayers = pNumberOfViewedLayers;
			numberOfLayers = pNumberOfLayers;
			memory = pMemory;
		}
		
		public function clone():RenderStats {
			return new RenderStats(currentFps, averageFps, numberOfViewedLayers, numberOfLayers, memory);
		}
		
		public function toString():String {
			return "RenderStats: version: " + LayeredSpace.VERSION + "\t\tcurrentFps: " + currentFps + "\t\taverageFps: " + averageFps + "\t\tlayers: " + numberOfLayers + "\t\tviewed layers: " + numberOfViewedLayers + "\t\tmemory: " + Number(memory/1024).toPrecision(3) + "MB";
		}
		
		//GETTERS
		/*
		public function get memory():Number { return  }
		
		public function get numberOfViewedLayers():Number { return _nNumberOfViewedLayers; }
		
		public function get numberOfLayers():Number { return _nNumberOfLayers; }
		
		public function get currentFps():Number { return _nCurrentFps; }
		//*/
		
		//SETTERS
		/*
		public function set currentFps(value:Number):void {
			_nCurrentFps = value;
		}
		
		public function set numberOfLayers(value:Number):void {
			_nNumberOfLayers = value;
		}
		
		public function set numberOfViewedLayers(value:Number):void {
			_nNumberOfViewedLayers = value;
		}
		//*/
		
	}
	
}