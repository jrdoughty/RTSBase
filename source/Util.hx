package;

/**
 * ...
 * @author John Doughty
 */
typedef TwoD = {
	x:Float;
	y:Float;
	width:Float;
	height:Float;
}
 
class Util
{

	public function new() 
	{
		
	}
	
	public static inline function overlap(object1:TwoD, object2:TwoD, callback):Bool
	{
		bool doOverlap(Point l1, Point r1, Point l2, Point r2)
		{
			// If one rectangle is on left side of other
			if (l1.x > r2.x || l2.x > r1.x)
				return false;
		 
			// If one rectangle is above other
			if (l1.y < r2.y || l2.y < r1.y)
				return false;
		 
			return true;
		}
	}
	int main()
	{
		Point l1 = {0, 10}, r1 = {10, 0};
		Point l2 = {5, 5}, r2 = {15, 0};
		if (doOverlap(l1, r1, l2, r2))
			printf("Rectangles Overlap");
		else
			printf("Rectangles Don't Overlap");
		return 0;
	}
}