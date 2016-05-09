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
	
	@:extern public inline function loadSpriteFromSprite(s:TwoDSprite)
	{
		this.loadGraphicFromSprite(s);
	}
	
	@:extern public inline function darkenColor()
	{
		color = 0xBBBBBB;
	}
	
	@:extern public inline function normalizeColor()
	{
		color = 0xFFFFFF;
	}
	
	@:extern public inline function setScale(x:Float, y:Float)
	{
		scale.set(x, y);
		updateHitbox();
	}
	
	@:extern public inline function setImageSize(w:Int, h:Int)
	{
		setGraphicSize(w, h);
		updateHitbox();
	}
	
	@:extern public inline function setVisibility(visible:Bool)
	{
		this.visible = visible;
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