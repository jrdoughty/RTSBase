package actors;

import interfaces.IGameState;
import world.Node;

/**
 * ...
 * @author John Doughty
 */
class Building extends BaseActor
{
	private var data:Dynamic;
	private var unitData:Dynamic;

	public function new(uniqueID:String, node:Node, state:IGameState) 
	{
		var i:Int;
		data = systems.Data;//hack
		unitData = data.Buildings.get(uniqueID);//supposedly Actors doesn't have get
		
		super(node, state);
		
		healthMax = unitData.health;
	}
	
	override function setupGraphics() 
	{
		var assetPath:String = "assets" + unitData.spriteFile.substr(2);
		super.setupGraphics();
		
		loadGraphic(assetPath);
	}
	
}