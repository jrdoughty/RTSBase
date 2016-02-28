package components;
import events.EventObject;
import flixel.FlxSprite;
import events.RevealEvent;
import events.HideEvent;
import events.KillEvent;
/**
 * ...
 * @author ...
 */
class Health extends Component
{


	/**
	 * simple health bar sprite
	 */
	private var healthBar:FlxSprite;
	
	
	/**
	 * simple health bar fill sprite
	 */
	private var healthBarFill:FlxSprite;
	
	private var health = 1;
	
	public function new() 
	{
		super();
	}
	
	override public function init() 
	{
		super.init();
		healthBar = new FlxSprite(x, y - 1);
		healthBar.makeGraphic(Std.int(width), 1, FlxColor.BLACK);
		FlxG.state.add(healthBar);
		healthBarFill = new FlxSprite(x, y - 1);
		healthBarFill.makeGraphic(Std.int(width), 1, FlxColor.RED);
		FlxG.state.add(healthBarFill);	
		
		
		entity.addEvent(RevealEvent.REVEAL, makeVisible);
		entity.addEvent(HideEvent.HIDE, killVisibility);
	}
	
	/**
	 * sets itself and the health bars to no longer be visible
	 */
	public function killVisibility(e:HideEvent = null)
	{
		healthBar.visible = false;
		healthBarFill.visible = false;
	}

	
	/**
	 * Sets itself and the health bars to be visible
	 */
	public function makeVisible(e:RevealEvent = null)
	{
		healthBar.visible = true;
		healthBarFill.visible = true;
	}
	
	/**
	 * keeps up the position of the health bar, and maintains the fill
	 */
	public function update(e:EventObject = null)
	{
		if (healthBarFill != null)
		{
			if (health > 0)
			{
				healthBarFill.scale.set(health, 1);
			}
			else
			{
				healthBarFill.scale.set(0, 1);
			}
			healthBarFill.updateHitbox();
			healthBarFill.x = x;
			healthBarFill.y = y - 1;
		}
		if (healthBar != null)
		{
			healthBar.x = x;
			healthBar.y = y - 1;
		}
		if (health <= 0)
		{
			kill();
		}
	}
	
	
	public function kill(e:EventObject = null)
	{
		FlxG.state.remove(healthBar);
		FlxG.state.remove(healthBarFill);
		entity.dispatchEvent(KillEvent.KILL, new KillEvent());
	}
}