package adapters;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxG;
import flixel.util.FlxColor;

/**
 * ...
 * @author John Doughty
 */
class TwoDRect extends TwoDSprite
{

	public function new() 
	{
		super(-1,-1);
		makeGraphic(1, 1, FlxColor.WHITE);
		FlxG.state.add(this);
	}
	
}