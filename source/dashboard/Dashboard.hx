package dashboard;

import actors.BaseActor;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import systems.InputHandler;
import dashboard.Control;

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
	private var activeControls:Array<Control> = [];
	private var activeUnits:Array<ActorRepresentative> = [];
	
	public function new(x:Int, y:Int, inputH:InputHandler):Void
	{
		super();
		inputHandler = inputH;
		background = new FlxSprite(x, y);
		background.loadGraphic("assets/images/dashBG.png");
		controls = new ControlsContainer(y);
		
		selected = new FlxSprite();
		selected.x = controls.background.width + 4;
		selected.y = y + 4;
		
		add(background);
		add(controls);
		add(selected);
	}
	
	public function setSelected(baseA:BaseActor):Void
	{
		var i:Int;
		
		selected.loadGraphicFromSprite(baseA);
		selected.setGraphicSize(48, 48);
		selected.updateHitbox();
		selected.animation.frameIndex = baseA.animation.frameIndex;
		selected.animation.pause();
		
		activeControls = baseA.controls;
		
		for (i in 0...baseA.controls.length)
		{
			controls.add(baseA.controls[i]);
			baseA.controls[i].x = 2 + (i % 3) * 18;
			baseA.controls[i].y = 184 + Math.floor(i / 3) * 18 + 2;
		}
	}
	
	public function clearDashBoard():Void
	{
		var i:Int;
		
		for (i in 0...activeControls.length)
		{
			controls.remove(activeControls[i]);			
		}
		for (i in 0...activeUnits.length)
		{
			remove(activeUnits[i]);
			remove(activeUnits[i].healthBarFill);
			remove(activeUnits[i].healthBar);
		}
		activeUnits = [];
		
	}
	
	public function addSelectedUnit(baseA:BaseActor):Void
	{
		var sprite:ActorRepresentative = new ActorRepresentative(baseA,112 + activeUnits.length * 16, 184);
		activeUnits.push(sprite);
		add(sprite);
		add(sprite.healthBar);
		add(sprite.healthBarFill);
	}
	
	override public function update():Void
	{
		var i:Int;
				
		super.update();
		
		for (i in 0...activeUnits.length)
		{
			if (activeUnits[i].alive)
			{
				activeUnits[i].update();
			}
			else
			{
				remove(activeUnits[i]);
				remove(activeUnits[i].healthBarFill);
				remove(activeUnits[i].healthBar);
				activeUnits.splice(i, 1);
			}
		}
	}
}