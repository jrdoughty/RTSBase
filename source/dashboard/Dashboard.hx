package dashboard;

import actors.BaseActor;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import systems.InputHandler;
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
	private var inputHandler:InputHandler;
	private var selected:FlxSprite;
	private var activeUnits:Array<BaseActor> = [];
	private var representatives:Array<ActorRepresentative> = [];
	private var baseY:Int = 0;
	private var baseX:Int = 0;
	
	public function new(x:Int, y:Int, inputH:InputHandler):Void
	{
		super();
		
		baseX = x;
		baseY = y;
		
		inputHandler = inputH;
		background = new FlxSprite(baseX, baseY);
		background.loadGraphic("assets/images/dashBG.png");
		controls = new FlxSprite(baseX,baseY).loadGraphic("assets/images/controlsBG.png");
		
		selected = new FlxSprite();
		selected.x = controls.width + 4;
		selected.y = baseY + 4;
		
		add(background);
		add(controls);
		//add(selected);
	}
	
	public function setSelected(baseA:BaseActor):Void
	{
		var i:Int;
		
		selected.loadGraphicFromSprite(baseA);
		selected.setGraphicSize(48, 48);
		selected.updateHitbox();
		selected.animation.frameIndex = baseA.animation.frameIndex;
		selected.animation.pause();
		add(selected);
		activeControls = baseA.controls;
		
		for (i in 0...activeControls.length)
		{
			
			add(activeControls[i]);
			activeControls[i].x = 2 + (i % 3) * 18;
			activeControls[i].y = 184 + Math.floor(i / 3) * 18 + 2;
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
	
	public function addSelectedUnit(baseA:BaseActor):Void
	{
		if (activeUnits.indexOf(baseA) == -1)
		{
			activeUnits.push(baseA);
			var sprite:ActorRepresentative = new ActorRepresentative(baseA);
			representatives.push(sprite);
			add(sprite);
			add(sprite.healthBar);
			add(sprite.healthBarFill);
			sprite.setDashPos(112 + Math.floor((representatives.length - 1) % ((background.width -112) / 16)) * 16, 184 + 16 * Math.floor((representatives.length - 1) * 16 / (background.width -112)));
			
		}
	}
	
	private function redoDashboard():Void
	{
		var i:Int;
		for (i in 0...representatives.length)
		{
			representatives[i].setDashPos(112 + Math.floor(i % ((background.width -112) / 16)) * 16, 184 + 16 * Math.floor(i * 16 / (background.width -112)));
		}
	}
	
	override public function update():Void
	{
		var i:Int = 0;
				
		super.update();
		
		background.y = baseY - FlxG.camera.y;
		
		while(i < representatives.length)//because the length gets stored ahead in haxe for loops, the changing length breaks this loop
		{
			if (representatives[i].alive)
			{
				representatives[i].update();
			}
			else
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
}