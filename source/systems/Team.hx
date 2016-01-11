package systems;

import actors.BaseActor;
import actors.Unit;
import flixel.group.FlxTypedGroup;

/**
 * ...
 * @author John Doughty
 */
class Team
{
	public var flxUnits:FlxTypedGroup<Unit> = new FlxTypedGroup<Unit>();//to use flixel overlap
	public var flxBuildings:FlxTypedGroup<BaseActor> = new FlxTypedGroup<BaseActor>();//to use flixel overlap
	public var units:Array<Unit> = [];
	public var buildings:Array<BaseActor> = [];
	public var id(default,null):Int;

	private static var teamIds = 0;
	
	public function new() 
	{
		id = teamIds++;
	}
	
	public function addUnit(unit:Unit):Void
	{
		units.push(unit);
		flxUnits.add(unit);
		unit.team = this;
	}
	
	public function addBuilding(building:BaseActor):Void
	{
		buildings.push(building);
		flxBuildings.add(building);
		building.team = this;
	}
}