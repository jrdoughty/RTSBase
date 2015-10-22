package actors;
import flixel.FlxG;
import world.Node;
import actors.BaseActor.State;

/**
 * ...
 * @author John Doughty
 */
class SpearSoldier extends BaseActor
{

	public function new(node:Node) 
	{
		super(node);
		loadGraphic("assets/images/soldiers.png", true, 8, 8);
		animation.add("active", [2, 3], 5, true);
		animation.add("attack", [2, 6], 5, true);
		animation.frameIndex = 2;
		team = 2;
	}
	
	
	override private function idle()
	{
		super.idle();
		animation.frameIndex = 2;
		animation.pause();
	}
	
	override private function attack()
	{
		super.attack();
		animation.play("attack");
	}
	
}