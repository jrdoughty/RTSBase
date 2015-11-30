package actors;

import interfaces.IGameState;
import world.Node;
import systems.Data;
import openfl.Assets;

/**
 * ...
 * @author ...
 */
class CastleDBUnit extends BaseActor
{
	var id:String;
	var name:String;
	var data:Dynamic;
	
	public function new(unitID:String,node:Node, state:IGameState) 
	{
		id = unitID;
		data = systems.Data;
		name = data.Actors.get(unitID).name;
		super(node, state);
	}
	override function setupGraphics() 
	{
		super.setupGraphics();
		loadGraphic(data.Actors.get(id).Sprite, true, 8, 8);
		animation.add("active", [0, 1], 5, true);
		animation.add("attack", [0, 2], 5, true);
		idleFrame = 0;
	}
}