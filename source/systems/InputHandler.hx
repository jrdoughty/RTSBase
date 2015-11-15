package systems;
import actors.BaseActor;
import actors.Unit;
import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.plugin.MouseEventManager;
import flixel.util.FlxColor;
import interfaces.IGameState;
import flixel.FlxCamera;
import dashboard.Control;
import world.Node;

/**
 * ...
 * @author ...
 */

enum InputState {
	SELECTING;
	ATTACKING;
	MOVING;
	CASTING;
}
 
class InputHandler
{
	private var selectedUnits:Array<Unit> = [];
	private var inputState:InputState = InputState.SELECTING;
	private var activeState:IGameState;
	
	private var flxTeamUnits:FlxGroup = new FlxGroup();
	private var flxActiveTeamUnits:FlxGroup = new FlxGroup();
	private var flxNodes:FlxGroup = new FlxGroup();
	private var nodes:Array<Node>;
	private var selector:FlxSprite;
	
	private var selectorStartX:Float;
	private var selectorStartY:Float;
	
	private var newLeftClick:Bool = true;
	private var wasRightMouseDown:Bool = false;
	private var wasLeftMouseDown:Bool = false;
	
	
	public function new(state:IGameState) 
	{
		activeState = state;
		selector = new FlxSprite(-1,-1);
		selector.makeGraphic(1, 1, FlxColor.WHITE);
		for (i in 0...Node.activeNodes.length)
		{
			flxNodes.add(Node.activeNodes[i]);
			MouseEventManager.add(Node.activeNodes[i], null, null, onOver);
		}
		for (i in 0...activeState.Teams.length)
		{
			flxTeamUnits.add(activeState.Teams[i].flxUnits);
		}
		flxActiveTeamUnits.add(activeState.activeTeam.flxUnits);
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
		else if (node.occupant != null && node.occupant.team != activeState.activeTeam.id)
		{
			for (i in 0...selectedUnits.length)
			{
				selectedUnits[i].resetStates();
				selectedUnits[i].targetEnemy = node.occupant;
			}
		}
	}
	
	private function click():Void
	{
		newLeftClick = true;
		if (FlxG.overlap(selector, flxActiveTeamUnits, selectOverlapUnits) == false)
		{
			if (selector.width < activeState.getLevel().tiledLevel.tilewidth && selector.height < activeState.getLevel().tiledLevel.tileheight)
			{
				FlxG.overlap(selector, flxNodes, nodeClick);
			}
		}
		
		activeState.remove(selector);
	}
	
	private function attackOverlap(selector:FlxObject, unit:BaseActor):Void
	{
		trace("attack");
		var i:Int;
		for (i in 0...selectedUnits.length)
		{
			selectedUnits[i].targetEnemy = unit;
		}
	}
	
	private function selectOverlapUnits(selector:FlxObject, unit:Unit):Void
	{
		if (newLeftClick)
		{
			deselectUnits();
			selectedUnits = [];
			activeState.dashboard.clearDashBoard();
			activeState.dashboard.setSelected(unit);
		}
		activeState.dashboard.addSelectedUnit(unit);
		selectedUnits.push(unit);
		unit.select();
		newLeftClick = false;
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
		if (activeState.getLevel().highlight != null && sprite.occupant != null)
		{
			activeState.getLevel().highlight.visible = true;
			activeState.getLevel().highlight.x = sprite.x;
			activeState.getLevel().highlight.y = sprite.y;
		}
		else
		{
			activeState.getLevel().highlight.visible = false;
		}
	}
	
	@:extern inline private function setupSelectorSize()
	{
		var width:Int;
		var height:Int;
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
			if (FlxG.mouse.y > activeState.dashboard.background.y)
			{
				height = Math.round(activeState.dashboard.background.y - selector.y);
			}
			else
			{
				height = Math.round(FlxG.mouse.y - selector.y);
			}
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
	
	public function update()
	{
		if (FlxG.mouse.pressed)
		{
			if (wasLeftMouseDown)
			{
				setupSelectorSize();
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
		
		if (FlxG.mouse.pressedRight)
		{
			
			
			wasRightMouseDown = true;
		}
		else
		{
			wasRightMouseDown = false;
		}
	}
	
}