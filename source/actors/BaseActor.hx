package actors;

import flixel.FlxSprite;
import flixel.FlxG;
import haxe.Timer;
import interfaces.IEntity;
import interfaces.IGameState;
import systems.AStar;
import world.Node;
import flixel.util.FlxColor;
import dashboard.Control;
import systems.Team;
import haxe.Constraints.Function;
import events.EventObject;
import components.Component;
/**
 * ...
 * @author John Doughty
 */



enum ActorControlTypes 
{
	ATTACK;
	STOP;
	MOVE;
	PATROL;
	CAST;
	BUILD;
	HOLD;
	PRODUCE;
}
 
 
class BaseActor extends FlxSprite implements IEntity
{

	public var currentNodes:Array<Node> = [];
	public var team:Team = null;//shouldgetremoved
	public var controls:Array<Control> = [];
	public var damage:Int = 1;
	public var idleFrame:Int = 0;
	public var speed:Int = 250;
	public var healthMax:Int = 8;
	public var attr:Dynamic;
	public var threatRange:Int = 2;
	public var threatNodes:Array<Node> = [];
	public var clearedNodes:Array<Node> = [];
	
	private var components:Map<String, Component> = new Map();
	private var listeners:Map<String, Array<Function>> = new Map();
	private var selected:Bool = false;
	private var actionTimer:Timer;
	private var delayTimer:Timer;
	private var healthBar:FlxSprite;
	private var healthBarFill:FlxSprite;
	private var viewRange:Int = 2;
	
	/**
	 * Base RTS Sprite/Entity Class. Creates an Actor in a node. Provides the FlxSprite Base Class the Node's x and y cords.
	 * It then starts a delay timer thats end signals the start of the takeAction cycle.
	 * It follows up by setting up graphics (a blank method to be replaced) and the nodes the graphics overlay
	 * finishes by creating health bars
	 * 
	 * @param	node			the node the actor is placed in 
	 * 
	 */
	public function new(node:Node) 
	{
		super(node.x, node.y);
		
		delayTimer = new Timer(Math.floor(1000*Math.random()));//Keeps mass created units from updating at the exact same time. Idea from: http://answers.unity3d.com/questions/419786/a-pathfinding-multiple-enemies-MOVING-target-effic.html
		delayTimer.run = delayedStart;
		setupGraphics();
		setupNodes(node);
		createHealthBar();
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
	 * end of delay timer that starts the takeAction cycle. 
	 * This prevents too many AI scripts firing at once
	 */
	private function delayedStart()
	{
		delayTimer.stop();
		actionTimer = new Timer(speed);
		actionTimer.run = takeAction;
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
	 * the main action function where the BaseActor displays its behavior
	 */
	private function takeAction()
	{
		checkView();
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
	 */
	override public function kill()
	{
		super.kill();
		currentNodes[0].occupant = null;
		actionTimer.stop();
		FlxG.state.remove(healthBar);
		FlxG.state.remove(healthBarFill);
		FlxG.state.remove(this);
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
	/**
	 * Recursively checks neighboring nodes for nodes in threat range
	 * Expensive if threatRange is too great or too many BaseActors on the field
	 * @param	node 			new Node to check. If not provided, defaults to the currentNode of the Base Actor
	 */
	public function checkView(node:Node = null)
	{
		var n;
		var distance:Float;
		if (node == null)
		{
			node = currentNodes[0];
		}
		for (n in node.neighbors)
		{
			if (threatNodes.indexOf(n) == -1)
			{
				distance = Math.sqrt(Math.pow(Math.abs(currentNodes[0].nodeX - n.nodeX), 2) + Math.pow(Math.abs(currentNodes[0].nodeY - n.nodeY), 2));
				if (distance <= threatRange)
				{
					threatNodes.push(n);
					if (distance < viewRange && n.isPassible())
					{
						checkView(n);
					}
				}
			}
		}
	}
	
	/**
	 * Adds Event Listener for the name string and addes the callback to the functions to be 
	 * run when that event is fired off
	 * @param	name 		Event String that maps to array of callbacks
	 * @param	callback	callback to be added to array of callbacks upon event dispatch
	 */
	public function addEvent(name:String, callback:Function)
	{
		if (!listeners.exists(name))
		{
			listeners.set(name, [callback]);
		}
		else if (listeners[name].indexOf(callback) == -1)
		{
			listeners[name].push(callback);
		}
	}
	
	/**
	 * Removes Event Listener for the strings/callback combination
	 * 
	 * @param	name 		Event String that maps to array of callbacks
	 * @param	callback	callback to be removed from event
	 */
	public function removeEvent(name:String, callback:Function)
	{
		var i:Int;
		if (listeners.exists(name) && listeners[name].indexOf(callback) != -1)
		{
			for (i in 0...listeners[name].length)
			{
				if (listeners[name][i] == callback)
				{
					listeners[name].splice(i, 1);
					break;
				}
			}
		}
	}
	
	/**
	 * Triggers event using the name string. 
	 * The eventObject is passed to all callback functions listening to the event
	 * @param	name		Event to Trigger
	 * @param	eventObject	data the Event's callback functions need, creates a blank EventObject if left null
	 */
	public function dispatchEvent(name:String, eventObject:EventObject = null)
	{
		if (eventObject == null)
		{
			eventObject = new EventObject();
		}
		if (listeners.exists(name))
		{
			for (func in listeners[name])
			{
				func(eventObject);
			}
		}
	}
	
	/**
	 *  adds component to components map and attaches this to the component
	 * @param	component		Component to add
	 * @param	n				String to refer back to the component
	 */
	public function addC(component:Component, n:String)
	{
		var name:String;
		if (n == null)
		{
			name = component.defaultName;
		}
		else
		{
			name = n;
		}
		components.set(name, component);
		component.attach(this);
	}
	
	/**
	 * remove component by name and decouple this from the component
	 * @param	componentName	string used to identify component to remove
	 */
	public function removeC(componentName:String)
	{
		components[componentName].detach();
		components.remove(componentName);
	}
	
	/**
	 * check to see if the component is attached with the componentName
	 * @param	componentName	String to Identify component
	 * @return	is there a component with the componentName
	 */
	public function hasC(componentName:String):Bool
	{
		return components.exists(componentName);
	}
	
	/**
	 * get component by componentName
	 * @param	componentName	String to get component by
	 * @return	component with matching name is returned
	 */
	public function getC(componentName:String):Component
	{
		return components[componentName];
	}
	
	/**
	 * get array of Components currently attached to this
	 * @return array of Components currently attached to this
	 */
	public function getCList():Array<Component>
	{
		var result = [];
		for (k in components.keys())
		{
			result.push(components[k]);
		}
		return result;
	}
	
	/**
	 * get Array of IDs of components attached to this
	 * @return Array of component IDs attached to this
	 */
	public function getCIDList():Array<String>
	{
		var result = [];
		for (k in components.keys())
		{
			result.push(k);
		}
		return result;
	}
}