package;
import haxe.Constraints.Function;
/**
 * ...
 * @author John Doughty
 */
interface TwoD 
{
	public var x(default, set):Float;
	public var y(default, set):Float;
	public var width(get, set):Float;
	public var height(get, set):Float;
}

typedef OverlappingObjects = {
	group1:Array<Dynamic>,
	group2:Array<Dynamic>
}

class Util
{

	public function new() 
	{
		
	}
	
	public static function doesOverlap(object1:TwoD, object2:TwoD):Bool
	{
		var topLeftX1:Float = object1.x;
		var topLeftY1:Float = object1.y;
		var bottomRightX1:Float = object1.x + object1.width;
		var bottomRightY1:Float = object1.y + object1.height;
		
		var topLeftX2:Float = object2.x;
		var topLeftY2:Float = object2.y;
		var bottomRightX2:Float = object2.x + object2.width;
		var bottomRightY2:Float = object2.y + object2.height;
		
		if (topLeftX1 > bottomRightX2 || topLeftX2 > bottomRightX1)
				return false;
		 
		if (topLeftY1 > bottomRightY2 || topLeftY2 > bottomRightY1)
			return false;
		
		return true;
	}
	
	public static function groupOverlap(objects1:Array<TwoD>, objects2:Array<TwoD>):OverlappingObjects
	{
		var result:OverlappingObjects = {group1:[], group2:[]};
		var i:Int;
		var j:Int;
		
		for (i in 0...objects1.length)
		{
			for (j in 0...objects2.length)
			{
				if (doesOverlap(objects1[i], objects2[j]))
				{
					result.group1.push(objects1[i]);
					result.group2.push(objects2[j]);
					
				}
			}
		}
		
		return result;
	}
	
	public static function emulateFlxGOverlap(objects1:Array<TwoD>, objects2:Array<TwoD>, callback:Function):Bool
	{
		var i:Int;
		var result = false;
		var overlappingObjects:OverlappingObjects = groupOverlap(objects1, objects2);
		for (i in 0...overlappingObjects.group1.length)
		{
			callback(overlappingObjects.group1[i], overlappingObjects.group2[i]);
			result = true;
		}
		return result;
	}
}