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
 
class Entity extends FlxSprite implements IEntity
{

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
	 * timer whose frequency is set by speed
	 */
	private var actionTimer:Timer;

	/**
	 * offset delay timer that starts the action timer. Used to keep AI from starting at the same time. Set to 0 - 1 sec
	 */
	private var delayTimer:Timer;
	
	
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
	 * main action function run ever <speed> milliseconds
	 */
	private function takeAction()
	{
		var i;
		for (i in components.keys())
		{
			components[i].takeAction();
		}
	}
	
	/**
	 * ensures the BaseActor's actions are removed and that the BaseActor is no longer on the field
	 * also detatches components
	 */
	override public function kill()
	{
		super.kill();
		for (key in components.keys())
		{
			components[key].detach();
		}
		actionTimer.stop();
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