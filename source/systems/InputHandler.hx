package systems;
import actors.BaseActor;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.plugin.MouseEventManager;
import world.Node;

/**
 * ...
 * @author ...
 */

enum InputState {
	SELECTING;
	ATTACKING;
	PATROL;
	BUILD;
}

class InputHandler
{
	public var state:InputState = SELECTING;
	
	private static var selectedUnit:BaseActor = null;
	private static var selectedUnits:Array<BaseActor> = [];
	
	private var wasLeftMouseDown:Bool = false;
	private var flxTeamUnits:FlxGroup = new FlxGroup();
	private var flxNodes:FlxGroup = new FlxGroup();
	private var nodes:Array<Node>;
	
	public function new() 
	{
		for (i in 0...Node.activeNodes.length)
		{
			flxNodes.add(Node.activeNodes[i]);
			MouseEventManager.add(Node.activeNodes[i], onClick, removeSelector, onOver);
		}
	}
	
	public static function setOnPath(node:Node)
	{
		if (selectedUnit != null)
		{
			selectedUnit.targetNode = node;
		}
	}
	
	public static function selectUnit(baseA:BaseActor):Void
	{
		if(selectedUnit != null)
		{
			selectedUnit.resetSelect();
		}
		selectedUnit = baseA;

		if(selectedUnit != null)
		{
			selectedUnit.select();
		}
	}

	public static function getSelectedUnit():BaseActor
	{
		return selectedUnit;
	}
	
	private function onClick(sprite:Node):Void
	{
		//add(selector);
		PlayState.selector.alpha = .5;
		PlayState.selector.x = FlxG.mouse.x;
		PlayState.selector.y = FlxG.mouse.y;
		PlayState.selector.setGraphicSize(1, 1);
		PlayState.selector.updateHitbox();
		if (selectedUnit != null && sprite.isPassible() && sprite.occupant == null)
		{
			setOnPath(sprite);
		}
		else if (sprite.occupant != null)
		{
			selectUnit(sprite.occupant);
		}
	}
	
	private function selectOverlap(selector:FlxObject, unit:BaseActor):Void
	{
		if (unit.team == PlayState.activeTeam.id)
		{
			selectedUnits.push(unit);
			unit.select();
		}
	}
	
	private function removeSelector(sprite:FlxSprite)
	{
		//remove(selector);
	}
	
	private function deselectUnits():Void
	{
		var i:Int;
		for (i in 0...selectedUnits.length)
		{
			selectedUnits[i].resetSelect();
		}
	}
	
	private function onOver(sprite:Node):Void
	{
		PlayState.getLevel().highlight.x = sprite.x;
		PlayState.getLevel().highlight.y = sprite.y;
	}
	public function update()
	{
		
		if (FlxG.mouse.pressed)
		{
			if (wasLeftMouseDown)
			{
				PlayState.selector.setGraphicSize(Math.floor(FlxG.mouse.x - PlayState.selector.x), Math.floor(FlxG.mouse.y - PlayState.selector.y));
				PlayState.selector.updateHitbox();
			}
			wasLeftMouseDown = true;
		}
		else
		{
			if (wasLeftMouseDown)
			{
				deselectUnits();
				selectedUnits = [];
				FlxG.overlap(PlayState.selector, flxTeamUnits, selectOverlap);
			}
			wasLeftMouseDown = false;
		}
	}
}