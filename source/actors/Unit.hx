package actors;
import components.Component;
import components.ControlledUnitAI;
import haxe.Constraints.Function;
import world.Node;
import interfaces.IGameState;
import systems.AStar;
import dashboard.Control;
import actors.BaseActor.ActorControlTypes;
import actors.ActorState;
import systems.Data;
import openfl.Assets;
import events.MoveEvent;
/**
 * ...
 * @author ...
 */

 
class Unit extends BaseActor
{
		
	private var data:Dynamic;
	private var unitData:Dynamic;
	private var unitControlTypes: Array<ActorControlTypes> = [ActorControlTypes.ATTACK,
		ActorControlTypes.STOP,
		ActorControlTypes.MOVE, 
		ActorControlTypes.PATROL, 
		ActorControlTypes.CAST, 
		ActorControlTypes.BUILD, 
		ActorControlTypes.HOLD];
	
	/**
	 * Creates Unit Actor from the Unit Sheet of CastleDB
	 * Stores unitData and sets speed, damage, viewRange, and threatRange.
	 * Currently attaches the ControlledUnitAI with the "AI" string. This will become based on CastleDB
	 * 
	 * @param	unitID string used to retrieve unitData
	 * @param	node top left most node actor is placed in
	 */
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
		threatRange = unitData.threatDist;
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
}