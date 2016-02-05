package components;
import actors.BaseActor;

/**
 * ...
 * @author John Doughty
 */
class AttackEvent extends EventObject
{
	public var target:BaseActor;
	public function new(target:BaseActor) 
	{
		super();
		this.target = target;
	}
	
}