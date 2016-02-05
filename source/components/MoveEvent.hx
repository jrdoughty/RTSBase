package components;
import world.Node;

/**
 * ...
 * @author John Doughty
 */
class MoveEvent extends EventObject
{
	public var node:Node;
	
	public function new(node:Node) 
	{
		this.node = node;
		super();
		
	}
	
}