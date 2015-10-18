package pathfinding;
import world.Node;

/**
 * ...
 * @author John Doughty
 */
interface Path
{
	private var pathHeiristic:Int;
	
	public function getNext():Node;
	public function getHeiristic():Int;
	
}