package dashboard;

import actors.BaseActor;
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
	private var selected:FlxSprite;
	
	public function new(x:Int, y:Int, inputH:InputHandler) 
	{
		super();
		inputHandler = inputH;
		background = new FlxSprite(x, y);
		background.loadGraphic("assets/images/dashBG.png");
		controls = new ControlsContainer(y);
		
		selected = new FlxSprite();
		selected.x = controls.background.width;
		selected.y = y;
		
		add(background);
		add(controls);
		add(selected);
	}
	
	public function setSelected(sprite:BaseActor)
	{
		var i:Int;
		
		selected.loadGraphicFromSprite(sprite);
		selected.setGraphicSize(56, 56);
		selected.updateHitbox();
		selected.animation.frameIndex = sprite.animation.frameIndex;
		
		for (i in 0...sprite.controls.length)
		{
			controls.add(sprite.controls[i]);
			sprite.controls[i].x = 2 + (i % 3) * 18;
			sprite.controls[i].y = 184 + Math.floor(i / 3) * 18 + 2;
		}
	}
}