package systems;
import actors.BaseActor;
import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.plugin.MouseEventManager;
import flixel.util.FlxColor;
import interfaces.RTSGameState;
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
	private var activeState:RTSGameState;
	private var newClick:Bool = true;
	private var selectorStartX:Float;
	private var selectorStartY:Float;
	private var selector(default,null):FlxSprite;
	
	public function new(state:RTSGameState) 
	{
		activeState = state;
		selector = new FlxSprite(-1,-1);
		selector.makeGraphic(1, 1, FlxColor.WHITE);
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
				selectedUnits[i].resetStates();
				selectedUnits[i].targetNode = node;
			}
		}
	}
	
	private function click():Void
	{
		newClick = true;
		if (FlxG.overlap(selector, flxTeamUnits, selectOverlap) == false && selector.width < activeState.getLevel().tiledLevel.tilewidth && selector.height < activeState.getLevel().tiledLevel.tileheight)
		{
			FlxG.overlap(selector, flxNodes, nodeClick);
		}
		
		activeState.remove(selector);
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
		if (activeState.getLevel().highlight != null)
		{
			activeState.getLevel().highlight.x = sprite.x;
			activeState.getLevel().highlight.y = sprite.y;
		}
	}
	public function update()
	{
		var width:Int;
		var height:Int;
		if (FlxG.mouse.pressed)
		{
			if (wasLeftMouseDown)
			{
				if (FlxG.mouse.x < selectorStartX)
				{
					selector.x = FlxG.mouse.x;
					width = Math.round(selectorStartX - FlxG.mouse.x);
				}
				else
				{
					selector.x = selectorStartX;
					width = Math.round(FlxG.mouse.x - selector.x);
				}
				
				if (FlxG.mouse.y < selectorStartY)
				{
					selector.y = FlxG.mouse.y;
					height = Math.round(selectorStartY - FlxG.mouse.y);
				}
				else
				{
					selector.y = selectorStartY;
					height = Math.round(FlxG.mouse.y - selector.y);
				}
				if (width == 0)
				{
					width = 1;//setGraphics makes squares with a 0 height or width
				}
				if (height == 0)
				{
					height = 1;//setGraphics makes squares with a 0 height or width
				}
				selector.setGraphicSize(width, height);
				selector.updateHitbox();
			}
			else
			{
				activeState.add(selector);
				selector.alpha = .5;
				selectorStartX = FlxG.mouse.x;
				selectorStartY = FlxG.mouse.y;
				selector.x = selectorStartX;
				selector.y = selectorStartY;
				selector.setGraphicSize(1, 1);
				selector.updateHitbox();
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