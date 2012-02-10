package be.dreem.utils {
	/**
	 * ...
	 * @author Matthias Crommelinck
	 */
	public class DateUtils{
		
		public function DateUtils() {
			
		}
		
		
		/**
		 * calculate the age
		 * @param	birthdate	the day of birth
		 * @param	referenceDate	the day you want to calculate the age to. If null, local "now" time of user computer will be used
		 * @return	the age
		 */
		public static function calculateAge(birthdate:Date, referenceDate:Date = null):Number {
			
			if(!referenceDate)
				referenceDate = new Date();
			
			var currentMonth:Number = referenceDate.getMonth();
			var currentDay:Number = referenceDate.getDate();
			var currentYear:Number = referenceDate.getFullYear();
		 
			var bdMonth:Number = birthdate.getMonth();
			var bdDay:Number = birthdate.getDate();
			var bdYear:Number = birthdate.getFullYear();
			
 			// get the difference in years
			var years:Number = referenceDate.getFullYear() - birthdate.getFullYear();
			// subtract another year if we're before the birth day in the current year
			if (currentMonth < bdMonth || (currentMonth == bdMonth && currentDay < bdDay)) {
				years--;
			}
			
			return years;
		}
	}

}