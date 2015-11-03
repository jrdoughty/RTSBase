package interfaces;
import flixel.FlxBasic;
import world.SelfLoadingLevel;
import world.TiledTypes.TiledLevel;
import systems.Team;

/**
 * @author John Doughty
 */
interface GameState 
{
	public function add(Object:FlxBasic):FlxBasic;
	public function remove(Object:FlxBasic, Splice:Bool = false):FlxBasic;
	public function getLevel():SelfLoadingLevel;
	public var Teams(default,null):Array<Team>;
	public var activeTeam(default,null):Team;
}