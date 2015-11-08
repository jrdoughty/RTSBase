package dashboard;

import flixel.FlxSprite;
import flixel.group.FlxGroup;
import systems.InputHandler;

/**
 * ...
 * @author ...
 */
class Dashboard extends FlxGroup
{
	public var background:FlxSprite;
	private var controls:ControlsContainer;
	private var inputHandler:InputHandler;
	
	public function new(x:Int, y:Int, inputH:InputHandler) 
	{
		super();
		inputHandler = inputH;
		background = new FlxSprite(x, y);
		background.loadGraphic("assets/images/dashBG.png");
		controls = new ControlsContainer(y);
		add(background);
		add(controls);
		
	}
	
}