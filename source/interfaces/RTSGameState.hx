package interfaces;
import flixel.FlxBasic;
import world.SelfLoadingLevel;
import world.TiledTypes.TiledLevel;

/**
 * @author John Doughty
 */
interface RTSGameState 
{
	public function add(Object:FlxBasic):FlxBasic;
	public function remove(Object:FlxBasic, Splice:Bool = false):FlxBasic;
	public function getLevel():SelfLoadingLevel;
}