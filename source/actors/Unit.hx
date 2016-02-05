package actors;
import components.Component;
import components.ControlledUnitAI;
import haxe.Constraints.Function;
import interfaces.IEntity;
import world.Node;
import interfaces.IGameState;
import systems.AStar;
import dashboard.Control;
import actors.BaseActor.ActorControlTypes;
import actors.ActorState;
import systems.Data;
import openfl.Assets;
import components.MoveEvent;
/**
 * ...
 * @author ...
 */

 
class Unit extends BaseActor implements IEntity
{
		
	private var components:Map<String, Component> = new Map();
	private var data:Dynamic;
	private var unitData:Dynamic;
	private var unitControlTypes: Array<ActorControlTypes> = [ActorControlTypes.ATTACK,
		ActorControlTypes.STOP,
		ActorControlTypes.MOVE, 
		ActorControlTypes.PATROL, 
		ActorControlTypes.CAST, 
		ActorControlTypes.BUILD, 
		ActorControlTypes.HOLD];
	
	
	public function new(unitID:String, node:Node) 
	{
		var i:Int;
		data = systems.Data;//hack
		unitData = data.Actors.get(unitID);//supposedly Actors doesn't have get
		super(node);
		for (i in 0...3)
		{
			controls.push(new Control(i, unitControlTypes[i]));
		}
		
		healthMax = unitData.health;
		speed = unitData.speed;
		damage = unitData.damage;
		viewRange = unitData.viewRange;
		addC(new ControlledUnitAI(), "AI");
	}
	
	override function setupGraphics() 
	{
		var assetPath:String = "assets" + unitData.spriteFile.substr(2);
		super.setupGraphics();
		
		loadGraphic(assetPath, true, 8, 8);
		animation.add("active", [0, 1], 5, true);
		animation.add("attack", [0, 2], 5, true);
		idleFrame = 0;
	}
	
	override public function kill() 
	{
		for (key in components.keys())
		{
			components[key].detach();
		}
		super.kill();
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