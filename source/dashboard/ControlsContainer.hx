package dashboard;

import flixel.FlxSprite;
import flixel.group.FlxGroup;

/**
 * ...
 * @author ...
 */
class ControlsContainer extends FlxGroup
{
	public var background(default,null):FlxSprite;
	private var controls:Array<Control> = [];
	
	public function new(y:Int) 
	{
		var i:Int;
		super();
		background = new FlxSprite(0, y);
		background.loadGraphic("assets/images/controlsBG.png");
		add(background);
	}
	
}