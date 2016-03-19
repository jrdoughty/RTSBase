package events;
import actors.BaseActor;

/**
 * ...
 * @author John Doughty
 */
class TargetEvent extends EventObject
{
	public var target:BaseActor;
	public static inline var ATTACK_ACTOR:String = "ATTACK_ACTOR";
	/**
	 * 
	 * @param	target		BaseActor to be attacked
	 */
	public function new(target:BaseActor) 
	{
		super();
		this.target = target;
	}
	
}