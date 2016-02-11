package events;
import events.EventObject;
import world.Node;

/**
 * ...
 * @author John Doughty
 */
class MoveEvent extends EventObject
{
	public var node:Node;
	public var aggressive:Bool;
	public static inline var MOVE:String = "MOVE";
	
	public function new(node:Node, aggressive:Bool = false) 
	{
		this.node = node;
		this.aggressive = aggressive;
		super();
		
	}
	
}