package systems;

import actors.BaseActor;
import flixel.group.FlxTypedGroup;

/**
 * ...
 * @author John Doughty
 */
class Team
{
	public var flxUnits:FlxTypedGroup<BaseActor> = new FlxTypedGroup<BaseActor>();//to use flixel overlap
	public var units:Array<BaseActor> = [];
	public var id(default,null):Int;

	private static var teamIds = 0;
	
	public function new() 
	{
		id = teamIds++;
	}
	
	public function addUnit(actor:BaseActor):Void
	{
		units.push(actor);
		flxUnits.add(actor);
		actor.team = id;
	}
}