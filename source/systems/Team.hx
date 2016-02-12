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
	public var allies:Array<Int> = [];
	public var id(default, null):Int;
	public var resources:Int = 400;

	private static var teamIds = 0;
	
	public function new() 
	{
		id = teamIds++;
	}
	
	public function addUnit(unit:Unit):Void
	{
		flxUnits.add(unit);
		unit.team = this;
	}
	
	public function addBuilding(building:BaseActor):Void
	{
		flxBuildings.add(building);
		building.team = this;
	}
	
	public function addAlly(team:Team):Void
	{
		if (allies.indexOf(team.id) == -1)
		{
			allies.push(team.id);
			if (team.allies.indexOf(id) == -1)
			{
				team.addAlly(this);
			}
		}
	}
	
	public function removeAlly(team:Team):Void
	{
		if (allies.indexOf(team.id) != -1)
		{
			allies.splice(allies.indexOf(team.id), 1);
			if (team.allies.indexOf(team.id) != -1)
			{
				team.removeAlly(this);
			}
		}
	}
	
	public function isThreat(id:Int):Bool
	{
		if (allies.indexOf(id) != -1 || id == this.id)
		{
			return false;
		}
		else
		{
			return true;
		}
	}
	
	public function isTeamThreat(team:Team):Bool
	{
		if (allies.indexOf(team.id) != -1 || team.id == id)
		{
			return false;
		}
		else
		{
			return true;
		}
	}
}