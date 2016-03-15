package components;
import events.EventObject;
import events.UpdateEvent;
import flixel.FlxSprite;
import events.RevealEvent;
import events.HideEvent;
import events.KillEvent;
import events.HurtEvent;
import flixel.util.FlxColor;
import flixel.FlxG;
/**
 * ...
 * @author ...
 */
class Health extends Component
{



	/**
	 * Int used to decide health using health as a percent of healthMax total
	 */
	public var healthMax:Int = 8;
	/**
	 * simple health bar sprite
	 */
	private var healthBar:FlxSprite;
	
	/**
	 * simple health bar fill sprite
	 */
	private var healthBarFill:FlxSprite;
	
	private var health:Float = 1;
	
	public function new(name:String) 
	{
		super(name);
	}
	
	override public function init() 
	{
		super.init();
		healthMax = entity.eData.health;
		healthBar = new FlxSprite(entity.x, entity.y - 1);
		healthBar.makeGraphic(Std.int(entity.width), 1, FlxColor.BLACK);
		FlxG.state.add(healthBar);
		healthBarFill = new FlxSprite(entity.x, entity.y - 1);
		healthBarFill.makeGraphic(Std.int(entity.width), 1, FlxColor.RED);
		FlxG.state.add(healthBarFill);	
		
		
		entity.addEvent(RevealEvent.REVEAL, makeVisible);
		entity.addEvent(HideEvent.HIDE, killVisibility);
		entity.addEvent(HurtEvent.HURT, hurt);
		entity.addEvent(UpdateEvent.UPDATE, update);
	}
	
	public function hurt(e:HurtEvent)
	{
		health -= e.damage / healthMax;
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
	public function update(e:UpdateEvent = null)
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
			healthBarFill.x = entity.x;
			healthBarFill.y = entity.y - 1;
		}
		if (healthBar != null)
		{
			healthBar.x = entity.x;
			healthBar.y = entity.y - 1;
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
		entity.kill();
	}
}