package dashboard;

import actors.BaseActor;
import flixel.FlxSprite;
import flixel.util.FlxColor;
/**
 * ...
 * @author ...
 */
class ActorRepresentative extends FlxSprite
{
	public var healthBar:FlxSprite;
	public var healthBarFill:FlxSprite;
	public var baseActor:BaseActor;
	
	public function new(base:BaseActor, X:Float=0, Y:Float=0, width:Int = 16, height:Int = 16) 
	{
		super(0, 0);
		baseActor = base;
		loadGraphicFromSprite(base);
		setGraphicSize(width, height);
		updateHitbox();
		x = X;
		y = Y;
		healthBar = new FlxSprite(x, y);
		healthBar.makeGraphic(width, 1, FlxColor.BLACK);
		healthBarFill = new FlxSprite(x, y);
		healthBarFill.makeGraphic(width, 1, FlxColor.RED);
		animation.pause();
	}
	
	public function setDashPos(x:Int, y:Int):Void
	{
		this.x = x;
		healthBar.x = x;
		healthBarFill.x = x;
		this.y = y;
		healthBar.y = y;
		healthBarFill.y = y;
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		alive = baseActor.alive;
		healthBarFill.scale.set(baseActor.health, 1);
		healthBarFill.updateHitbox();
	}
}