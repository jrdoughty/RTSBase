package dashboard;

import actors.BaseActor;
import systems.InputSystem;
import dashboard.Control;
import events.GetSpriteEvent;
import adapters.TwoDSprite;
import flixel.FlxG;

/**
 * ...
 * @author ...
 */
class Dashboard
{
	public var background:TwoDSprite;
	public var activeControls:Array<Control> = [];
	
	private var controls:TwoDSprite;
	private var inputHandler:InputSystem;
	private var selected:TwoDSprite;
	private var activeUnits:Array<BaseActor> = [];
	private var representatives:Array<ActorRepresentative> = [];
	private var baseX:Float;
	
	public function new(inputH:InputSystem):Void
	{		
		inputHandler = inputH;
		background = new TwoDSprite(0,0, "assets/images/dashBG.png");
		background.x = 0;
		background.y = 184;
		controls = new TwoDSprite(background.x, background.y, "assets/images/controlsBG.png");
		
		selected = new TwoDSprite();
		selected.x = background.x + controls.width + 4;
		selected.y = 4 + background.y;
		
		FlxG.state.add(background);
		FlxG.state.add(controls);
		//add(selected);
	}
	
	public function setSelected(baseA:BaseActor):Void
	{
		var i:Int;
		
		baseA.dispatchEvent(GetSpriteEvent.GET, new GetSpriteEvent(setGraphics));
		
		FlxG.state.add(selected);
		activeControls = baseA.controls;
		
		for (i in 0...activeControls.length)
		{
			trace("Controls: "+i);
			FlxG.state.add(activeControls[i]);
			activeControls[i].x = 2 + (i % 3) * 18;
			activeControls[i].y = Math.floor(i / 3) * 18 + 2 + background.y;
		}
		inputHandler.setupClickControls(activeControls);
	}
	
	public function setGraphics(s:TwoDSprite)
	{
		selected.loadSpriteFromSprite(s);
		selected.setImageSize(48, 48);
		selected.setCurrentFrame(s.getCurrentFrame());
		selected.pauseAnimation();
	}
	
	public function clearDashBoard():Void
	{

		var i:Int;
		
		FlxG.state.remove(selected);
		
		for (i in 0...activeControls.length)
		{
			FlxG.state.remove(activeControls[i]);			
		}
		
		for (i in 0...representatives.length)
		{
			FlxG.state.remove(representatives[i]);
			FlxG.state.remove(representatives[i].healthBarFill);
			FlxG.state.remove(representatives[i].healthBar);
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
			FlxG.state.add(sprite);
			FlxG.state.add(sprite.healthBar);
			FlxG.state.add(sprite.healthBarFill);
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
	
	public function update():Void
	{
		var i:Int = 0;
		while(i < representatives.length)//because the length gets stored ahead in haxe for loops, the changing length breaks this loop
		{
			if (!representatives[i].baseActor.alive)
			{
				activeUnits.splice(activeUnits.indexOf(representatives[i].baseActor), 1);
				FlxG.state.remove(representatives[i]);
				FlxG.state.remove(representatives[i].healthBarFill);
				FlxG.state.remove(representatives[i].healthBar);
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