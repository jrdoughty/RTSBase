package adapters;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import actors.BaseActor;
/**
 * ...
 * @author John Doughty
 */
interface ITwoD 
{
	public var x(default, set):Float;
	public var y(default, set):Float;
	public var entity:BaseActor;
	public var width(get, set):Float;
	public var height(get, set):Float;

}

class TwoDSprite extends FlxSprite implements ITwoD
{
	public var entity:BaseActor = null;
	
	public function new(?X:Float = 0, ?Y:Float = 0, ?filePath:String, ?width:Int = 0, ?height:Int = 0,?entity:BaseActor)
	{
		if (entity != null)
		{
			this.entity = entity;
		}
		
		if (width == 0 && height == 0)
		{
			super(X, Y, filePath);
		}
		else
		{
			super(X, Y);
			loadGraphic(filePath, true, width, height);
		}
	}
}