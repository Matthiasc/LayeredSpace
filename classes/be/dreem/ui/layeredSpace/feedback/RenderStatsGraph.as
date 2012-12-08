package be.dreem.ui.layeredSpace.feedback {
	import be.dreem.ui.layeredSpace.data.RenderStats;
	import be.dreem.ui.layeredSpace.objects.LayeredSpace;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author 
	 */
	public class RenderStatsGraph extends Sprite {
		
		private var _ls:LayeredSpace;
		private var _tfLabels:TextField;
		private var _tfValues:TextField;
		
		private const _graphWidth:int = 150;
		
		private var _graph:Bitmap;
		private const _numberOfSections:int = 2;
		private const _sectionHeight:int = 20;
		private const _sectionColor:int = 0x333333;
		
		private var _maxLayersRendered:int = 0;
		
		private var _autoDim:Boolean = true;
		
		public var toggleKey:String = "Z";
		
		public function RenderStatsGraph(pLayeredSpace:LayeredSpace = null) {
			
			_tfLabels = new TextField();
			_tfLabels.autoSize = TextFieldAutoSize.LEFT;
			_tfLabels.multiline = false;
			_tfLabels.textColor = 0xFFFFFF;
			_tfLabels.defaultTextFormat = new TextFormat("Arial", null, 0xFFFFFF);
			_tfLabels.mouseEnabled = false;
			
			_tfLabels.text = "LayeredSpace: ";			
			_tfLabels.setTextFormat(new TextFormat("Arial", null, 0xFF6666), _tfLabels.length - 1);
			_tfLabels.appendText("\ncurrentFps: ");			
			_tfLabels.setTextFormat(new TextFormat("Arial", null, 0xFF6666 - 0x555555), _tfLabels.length -1);
			_tfLabels.appendText("\naverageFps: ");			
			_tfLabels.setTextFormat(new TextFormat("Arial", null, 0x66FF66), _tfLabels.length -1 );
			_tfLabels.appendText("\nlayers: ");			
			_tfLabels.setTextFormat(new TextFormat("Arial", null, 0x66FF66 - 0x555555), _tfLabels.length -1);
			_tfLabels.appendText("\nviewed layers: ");			
			_tfLabels..setTextFormat(new TextFormat("Arial", null, 0xFFFFFF), _tfLabels.length -1);
			_tfLabels.appendText("\nmemory (MB): ");
			
			_tfValues = new TextField();
			_tfValues.autoSize = TextFieldAutoSize.LEFT;
			_tfValues.multiline = false;
			_tfValues.textColor = 0xFFFFFF;
			_tfValues.defaultTextFormat = new TextFormat("Arial", null, null, null, null, null, null, null, "right");
			_tfValues.mouseEnabled = false;			
			
			_graph = new Bitmap(new BitmapData(_graphWidth, _numberOfSections * _sectionHeight + _numberOfSections - 1,false,0));
			_graph.y = _tfLabels.height + 4;
			
			addChild(_tfLabels);
			addChild(_tfValues);
			addChild(_graph);
			
			alpha = .8;
			
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, false, 0, true);
			
			layeredSpace = pLayeredSpace;
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true);					
		}
		
		private function onAddedToStage(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onStageKeyDown, false, 0, true);	
		}
		
		private function onStageKeyDown(e:KeyboardEvent):void {			
			if (String.fromCharCode(e.charCode).toUpperCase() == toggleKey.toUpperCase()) {
				visible = !visible;
			}
		}
		
		private function onMouseDown(e:MouseEvent):void {
			addEventListener(MouseEvent.MOUSE_UP, onMouseUp, false, 0, true);
			alpha = .3;
			startDrag();
		}
		
		private function onMouseUp(e:MouseEvent):void {
			stopDrag();
			alpha = .8;
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, false, 0, true);
		}
		
		private function updateStats():void {
			var stats:RenderStats = _ls.getRenderStats();			
			
			//draw sections
			_graph.bitmapData.setPixel(_graph.bitmapData.width - 1, 0, _sectionColor);
			_graph.bitmapData.setPixel(_graph.bitmapData.width - 1, _numberOfSections * _sectionHeight, _sectionColor);
			for (var i:int = 1; i < _numberOfSections; i++) {
				_graph.bitmapData.setPixel(_graph.bitmapData.width - 1, i * (_sectionHeight -1), _sectionColor);
			}
			
			//draw stats
			_maxLayersRendered = (_maxLayersRendered < stats.numberOfLayers) ? stats.numberOfLayers : _maxLayersRendered;			
			
			if (stage) {
				addPointToGraph(0,(stats.currentFps / stage.frameRate), 0xFF6666);
				addPointToGraph(0,(stats.averageFps / stage.frameRate), 0xFF6666 - 0x555555);
			}
			
			addPointToGraph(1,(stats.numberOfLayers / _maxLayersRendered), 0x66FF66);
			addPointToGraph(1,(stats.numberOfViewedLayers / _maxLayersRendered), 0x66FF66 - 0x555555);
			
			
			_graph.bitmapData.scroll(-1, 0);
			
			_tfValues.htmlText =  "v" + LayeredSpace.VERSION + "\n" + stats.currentFps + "\n" + stats.averageFps + "\n" + stats.numberOfLayers + "\n" + stats.numberOfViewedLayers + "\n" + Number(stats.memory / 1024).toPrecision(3);
			_tfValues.x = _graphWidth - _tfValues.width;			
			
			graphics.clear();
			graphics.beginFill(0);
			graphics.drawRect(0, 0, _tfValues.x + _tfValues.width, _tfLabels.height);
			graphics.endFill();
		}
		
		private function addPointToGraph(section:int, ratio:Number, color:Number):void {
			_graph.bitmapData.setPixel(_graph.bitmapData.width - 2, (section * _sectionHeight)+ Math.round(_sectionHeight * (1 - ratio)), color);
		}
		
		public function get layeredSpace():LayeredSpace {
			return _ls;
		}
		
		public function set layeredSpace(value:LayeredSpace):void {
			_ls = value;
			
			if (_ls)
				addEventListener(Event.ENTER_FRAME, function(e:Event){updateStats()});
		}
		
		/**
		 * automatic dim when the cursor leaves
		 */
		public function get autoDim():Boolean {
			return _autoDim;
		}
		
		/**
		 * automatic dim when the cursor leaves
		 */
		public function set autoDim(value:Boolean):void {
			_autoDim = value;
		}
		
	}
	
	

}