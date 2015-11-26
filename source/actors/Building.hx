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
		super(topLeftNode, state);
		loadGraphic("assets/images/building.png");
	}
	
}