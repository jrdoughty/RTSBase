package systems;
import actors.BaseActor;
import flixel.FlxG;
import flixel.FlxState;
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
	private var activeState:FlxState;
	private var newClick:Bool = true;
	
	public function new(state:FlxState) 
	{
		activeState = state;
		for (i in 0...Node.activeNodes.length)
		{
			flxNodes.add(Node.activeNodes[i]);
			MouseEventManager.add(Node.activeNodes[i], null, null, onOver);
		}
		for (i in 0...PlayState.Teams.length)
		{
			flxTeamUnits.add(PlayState.Teams[i].flxUnits);
		}
	}
	
	
	private function nodeClick(selector:FlxObject,node:Node):Void
	{
		var i:Int;
		if (selectedUnits.length > 0 && node.isPassible() && node.occupant == null)
		{
			for (i in 0...selectedUnits.length)
			{
				selectedUnits[i].targetNode = node;
			}
		}
	}
	
	private function click():Void
	{
		newClick = true;
		if (FlxG.overlap(PlayState.selector, flxTeamUnits, selectOverlap) == false)
		{
			FlxG.overlap(PlayState.selector, flxNodes, nodeClick);
		}
		
		activeState.remove(PlayState.selector);
	}
	
	private function selectOverlap(selector:FlxObject, unit:BaseActor):Void
	{
		if (newClick)
		{
			deselectUnits();
			selectedUnits = [];
			newClick = false;
		}
		if (unit.team == PlayState.activeTeam.id)
		{
			selectedUnits.push(unit);
			unit.select();
		}
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
		if (PlayState.getLevel().highlight != null)
		{
			PlayState.getLevel().highlight.x = sprite.x;
			PlayState.getLevel().highlight.y = sprite.y;
		}
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
			else
			{
				activeState.add(PlayState.selector);
				PlayState.selector.alpha = .5;
				PlayState.selector.x = FlxG.mouse.x;
				PlayState.selector.y = FlxG.mouse.y;
				PlayState.selector.setGraphicSize(1, 1);
				PlayState.selector.updateHitbox();
			}
			wasLeftMouseDown = true;
		}
		else
		{
			if (wasLeftMouseDown)
			{
				click();
			}
			wasLeftMouseDown = false;
		}
	}
}