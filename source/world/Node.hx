package world;
import actors.BaseActor;
import flixel.FlxSprite;

/**
 * ...
 * @author John Doughty
 */
class Node extends FlxSprite
{

	private var occupants:Array<BaseActor> = [];
	
	public function new(X:Float=0, Y:Float=0) 
	{
		super(X, Y);
		loadGraphic("assets/images/textures.png",false,16,16);
	}
	
	public function isPassible():Bool
	{
		return (occupants.length == 0);
	}
}