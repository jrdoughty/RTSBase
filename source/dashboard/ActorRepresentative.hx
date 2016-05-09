package dashboard;

import actors.BaseActor;
import adapters.TwoDRect;
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
		healthBar = new TwoDRect(x, y,"BLACK", width, 1);
		healthBarFill = new TwoDRect(x, y, "RED", width, 1);
		
		pauseAnimation();
	}
	
	public function setGraphics(s:TwoDSprite)
	{
		loadSpriteFromSprite(s);
		setImageSize(overrideWidth, overrideHeight);
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
}