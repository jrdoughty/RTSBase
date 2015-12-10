package actors;

import interfaces.IGameState;
import dashboard.Control;
import world.Node;
import actors.BaseActor;

/**
 * ...
 * @author John Doughty
 */
class Building extends BaseActor
{
	private var data:Dynamic;
	private var buildingData:Dynamic;
	private var unitsToProduce:Array<String> = [];

	public function new(uniqueID:String, node:Node, state:IGameState) 
	{
		var i:Int;
		var spriteFile:String;
		data = systems.Data;//hack
		buildingData = data.Buildings.get(uniqueID);//supposedly Actors doesn't have get
		
		super(node, state);
		
		healthMax = buildingData.health;
		for (i in 0...buildingData.units.length)
		{
			unitsToProduce.push(buildingData.units[i].unit);
			controls.push(new Control(0, ActorControlTypes.BUILD, "assets"+data.Actors.get(unitsToProduce[i]).spriteFile.substr(2)));
		}
	}
	
	override function setupGraphics() 
	{
		var assetPath:String = "assets" + buildingData.spriteFile.substr(2);
		
		loadGraphic(assetPath);
	}
	
	
	
}