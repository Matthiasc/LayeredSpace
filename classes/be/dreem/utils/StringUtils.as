package be.dreem.utils {
	/**
	 * ...
	 * @author Matthias Crommelinck
	 */
	public class StringUtils{
		
		public function StringUtils() {
			
		}
		
		/**
		 * Will transform 10000 to 10.000
		 * @param	n
		 * @param	minGroupCount
		 * @param	seperator
		 * @return
		 */
		public static function parseCurrencyToDotNotation(n:Number, minGroupCount:Number = 3, seperator:String = "."):String {
			var s:String = n.toString();
			var nDotCount:int = Math.ceil(s.length / 3) - 1;

			for (var i:int = 0; i <nDotCount; i++) {
				var l:Number = ((i + 1) * 3) + i;
				s = s.substr(0, s.length - l) + seperator + s.substr(s.length - l);
			}
			
			return s;
		}
		
		public static function isGuid(guid:String):Boolean {
			return new RegExp("^(\{{0,1}([0-9a-fA-F]){8}-([0-9a-fA-F]){4}-([0-9a-fA-F]){4}-([0-9a-fA-F]){4}-([0-9a-fA-F]){12}\}{0,1})$", "i").test(guid);
		}
		
		public static function isEmail(email:String):Boolean {		
			var re:RegExp = /([a-z0-9._-]+?)@([a-z0-9.-]+)\.([a-z]{2,4})/;
			return re.test(email);
		}
	}

}