package actors;

import dashboard.UnitControl;
import interfaces.IGameState;
import dashboard.Control;
import world.Node;
import actors.BaseActor;
import flixel.FlxSprite;
import actors.Unit;
import flixel.FlxG;

/**
 * ...
 * @author John Doughty
 */
class Building extends BaseActor
{
	private var data:Dynamic;
	private var buildingData:Dynamic;
	private var unitsToProduce:Array<String> = [];
	private var callbacks:Array<Dynamic> = [];
	private var hw:Int;

	public function new(uniqueID:String, node:Node) 
	{
		var i:Int;
		var spriteFile:String;
		data = systems.Data;//hack
		buildingData = data.Buildings.get(uniqueID);//supposedly Actors doesn't have get
		
		super(node);
		hw = Math.floor(Math.sqrt(currentNodes.length));
		viewRange = buildingData.viewRange;
		
		healthMax = buildingData.health;
		for (i in 0...buildingData.units.length)
		{
			unitsToProduce.push(buildingData.units[i].unit);
			controls.push(new UnitControl(0, ActorControlTypes.PRODUCE, function() { createUnit(i); }, "assets" + data.Actors.get(unitsToProduce[i]).spriteFile.substr(2), data.Actors.get(unitsToProduce[i]).id));
		}
	}
	
	private function createUnit(i:Int)
	{
		var x = 0;
		var y = 0;
		var newUnit:Unit = null;
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
						newUnit= new Unit(data.Actors.get(unitsToProduce[i]).id, neighbor);
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
	
	override function setupGraphics() 
	{
		var assetPath:String = "assets" + buildingData.spriteFile.substr(2);
		
		loadGraphic(assetPath);
	}
	
	
	
}