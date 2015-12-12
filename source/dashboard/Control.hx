package dashboard;

import actors.BaseActor.ActorControlTypes;
import flixel.FlxSprite;
import haxe.Constraints.Function;
import openfl.display.Sprite;

/**
 * ...
 * @author ...
 */
class Control extends FlxSprite
{	
	public var type:ActorControlTypes;
	public var callbackFunction:Function = null;
	
	public function new(frame:Int=7, type:ActorControlTypes,?callback, ?spriteString:String) 
	{
		super(0, 0);
		this.type = type;
		if (spriteString == null)
		{
			loadGraphic("assets/images/controls.png", false, 8, 8);
		}
		else
		{
			trace(spriteString);
			loadGraphic(spriteString, false, 8, 8);
		}
		
		if (callback != null)
		{
			callbackFunction = callback;
		}
		animation.frameIndex = frame;
		scale.set(2, 2);
		updateHitbox();
	}
	
	public function useCallback(sprite:Control)
	{
		callbackFunction();
	}
	
	public function hover(sprite:Control)
	{
		color = 0xBBBBBB;
	}
	
	public function out(sprite:Control)
	{
		color = 0xFFFFFF;
	}
	
}