package be.dreem.utils {
	/**
	 * ...
	 * @author Matthias Crommelinck
	 */
	public class ArrayUtils{
		
		public function ArrayUtils() {
			
		}
		
		public static function shuffle(array:Array):void {
            var len:Number = array.length; 
            var rand:Number;
            var temp:*;
            
            for(var i:int = 0; i < len; i++) { 
                rand = Math.floor(Math.random()*len); 
                temp = array[i];
                array[i] = array[rand]; 
                array[rand] = temp; 
            }
        } 

		
	}

}