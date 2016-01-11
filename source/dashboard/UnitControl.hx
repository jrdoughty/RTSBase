package dashboard;

import actors.BaseActor.ActorControlTypes;
import haxe.Constraints.Function;

/**
 * ...
 * @author John Doughty
 */
class UnitControl extends Control
{
	public var unitID:String;
	public function new(frame:Int=7, type:ActorControlTypes, callback:Function,spriteString:String, unit:String)
	{
		super(frame, type, callback, spriteString);
		
		unitID = unit;
	}
	
}