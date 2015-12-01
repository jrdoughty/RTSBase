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
	private var data:Dynamic;
	private var unit:Dynamic;
	
	public function new(unitID:String,node:Node, state:IGameState) 
	{
		data = systems.Data;
		unit = data.Actors.get(unitID);
		speed = unit.speed;
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