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
import systems.DataCache;
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
		var compnts:Array<Dynamic>;
		super(node);
		
		data = systems.Data;//hack
		eData = DataCache.getInstance().getData(data.Actors, unitID);
		setupNodes(node);
		
		for (i in 0...3)
		{
			controls.push(new Control(i, unitControlTypes[i],null,AssetPaths.controls__png));
		}
		compnts = eData["components"];
		for (j in compnts)
		{
			addC(j.name);			
		}
	}
	
	public function update(?elapsed:Float):Void 
	{
		dispatchEvent(UpdateEvent.UPDATE, new UpdateEvent());
	}
}