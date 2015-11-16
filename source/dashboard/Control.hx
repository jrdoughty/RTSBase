package dashboard;

import actors.BaseActor.ActorControlTypes;
import flixel.FlxSprite;

/**
 * ...
 * @author ...
 */
class Control extends FlxSprite
{	
	public var type:ActorControlTypes;
	
	public function new(frame:Int=7, type:ActorControlTypes, ?spriteString:String) 
	{
		super(0, 0);
		this.type = type;
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