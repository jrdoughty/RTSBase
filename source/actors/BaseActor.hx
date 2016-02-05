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
import components.EventObject;
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
	public var targetEnemy:BaseActor;
	public var team:Team = null;
	public var damage:Int = 1;
	public var controls:Array<Control> = [];
	public var idleFrame:Int = 0;
	public var clearedNodes:Array<Node> = [];
	public var speed:Int = 250;
	public var attr:Dynamic;
	public var healthMax:Int = 8;
	
	private var components:Map<String, Component> = new Map();
	private var selected:Bool = false;
	private var actionTimer:Timer;
	private var delayTimer:Timer;
	private var state:ActorState = IDLE;
	private var healthBar:FlxSprite;
	private var healthBarFill:FlxSprite;
	private var viewRange:Int = 2;
	private var listeners:Map<String, Array<Function>> = new Map();
	
	
	public function new(node:Node) 
	{
		super(node.x, node.y);
		
		delayTimer = new Timer(Math.floor(1000*Math.random()));//Keeps mass created units from updating at the exact same time. Idea from: http://answers.unity3d.com/questions/419786/a-pathfinding-multiple-enemies-MOVING-target-effic.html
		delayTimer.run = delayedStart;
		setupGraphics();
		setupNodes(node);
		createHealthBar();
	}
	
	public function killVisibility()
	{
		visible = false;
		healthBar.visible = false;
		healthBarFill.visible = false;
	}
	
	public function makeVisible()
	{
		visible = true;
		healthBar.visible = true;
		healthBarFill.visible = true;
	}
	
	private function setupNodes(node:Node)
	{
		currentNodes = node.getAllNodes(Std.int(width / 8) - 1, Std.int(height / 8) - 1);
		
		for (i in 0...currentNodes.length)
		{
			currentNodes[i].occupant = this;
		}
	}
	
	private function setupGraphics()
	{
		
	}
	
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
	private function delayedStart()
	{
		delayTimer.stop();
		actionTimer = new Timer(speed);
		actionTimer.run = takeAction;
	}
	
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
		}
	}
	
	private function takeAction()
	{

	}
	
	public function select():Void
	{
		//color = 0x99ff66;
		selected = true;
	}
	
	public function resetSelect():Void
	{
		selected = false;
		color = 0xffffff;
	}
	
	public function resetStates():Void
	{
		state = IDLE;
		targetEnemy = null;
	}
	
	override public function kill()
	{
		super.kill();
		resetStates();
		currentNodes[0].occupant = null;
		actionTimer.stop();
		FlxG.state.remove(healthBar);
		FlxG.state.remove(healthBarFill);
		FlxG.state.remove(this);
		destroy();
	}
	
	
	public function clearFogOfWar(node:Node)
	{
		var n;
		var distance:Float;
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
	
	public function dispatchEvent(name:String, eventObject:EventObject)
	{
		if (listeners.exists(name))
		{
			for (func in listeners[name])
			{
				func(eventObject);
			}
		}
	}
	
	
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
	
	public function removeC(componentName:String)
	{
		components[componentName].detach();
		components.remove(componentName);
	}
	
	public function hasC(componentName:String):Bool
	{
		return components.exists(componentName);
	}
	
	public function getC(componentName:String):Component
	{
		return components[componentName];
	}
	
	public function getCList():Array<Component>
	{
		var result = [];
		for (k in components.keys())
		{
			result.push(components[k]);
		}
		return result;
	}
	
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