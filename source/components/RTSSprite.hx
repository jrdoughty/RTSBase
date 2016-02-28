package components;
import events.EventObject;
import flixel.FlxSprite;
import world.Node;
import events.CreateSpriteEvent;
import events.RevealEvent;
import events.HideEvent;
import events.KillEvent;
/**
 * ...
 * @author ...
 */
class RTSSprite extends Component
{
	public var sprite:FlxSprite;
	public var idleFrame:Int = 0;
	public function new() 
	{
		super();
	}
	
	override public function init() 
	{
		super.init();
		entity.addEvent(CreateSpriteEvent.CREATE_SPRITE, create);
		entity.addEvent(RevealEvent.REVEAL, makeVisible);
		entity.addEvent(HideEvent.HIDE, killVisibility);
		entity.addEvent(KillEvent.KILL, kill);
	}
	
	public function create(e:CreateSpriteEvent)
	{
		var assetPath:String = "assets" + e.data.spriteFile.substr(2);
		sprite = new FlxSprite(e.node.x, e.node.y);
		sprite.loadGraphic(assetPath, true, 8, 8);
		sprite.animation.add("active", [0, 1], 5, true);
		sprite.animation.add("attack", [0, 2], 5, true);
	}
	
	/**
	 * sets itself and the health bars to no longer be visible
	 */
	public function killVisibility(e:HideEvent)
	{
		sprite.visible = false;
	}

	
	/**
	 * Sets itself and the health bars to be visible
	 */
	public function makeVisible(e:RevealEvent)
	{
		sprite.visible = true;
	}
	
	public function kill(e:KillEvent)
	{
		sprite.kill();
	}
}