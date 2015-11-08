package dashboard;

import flixel.FlxSprite;

/**
 * ...
 * @author ...
 */
class Control extends FlxSprite
{

	public static inline var ATTACK:Int = 0;//Corresponds to frames
	public static inline var STOP:Int = 1;
	public static inline var MOVE:Int = 2;
	public static inline var PATROL:Int = 3;
	public static inline var SPELL:Int = 4;
	public static inline var BUILD:Int = 5;
	public static inline var HOLD:Int = 6;
	
	public function new(X:Float=0, Y:Float=0, ?SimpleGraphic:Dynamic) 
	{
		super(X, Y, SimpleGraphic);
		loadGraphic("assets/images/controls.png", false, 8, 8);
		scale.set(2, 2);
		updateHitbox();
	}
	
	public function setFrameIndex(i:Int)
	{
		animation.frameIndex = i;
	}
	
}