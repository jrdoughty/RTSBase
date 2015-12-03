package actors;

import interfaces.IGameState;
import world.Node;
import systems.Data;
import openfl.Assets;

/**
 * ...
 * @author ...
 */
class CastleDBUnit extends Unit
{
	var unitData:Dynamic;
	var data:Dynamic;	
	
	public function new(unitID:String, node:Node, state:IGameState) 
	{
		data = systems.Data;//hack
		unitData = data.Actors.get(unitID);//supposedly Actors doesn't have get
		super(node, state);//super is called after because setup graphics, called by super, needs the unit data
		healthMax = unitData.health;
		speed = unitData.speed;
		damage = unitData.damage;
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
}