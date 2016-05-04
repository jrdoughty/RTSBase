package adapters;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import actors.BaseActor;
/**
 * ...
 * @author John Doughty
 */


class TwoDSprite extends FlxSprite 
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
	
	@:extern public inline function pauseAnimation()
	{
		animation.pause();
	}
	
	@:extern public inline function setCurrentFrame(frame:Int)
	{
		animation.frameIndex = frame;
	}
	@:extern public inline function addAnimation(name:String, frames:Array<Int>, frameRate:Int = 30,
	looped:Bool = true, flipX:Bool = false, flipY:Bool = false)
	{
		animation.add(name, frames, frameRate, looped, flipX, flipY);
	}
	
	@:extern public inline function playAnimation(animationName:String)
	{
		animation.play(animationName);
	}
	
	@:extern public inline function getCurrentFrame():Int
	{
		return animation.frameIndex;
	}
	
	@:extern public inline function setAlpha(decimal:Float)
	{
		alpha = decimal;
	}
	
	
}