package actors;
import flixel.FlxG;
import world.Node;

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
		animation.frameIndex = 2;
	}
	
	override private function takeAction()
	{
		super.takeAction();
		if (moving)
		{
			animation.play("active");
		}
		else
		{
			animation.frameIndex = 2;
			animation.pause();
		}
	}
	
}