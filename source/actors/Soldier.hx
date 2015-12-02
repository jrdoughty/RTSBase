package actors;
import flixel.FlxG;
import world.Node;
import actors.BaseActor.ActorState;
import interfaces.IGameState;
import flixel.util.FlxColor;
/**
 * ...
 * @author John Doughty
 */
class Soldier extends Unit
{
	override function setupGraphics() 
	{
		super.setupGraphics();	
		loadGraphic("assets/images/soldiers.png", true, 8, 8);
		animation.add("active", [0, 1], 5, true);
		animation.add("attack", [0, 4], 5, true);
		idleFrame = 0;
	}
}