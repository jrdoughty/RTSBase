package world;
import actors.BaseActor;
import flixel.FlxSprite;
import openfl.events.MouseEvent;
import flixel.plugin.MouseEventManager;

/**
 * ...
 * @author John Doughty
 */
class Node extends FlxSprite
{

	private var occupants:Array<BaseActor> = [];
	
	public function new(frame, X:Float=0, Y:Float=0) 
	{
		super(X, Y);
		loadGraphic("assets/images/textures.png", false, 16, 16);
		animation.add("main",[frame],0,false);
		animation.add("clicked",[9],0,false);
		animation.play("main");
		
		MouseEventManager.add(this, onClick, null, null, null);
		
	}
	
	public function isPassible():Bool
	{
		return (occupants.length == 0);
	}
	
	private function onClick(sprite:FlxSprite):Void
	{
		PlayState.getLevel().setSelectedNode(this);
		animation.play("clicked");
	}
	
	public function resetState():Void
	{
		animation.play("main");
	}
}