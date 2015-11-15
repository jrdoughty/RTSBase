package actors;
import flixel.FlxG;
import world.Node;
import actors.BaseActor.ActorState;
import interfaces.IGameState;

/**
 * ...
 * @author John Doughty
 */
class SwordSoldier extends Unit
{

	public function new(node:Node, state:IGameState) 
	{
		super(node, state);
		loadGraphic("assets/images/soldiers.png", true, 8, 8);
		animation.add("active", [0, 1], 5, true);
		animation.add("attack", [0, 4], 5, true);
		team = 1;
		//speed = 200;
		idleFrame = 0;
	}

	
	override private function move() 
	{
			super.move();
			animation.play("active");
	}
	
	override private function idle()
	{
		super.idle();
		animation.frameIndex = 0;
		animation.pause();
	}
	
	override private function attack()
	{
		super.attack();
		animation.play("attack");
	}
	
	override private function chase()
	{
		super.chase();
		animation.play("active");
	}
}