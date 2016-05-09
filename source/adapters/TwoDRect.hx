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

	public function new(?x:Float = -1,?y:Float = -1,?color:String = "WHITE",?width:Int = 1,?height:Int = 1) 
	{
		var flxColor:FlxColor;
		super(x, y);
		
		switch(color.toUpperCase())
		{
			case "GRAY": flxColor = FlxColor.GRAY;
			case "BLACK": flxColor = FlxColor.BLACK;
			case "GREEN": flxColor = FlxColor.GREEN;
			case "LIME": flxColor = FlxColor.LIME;
			case "YELLOW": flxColor = FlxColor.YELLOW;
			case "ORANGE": flxColor = FlxColor.ORANGE;
			case "RED": flxColor = FlxColor.RED;
			case "PURPLE": flxColor = FlxColor.PURPLE;
			case "BLUE": flxColor = FlxColor.BLUE;
			case "BROWN": flxColor = FlxColor.BROWN;
			case "PINK": flxColor = FlxColor.PINK;
			case "MAGENTA": flxColor = FlxColor.MAGENTA;
			case "CYAN": flxColor = FlxColor.CYAN;
			default: flxColor = FlxColor.WHITE;
		}
		
		makeGraphic(width, height, flxColor);
		FlxG.state.add(this);
	}
	
}