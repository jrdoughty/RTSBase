package dashboard;

import flixel.FlxSprite;
import flixel.group.FlxGroup;

/**
 * ...
 * @author ...
 */
class ControlsContainer extends FlxGroup
{
	private var background:FlxSprite;
	private var controls:Array<UnitControl> = [];
	
	public function new(y:Int) 
	{
		var i:Int;
		super();
		background = new FlxSprite(0, y);
		background.loadGraphic("assets/images/controlsBG.png");
		add(background);
		for (i in 0...7)
		{
			controls.push(new UnitControl(2+(i%3)*18, y + Math.floor(i/3)*18 + 2));
			add(controls[i]);
			controls[i].setFrameIndex(i);
		}
	}
	
}