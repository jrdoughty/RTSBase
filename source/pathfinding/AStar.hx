package pathfinding;
import world.Node;

/**
 * ...
 * @author John Doughty
 */
class AStar implements Path
{
	private path:Array<Node>;
	private heiristic:Int;
	
	public function new(start:Node, end:Node) 
	{
		
	}

	public function getNext():Node
	{
		return path[0];
	}

	public function getHeiristic():Int
	{
		
	}
	
	public function calculate(start:Node, end:Node)
	{
		
	}
}