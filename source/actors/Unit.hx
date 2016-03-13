package actors;
import components.Component;
import components.ControlledUnitAI;
import components.Health;
import components.View;
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
import events.UpdateEvent;
/**
 * ...
 * @author ...
 */

 
class Unit extends BaseActor
{
		
	private var data:Dynamic;
	/**
	 *  Contains:
	 *  health;
	 *	speed;
	 *	damage;
	 *	viewRange;
	 *	threatDist;
	 */
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
		super(node);
		data = systems.Data;//hack
		eData = data.Actors.get(unitID);//supposedly Actors doesn't have get
		setupGraphics();
		setupNodes(node);
		for (i in 0...3)
		{
			controls.push(new Control(i, unitControlTypes[i],null,"assets/images/controls.png"));
		}
		
		addC(new Health(eData.health), "Health");
		addC(new ControlledUnitAI(eData.threatDist, eData.speed, eData.damage), "AI");
		addC(new View(eData.viewRange), "View");
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		dispatchEvent(UpdateEvent.UPDATE, new UpdateEvent());
	}
	
	/**
	 * Lets up graphics based on unitData
	 * Adds animations 'active' and 'attack'
	 * idle currently is set to the first frame (0)
	 */
	override function setupGraphics() 
	{
		var assetPath:String = "assets" + eData.spriteFile.substr(2);
		super.setupGraphics();
		
		loadGraphic(assetPath, true, 8, 8);
		animation.add("active", [0, 1], 5, true);
		animation.add("attack", [0, 2], 5, true);
		idleFrame = 0;
	}
}