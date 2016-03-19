package dashboard;

import actors.BaseActor;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import systems.InputSystem;
import dashboard.Control;
import flixel.FlxG;

/**
 * ...
 * @author ...
 */
class Dashboard extends FlxGroup
{
	public var background:FlxSprite;
	public var activeControls:Array<Control> = [];
	
	private var controls:FlxSprite;
	private var inputHandler:InputSystem;
	private var selected:FlxSprite;
	private var activeUnits:Array<BaseActor> = [];
	private var representatives:Array<ActorRepresentative> = [];
	private var baseX:Float;
	
	public function new(inputH:InputSystem):Void
	{
		super();
		
		inputHandler = inputH;
		background = new FlxSprite();
		background.loadGraphic("assets/images/dashBG.png");
		background.x = 0;
		background.y = 184;
		controls = new FlxSprite(background.x,background.y).loadGraphic("assets/images/controlsBG.png");
		
		selected = new FlxSprite();
		selected.x = background.x + controls.width + 4;
		selected.y = 4 + background.y;
		
		add(background);
		add(controls);
		//add(selected);
	}
	
	public function setSelected(baseA:BaseActor):Void
	{
		var i:Int;
		/*
		selected.loadGraphicFromSprite(baseA);
		selected.setGraphicSize(48, 48);
		selected.updateHitbox();
		selected.animation.frameIndex = baseA.animation.frameIndex;
		selected.animation.pause();*/
		add(selected);
		activeControls = baseA.controls;
		
		for (i in 0...activeControls.length)
		{
			trace("Controls: "+i);
			add(activeControls[i]);
			activeControls[i].x = 2 + (i % 3) * 18;
			activeControls[i].y = Math.floor(i / 3) * 18 + 2 + background.y;
		}
		inputHandler.setupClickControls(activeControls);
	}
	
	public function clearDashBoard():Void
	{
		var i:Int;
		
		remove(selected);
		
		for (i in 0...activeControls.length)
		{
			remove(activeControls[i]);			
		}
		
		for (i in 0...representatives.length)
		{
			remove(representatives[i]);
			remove(representatives[i].healthBarFill);
			remove(representatives[i].healthBar);
		}
		activeUnits = [];
		representatives = [];
	}
	
	public function addSelectedActor(baseA:BaseActor):Void
	{
		if (activeUnits.indexOf(baseA) == -1)
		{
			activeUnits.push(baseA);
			var sprite:ActorRepresentative = new ActorRepresentative(baseA);
			representatives.push(sprite);
			add(sprite);
			add(sprite.healthBar);
			add(sprite.healthBarFill);
			sprite.setDashPos(Std.int(background.x) + 112 + Math.floor((representatives.length - 1) % ((background.width -112) / 16)) * 16,
			16 * Math.floor((representatives.length - 1) * 16 / (background.width - 112))+Std.int(background.y));
		}
	}
	
	private function redoDashboard():Void
	{
		var i:Int;
		for (i in 0...representatives.length)
		{
			representatives[i].setDashPos(Std.int(background.x) + 112 + Math.floor(i % ((background.width -112) / 16)) * 16, 16 * Math.floor(i * 16 / (background.width -112))+Std.int(background.y));
		}
	}
	
	override public function update(elapsed:Float):Void
	{
		var i:Int = 0;
				
		super.update(elapsed);
		
		while(i < representatives.length)//because the length gets stored ahead in haxe for loops, the changing length breaks this loop
		{
			if (!representatives[i].alive)
			{
				activeUnits.splice(activeUnits.indexOf(representatives[i].baseActor), 1);
				remove(representatives[i]);
				remove(representatives[i].healthBarFill);
				remove(representatives[i].healthBar);
				representatives.splice(i, 1);
				if (representatives.length == 0)
				{
					clearDashBoard();
					inputHandler.resetInputState();
				}
				else
				{
					redoDashboard();
				}
			}
			i++;
		}
	}
	public function adjustPos(x:Float,y:Float)
	{
		var i:Int;
		background.x = x;
		background.y = y + 184;
		redoDashboard();
		selected.x = background.x + controls.width + 4;
		selected.y = 4 + background.y;
		controls.x = background.x;
		controls.y = background.y;
	}
}