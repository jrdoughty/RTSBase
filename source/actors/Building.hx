package actors;

import dashboard.UnitControl;
import interfaces.IGameState;
import dashboard.Control;
import world.Node;
import actors.BaseActor;
import flixel.FlxSprite;
import actors.DBActor;
import flixel.FlxG;
import components.View;
import components.Health;

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
		var spriteFile:String;

		super(node);
		
		data = systems.Data;//hack
		eData = data.Buildings.get(uniqueID);//supposedly Buildings doesn't have get
		
		setupNodes(node);
		
		hw = Math.floor(Math.sqrt(currentNodes.length));
		addC("View");
		addC("Health");
		for (i in 0...eData.units.length)
		{
			unitsToProduce.push(eData.units[i].unit);
			controls.push(new UnitControl(0, ActorControlTypes.PRODUCE, function() { createUnit(i); }, "assets" + data.Actors.get(unitsToProduce[i]).spriteFile.substr(2), data.Actors.get(unitsToProduce[i]).id));
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
						FlxG.state.add(newUnit);
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

	
	
	
}