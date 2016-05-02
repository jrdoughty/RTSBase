package dashboard;

import actors.BaseActor;
import events.EventObject;
import flixel.util.FlxColor;
import events.GetSpriteEvent;
import adapters.TwoDSprite;
/**
 * ...
 * @author ...
 */
class ActorRepresentative extends TwoDSprite
{
	public var healthBar:TwoDSprite;
	public var healthBarFill:TwoDSprite;
	public var baseActor:BaseActor;
	
	private var overrideWidth:Int;
	private var overrideHeight:Int;
	
	public function new(base:BaseActor, X:Float=0, Y:Float=0, width:Int = 16, height:Int = 16) 
	{
		super(0, 0);
		baseActor = base;
		x = X;
		y = Y;
		overrideWidth = width;
		overrideHeight = height;
		baseActor.dispatchEvent(GetSpriteEvent.GET, new GetSpriteEvent(setGraphics));
		healthBar = new TwoDSprite(x, y);
		healthBar.makeGraphic(width, 1, FlxColor.BLACK);
		healthBarFill = new TwoDSprite(x, y);
		healthBarFill.makeGraphic(width, 1, FlxColor.RED);
		animation.pause();
	}
	
	public function setGraphics(s:TwoDSprite)
	{
		loadGraphicFromSprite(s);
		setGraphicSize(overrideWidth, overrideHeight);
		updateHitbox();
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
		//healthBarFill.scale.set(baseActor.health, 1);
		healthBarFill.updateHitbox();
	}
}