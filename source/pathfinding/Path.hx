package pathfinding;
import world.Node;

/**
 * ...
 * @author John Doughty
 */
class Path
{
	private path:Array<Node>;
	private heiristic:Int;
	
	public function new(start:Node, end:Node);
	public function getNext():Node;
	public function getHeiristic():Int;
	public function calculate(start:Node, end:Node);
	
}