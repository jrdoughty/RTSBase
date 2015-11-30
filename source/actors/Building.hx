package actors;

import interfaces.IGameState;
import world.Node;

/**
 * ...
 * @author ...
 */
class Building extends BaseActor
{

	public function new(topLeftNode:Node, state:IGameState) 
	{
		var i:Int;
		super(topLeftNode, state);
	}
	
	private override function setupGraphics() 
	{
		super.setupGraphics();
		loadGraphic("assets/images/building.png");
	}
	
	private override function setupNodes(node:Node)
	{	
		currentNodes = node.getAllNodes(Std.int(width / 8) - 1, Std.int(height / 8) - 1);
		
		for (i in 0...currentNodes.length)
		{
			currentNodes[i].occupant = this;
		}
	}
	
}