package actors;
import flixel.FlxG;
import interfaces.RTSGameState;
import world.Node;
import actors.BaseActor.ActorState;

/**
 * ...
 * @author John Doughty
 */
class SpearSoldier extends BaseActor
{

	public function new(node:Node, state:RTSGameState) 
	{
		super(node, state);
		loadGraphic("assets/images/soldiers.png", true, 8, 8);
		animation.add("active", [2, 3], 5, true);
		animation.add("attack", [2, 6], 5, true);
		animation.frameIndex = 2;
	}
	
	
	override private function move() 
	{
			super.move();
			animation.play("active");
	
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