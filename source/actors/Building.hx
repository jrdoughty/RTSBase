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

	public function new(uniqueID:String, node:Node) 
	{
		var i:Int;
		var spriteFile:String;
		data = systems.Data;//hack
		buildingData = data.Buildings.get(uniqueID);//supposedly Actors doesn't have get
		
		super(node);
		
		healthMax = buildingData.health;
		for (i in 0...buildingData.units.length)
		{
			unitsToProduce.push(buildingData.units[i].unit);
			controls.push(new UnitControl(0, ActorControlTypes.PRODUCE, createUnit, "assets"+data.Actors.get(unitsToProduce[i]).spriteFile.substr(2),data.Actors.get(unitsToProduce[i]).id));
		}
	}
	
	private function createUnit()
	{
		FlxG.state.add(new Unit(data.Actors.get(unitsToProduce[0]).id,Node.getNodeByGridXY(5,5)));
	}
	
	override function setupGraphics() 
	{
		var assetPath:String = "assets" + buildingData.spriteFile.substr(2);
		
		loadGraphic(assetPath);
	}
	
	
	
}