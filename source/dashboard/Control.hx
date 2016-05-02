package dashboard;

import actors.BaseActor.ActorControlTypes;
import openfl.display.Sprite;
import adapters.TwoDSprite;

/**
 * ...
 * @author ...
 */
class Control extends TwoDSprite
{	
	public var type:ActorControlTypes;
	public var callbackFunction:Dynamic = null;
	
	public function new(frame:Int=7, type:ActorControlTypes, callback:Dynamic, spriteString:String) 
	{
		super(0, 0, spriteString, 8, 8);
		this.type = type;
		
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