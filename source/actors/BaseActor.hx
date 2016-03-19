package actors;

import events.HideEvent;
import events.RevealEvent;
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
import components.ComponentSystem;
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
	 * frame used when actor is told to stop or idle
	 */
	public var idleFrame:Int = 0;


	/**
	 * DataHolder for Entity
	 */
	public var eData:Dynamic = {};
	
	/**
	 * components coupled to this
	 */
	private var components:Map<String, Component> = new Map();

	/**
	 * map of Function arrays, and the Event Constant Strings used to trigger them
	 */
	private var listeners:Map<String, Array<Function>> = new Map();

	/**
	 * selected state bool
	 */
	private var selected:Bool = false;
	
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
		visible = false;
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
	 * sets selected state
	 * 
	 */
	public function select():Void
	{
		selected = true;
	}
	
	/**
	 * resets selected to false
	 */
	public function resetSelect():Void
	{
		selected = false;
	}
	
	/**
	 * ensures the BaseActor's actions are removed and that the BaseActor is no longer on the field
	 * also detatches components
	 */
	override public function kill()
	{
		super.kill();
		currentNodes[0].occupant = null;
		FlxG.state.remove(this);
		for (key in components.keys())
		{
			components[key].detach();
		}
		destroy();
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
	public function addC(n:String)
	{
		var component = ComponentSystem.getInstance().getC(n);
		components.set(n, component);
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