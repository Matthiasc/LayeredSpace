package be.dreem.ui.layeredSpace.control {
	import be.dreem.ui.layeredSpace.objects.CameraObject;
	import com.greensock.TweenLite;
	import flash.display.Shape;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	/**
	 * KeyboardControl lets you have basic control over a camera through keyboard
	 * @author Matthias Crommelinck
	 */
	public class KeyboardControl {
		
		public static const X_UP:String = "xUp";
		public static const X_DOWN:String = "xDown";
		
		public static const Y_UP:String = "yUp";
		public static const Y_DOWN:String = "yDown";
		
		public static const Z_UP:String = "zUp";
		public static const Z_DOWN:String = "zDown";		
		
		public static const ROTATE_CW:String = "rotateCw";
		public static const ROTATE_CCW:String = "rotateCcw";
		
		public static const ANGLE_UP:String = "angleUp";
		public static const ANGLE_DOWN:String = "angleDown";
		
		public static const FOCUS_UP:String = "focusUp";
		public static const FOCUS_DOWN:String = "focusDown";
		
		public static const TRACE_CAMERA_PROPERTIES:String = "traceCameraProperties";
		
		/**
		 * Time needed to tween each movement in ms
		 */
		public var speed:Number = 250;
		
		
		private var _shape:Shape;
		private var _oTween:Object;
			
		/**
		 * qwerty keyboard, can use other bindings for azerty
		 */
		private var _keyBinding:Array = [
													["Q", X_UP],
													["A", X_DOWN],
													
													["W", Y_UP],
													["S", Y_DOWN],
													
													["E", Z_UP],
													["D", Z_DOWN],
													
													["R", ROTATE_CW],
													["F", ROTATE_CCW],
													
													["T", FOCUS_UP],
													["G", FOCUS_DOWN],
													
													["Y", ANGLE_UP],
													["H", ANGLE_DOWN],
													
													["C", TRACE_CAMERA_PROPERTIES]
		
												];
												
		private var _controlBinding:Array = [
													[X_UP, "x", 100],
													[X_DOWN, "x", -100],
													
													[Y_UP, "y", 100],
													[Y_DOWN, "y", -100],
													
													[Z_UP, "z", 100],
													[Z_DOWN, "z", -100],
													
													[ROTATE_CW, "rotation", 10],
													[ROTATE_CCW, "rotation", -10],
													
													[FOCUS_UP, "focusDistance", 100],
													[FOCUS_DOWN, "focusDistance", -100],
													
													[ANGLE_UP, "angle", 10],
													[ANGLE_DOWN, "angle", -10]
		
												];
		
		private var _camera:CameraObject;
		private var _stage:Stage;
		
		public function KeyboardControl(stage:Stage) {
			_stage = stage;
			_stage.addEventListener(KeyboardEvent.KEY_DOWN, onStageKeyDown, false, 0, true);	
			
			_shape = new Shape();
		}
		
		private function onStageKeyDown(e:KeyboardEvent):void {
			/*
			if (parseInt(String.fromCharCode(e.charCode))) {
				//switch camera
				_camera = _cameraCollection[parseInt(String.fromCharCode(e.charCode))-1];
			}else {
				*/
				//commands
				var com:String = getCommandForKey(String.fromCharCode(e.charCode));				
				if (com) 
					command(com, e.shiftKey);
			//}
		}
		
		private function getCommandForKey(key:String):String {
			key = key.toUpperCase();
			
			for (var i:int = 0; i < _keyBinding.length; i++)
				if (key == _keyBinding[i][0])
					return _keyBinding[i][1];
			
			return null;
		}
		
		/**
		 * Control the camera through commands
		 * @param	command		example: X_UP
		 * @param	slow		if true, camera movement will be slower
		 */
		public function command(command:String, slow:Boolean = false) {
			if(!_oTween &&_camera && command)						
				if (command == TRACE_CAMERA_PROPERTIES) {
					trace(_camera.toString());
				}else {
					var a:Array;					
					for (var i:int = 0; i < _controlBinding.length; i++)
						if (command == _controlBinding[i][0])
							a = _controlBinding[i];
					
					createTween(_camera, speed * ((slow) ? .5 : 1 ), a[1], a[2]* ((slow) ? .5 : 1 ));
				}
		}
		
		private function createTween(camera:CameraObject, duration:Number, propertyName:String, propertyIncrement:Number) {			
			_oTween = {camera:camera, prop: propertyName, propStart: camera[propertyName], propEnd: camera[propertyName] + propertyIncrement, duration:duration, durationStart:new Date().getTime(), durationEnd:new Date().getTime() + duration }
			_shape.addEventListener(Event.ENTER_FRAME, onShapeEnterFrame, false, 0, true);
			tween();
		}	
		
		private function onShapeEnterFrame(e:Event):void {
			tween();
		}
		
		private function tween() {
			if (_oTween) {
				var now:Number = new Date().getTime();
				
				if (now >= _oTween.durationEnd) {					
					//target reached, stop tween
					_oTween.camera[_oTween.prop] = _oTween.propEnd;
					_oTween = null;
					_shape.removeEventListener(Event.ENTER_FRAME, onShapeEnterFrame);					
				}else {
					//tween
					var timeRatio:Number = (now - _oTween.durationStart) / (_oTween.durationEnd - _oTween.durationStart);
					_oTween.camera[_oTween.prop] = ((Math.pow(timeRatio, 4) ) *  (_oTween.propEnd - _oTween.propStart)) + _oTween.propStart; 
				}				
			}
		}
		
		/**
		 * the camera being controlled
		 */
		public function get camera():CameraObject {
			return _camera;
		}				
		
		/**
		 * the camera being controlled
		 */		
		public function set camera(value:CameraObject):void {
			_camera = value;
		}
	}
}