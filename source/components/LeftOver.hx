package components;
import world.Node;
import dashboard.Control;
import flixel.FlxSprite;
/**
 * ...
 * @author John Doughty
 */
class LeftOver extends Component
{

	/**
	 * Nodes Taken up by BaseActor
	 */
	public var currentNodes:Array<Node> = [];

	/**
	 * Team BaseActor belongs to
	 */
	public var team:Team = null;

	/**
	 * Controls to be placed in the dashboard
	 */
	public var controls:Array<Control> = [];

	/**
	 * damage dealt when attacking
	 */
	public var damage:Int = 1;

	/**
	 * frame used when actor is told to stop or idle
	 */
	public var idleFrame:Int = 0;

	/**
	 * milliseconds between takeAction cycles
	 */
	public var speed:Int = 250;

	/**
	 * Int used to decide health using health as a percent of healthMax total
	 */
	public var healthMax:Int = 8;

	/**
	 * How many nodes over can the BaseActor's view clear the Fog of War
	 */
	public var viewRange:Int = 2;

	/**
	 * Nodes scanned to clear fog of war
	 */
	public var clearedNodes:Array<Node> = [];

	
	
	/**
	 * selected state bool
	 */
	private var selected:Bool = false;

	/**
	 * simple health bar sprite
	 */
	private var healthBar:FlxSprite;
	
	
	/**
	 * simple health bar fill sprite
	 */
	private var healthBarFill:FlxSprite;
	
	
	public function new() 
	{
		super();
		
	}
	
	/**
	 * sets itself and the health bars to no longer be visible
	 */
	public function killVisibility()
	{
		visible = false;
		healthBar.visible = false;
		healthBarFill.visible = false;
	}
	
	/**
	 * Sets itself and the health bars to be visible
	 */
	public function makeVisible()
	{
		visible = true;
		healthBar.visible = true;
		healthBarFill.visible = true;
	}
	
	/**
	 * sets all the nodes it graphically covers (and the provided node) to be occupied by this BaseActor
	 * 
	 * @param	node				the top left most Node the BaseActor takes up
	 */
	private function setupNodes(node:Node)
	{
		currentNodes = node.getAllNodes(Std.int(width / 8) - 1, Std.int(height / 8) - 1);
		
		for (i in 0...currentNodes.length)
		{
			currentNodes[i].occupant = this;
		}
	}
	/**
	 * abstract function. Not literally because i want BaseActor to be Useable as is. 
	 * Graphics therefore can be supplied after
	 */
	private function setupGraphics()
	{
		
	}
	
	/**
	 * health is a 0-1 base system and the bar sits with a fill on top of it
	 */
	private function createHealthBar()
	{
		health = 1;
		healthBar = new FlxSprite(x, y - 1);
		healthBar.makeGraphic(Std.int(width), 1, FlxColor.BLACK);
		FlxG.state.add(healthBar);
		healthBarFill = new FlxSprite(x, y - 1);
		healthBarFill.makeGraphic(Std.int(width), 1, FlxColor.RED);
		FlxG.state.add(healthBarFill);		
	}
	

	/**
	 * keeps up the position of the health bar, and maintains the fill
	 */
	override public function update()
	{
		super.update();
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
	}
	
	
	/**
	 * sets selected state
	 * has a debugging color change commented out
	 */
	public function select():Void
	{
		//color = 0x99ff66;
		selected = true;
	}
	
	/**
	 * resets selected to false and resets the base color
	 */
	public function resetSelect():Void
	{
		selected = false;
		color = 0xffffff;
	}
	
	/**
	 * ensures the BaseActor's actions are removed and that the BaseActor is no longer on the field
	 * also detatches components
	 */
	override public function kill()
	{
		super.kill();
		currentNodes[0].occupant = null;
		FlxG.state.remove(healthBar);
		FlxG.state.remove(healthBarFill);
		FlxG.state.remove(this);
		for (key in components.keys())
		{
			components[key].detach();
		}
		actionTimer.stop();
		destroy();
	}
	
	/**
	 * used to clear fog of war if the BaseActor has a viewRange
	 * recursive function, expensive if viewRange is made too large or too many BaseActors are on Active Team
	 * 
	 * @param	node			new Node to check. If not provided, defaults to the currentNode of the Base Actor
	 */
	public function clearFogOfWar(node:Node = null)
	{
		var n;
		var distance:Float;
		if (node == null)
		{
			node = currentNodes[0];
		}
		for (n in node.neighbors)
		{
			if (clearedNodes.indexOf(n) == -1)
			{
				distance = Math.sqrt(Math.pow(Math.abs(currentNodes[0].nodeX - n.nodeX), 2) + Math.pow(Math.abs(currentNodes[0].nodeY - n.nodeY), 2));
				if (distance <= viewRange)
				{
					n.removeOverlay();
					clearedNodes.push(n);
					if (distance < viewRange && n.isPassible())
					{
						clearFogOfWar(n);
					}
				}
			}
		}
	}
	
}