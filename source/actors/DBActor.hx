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
import components.ComponentSystem;
/**
 * ...
 * @author ...
 */

 
class DBActor extends BaseActor
{
		
	private var data:Dynamic;

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
		setupNodes(node);
		
		for (i in 0...3)
		{
			controls.push(new Control(i, unitControlTypes[i],null,"assets/images/controls.png"));
		}

		for (i in 0...eData.components.length)
		{
			addC(eData.components[i].name);			
		}
	}
	
	public function update(?elapsed:Float):Void 
	{
		dispatchEvent(UpdateEvent.UPDATE, new UpdateEvent());
	}
}