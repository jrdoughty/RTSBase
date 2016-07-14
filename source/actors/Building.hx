package actors;

import dashboard.UnitControl;
import interfaces.IGameState;
import dashboard.Control;
import world.Node;
import actors.BaseActor;
import actors.DBActor;
import components.View;
import components.Health;
import events.GetSpriteEvent;

/**
 * ...
 * @author John Doughty
 */
class Building extends BaseActor
{
	private var data:Dynamic;
	private var unitsToProduce:Array<String> = [];
	private var callbacks:Array<Dynamic> = [];
	private var hw:Int;

	/**
	 * Creates a Building Actor from the Building Sheet of CastleDB
	 * Sets the buildings healthMax and ViewRange, and stores the buildingData, including producable units
	 * @param	uniqueID	string id used to grab data from sheet
	 * @param	node		top left node used for placement of actor
	 */
	public function new(uniqueID:String, node:Node) 
	{
		var i:Int;
		var units:Array<Dynamic>;
		var spriteFile:String;
		var iteratorNum = 0;

		super(node);
		
		data = systems.Data;//hack
		for (n in Reflect.fields(data.Buildings.get(uniqueID)))
		{
			eData.set(n, Reflect.field(data.Buildings.get(uniqueID), n));
		}
		setupNodes(node);
		hw = Math.floor(Math.sqrt(currentNodes.length));
		
		addC("View");
		addC("Health");
		addC("SpriteC");
		units = eData["units"];
		for (i in units)
		{
			unitsToProduce.push(i.unit);
			controls.push(new UnitControl(0, ActorControlTypes.PRODUCE, function() { createUnit(iteratorNum); }, "assets" + data.Actors.get(unitsToProduce[iteratorNum]).spriteFile.substr(2), data.Actors.get(unitsToProduce[iteratorNum]).id));
			iteratorNum++;
		}
	}
	
	/**
	 * Spawns Unit next to the building
	 * @param	i 	iterator in the buildings units Array
	 */
	private function createUnit(i:Int)
	{
		var x = 0;
		var y = 0;
		var newUnit:DBActor = null;
		var inverseI = currentNodes.length;
		var j;
		if (data.Actors.get(unitsToProduce[i]).cost <= team.resources)
		{
			for (j in 0...currentNodes.length)
			{
				inverseI--;
				for (neighbor in currentNodes[inverseI].neighbors)
				{
					if (currentNodes.indexOf(neighbor) == -1 && neighbor.occupant == null)
					{
						newUnit= new DBActor(data.Actors.get(unitsToProduce[i]).id, neighbor);
						team.addUnit(newUnit);
						team.resources -= Std.int(data.Actors.get(unitsToProduce[i]).cost);
						break;
					}
				}
				if (newUnit != null)
				{
					break;
				}
			}
		}
	}	
	
	override function setupNodes(node:Node) 
	{
		currentNodes = node.getAllNodes(Std.int(16 / node.width) - 1, Std.int(16 / node.height) - 1);
		
		for (i in 0...currentNodes.length)
		{
			currentNodes[i].occupant = this;
		}
	}
}