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

package be.dreem.ui.layeredSpace.geom {
	import flash.geom.Point;
	
	public class Point3D {
		
		public var x:Number;
		public var y:Number;
		public var z:Number;
		
		function Point3D(pX:Number = 0, pY:Number = 0, pZ:Number = 0){
			x = pX;
			y = pY;
			z = pZ;
		}
		
		/**
		 * adds a 3D point to this instance,
		 * @param	p	the point to add
		 * @return	the updated instance
		 */
		public function add(p:Point3D):Point3D {
			this.x += p.x;
			this.y += p.y;
			this.z += p.z;
			
			return this;
		}
		
		/**
		 * subtracts a 3D point to this instance,
		 * @param	p	the point to subtract
		 * @return	the updated instance
		 */
		public function subtract(p:Point3D):Point3D {
			this.x -= p.x;
			this.y -= p.y;
			this.z -= p.z;
			
			return this;
		}
		
		/**
		 * Multiply this instance with a number
		 * @param	n	the multiplier 
		 * @return	the updated instance
		 */
		public function multiplyByNumber(n:Number):Point3D {
			this.x *= n;
			this.y *= n;
			this.z *= n;
			
			return this;
		}
		
		/**
		 * test if the given point equals this instance
		 * @param	p	the point to test
		 * @return	
		 */
		public function equals(p:Point3D):Boolean {
			return (this.x == p.x) && (this.y == p.y) && (this.z == p.z);
		}
		
		public function toPoint(f:Number, xr:Number = 0, yr:Number = 0, zr:Number = 0):Point {
			var sx:Number = Math.sin(xr);
			var cx:Number = Math.cos(xr);
			var sy:Number = Math.sin(yr);
			var cy:Number = Math.cos(yr);
			var sz:Number = Math.sin(zr);
			var cz:Number = Math.cos(zr);
			var xy:Number = cx * this.y - sx * this.z;
			var xz:Number = sx * this.y + cx * this.z;
			var yz:Number = cy * xz - sy * this.x;
			var yx:Number = sy * xz + cy * this.x;
			var s:Number = f / (f + yz);
			return new Point((cz * yx - sz * xy) * s, (sz * yx + cz * xy) * s);
		}
		
		public static function add(p1:Point3D, p2:Point3D):Point3D {
			return new Point3D(p1.x + p2.x, p1.y + p2.y, p1.z + p2.z);
		}
		
		public static function subtract(p1:Point3D, p2:Point3D):Point3D {
			return new Point3D(p1.x - p2.x, p1.y - p2.y, p1.z - p2.z);
		}
		
		public static function equals(p1:Point3D, p2:Point3D):Boolean {
			return (p1.x == p2.x) && (p1.y == p2.y) && (p1.z == p2.z);
		}
		
		public static function multiplyByNumber(p:Point3D, n:Number):Point3D {
			return new Point3D(p.x * n , p.y * n, p.z * n);
		}
		
		public static function distance(pt1:Point3D, pt2:Point3D):Number {
			return Math.sqrt(Math.pow(pt2.y - pt1.y, 2) + Math.pow(pt2.x - pt1.x, 2) + Math.pow(pt2.z - pt1.z, 2))
		}
		
		public static function interpolate(pt1:Point3D, pt2:Point3D, f:Number):Point3D {
			return new Point3D((pt1.x + pt2.x) * f, (pt1.y + pt2.y) * f, (pt1.z + pt2.z) * f);
		}

		public function toString():String{
			return new String("Point3D: " + x + ", " + y + ", " + z);
		}
		
		public function clone():Point3D {
			return new Point3D(x, y, z);
		}
	}	
}
