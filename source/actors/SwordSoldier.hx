package actors;
import flixel.FlxG;

/**
 * ...
 * @author John Doughty
 */
class SwordSoldier extends BaseActor
{

	public function new(x:Int, y:Int) 
	{
		super(x, y);
		loadGraphic("assets/images/soldiers.png", true, 8, 8);
		animation.add("active", [0, 1], 5, true);
	}
	override public function update():Void 
	{
		super.update();
		move();
	}
	
	@:extern inline private function isMoveKeyDown():Bool
	{
		return FlxG.keys.anyPressed(["LEFT", "A", "RIGHT", "D", "Up", "W", "Down", "S"]);
	}
	
	public function move()
	{
		if (isMoveKeyDown())
		{
			if (FlxG.keys.anyPressed(["LEFT", "A"]))
			{
				x -= 1;
				set_flipX(true);
			}
			else if (FlxG.keys.anyPressed(["RIGHT", "D"]))
			{
				x += 1;
				set_flipX(false);
			}

			if (FlxG.keys.anyPressed(["Up", "W"]))
			{
				y -= 1;
			}
			else if (FlxG.keys.anyPressed(["Down", "S"]))
			{
				y += 1;
			}
			animation.play("active");
		} 
		else
		{
			animation.frameIndex = 0;
			animation.pause();
		}
	}
}