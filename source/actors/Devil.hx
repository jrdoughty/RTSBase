package actors;
import flixel.FlxG;
import interfaces.IGameState;
import world.Node;
import actors.BaseActor.ActorState;

/**
 * ...
 * @author John Doughty
 */
class Devil extends Unit
{

	override function setupGraphics() 
	{
		super.setupGraphics();
		loadGraphic("assets/images/soldiers.png", true, 8, 8);
		animation.add("active", [2, 3], 5, true);
		animation.add("attack", [2, 6], 5, true);
		animation.frameIndex = 2;
		idleFrame = 2;
	}
}