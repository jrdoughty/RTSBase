package dashboard;

import flixel.FlxSprite;

/**
 * ...
 * @author ...
 */
class Control extends FlxSprite
{	
	public function new(frame:Int=7, ?spriteString:String) 
	{
		super(0, 0);
		if (spriteString == null)
		{
			loadGraphic("assets/images/controls.png", false, 8, 8);
		}
		else
		{
			loadGraphic(spriteString, false, 8, 8);
		}
		animation.frameIndex = frame;
		scale.set(2, 2);
		updateHitbox();
	}
	
}