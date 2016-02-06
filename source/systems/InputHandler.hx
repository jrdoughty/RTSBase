package systems;
import actors.BaseActor;
import actors.Unit;
import actors.Building;
import components.AttackEvent;
import components.EventObject;
import components.MoveEvent;
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
import components.AI;

/**
 * ...
 * @author ...
 */

enum InputState 
{
	SELECTING;
	ATTACKING;
	MOVING;
	CASTING;
}
 
class InputHandler
{
	private var inputState:InputState = InputState.SELECTING;
	private var activeState:IGameState;
	
	private var flxTeamUnits:FlxGroup = new FlxGroup();
	private var flxActiveTeamUnits:FlxGroup = new FlxGroup();
	private var flxActiveTeamBuildings:FlxGroup = new FlxGroup();
	private var selectedUnits:Array<Unit> = [];
	private var selectedBuildings:Array<Building> = [];
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
		flxActiveTeamBuildings.add(activeState.activeTeam.flxBuildings);
	}
	
	private function onOver(sprite:Node):Void
	{
		if (inputState == SELECTING)
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
		else if (inputState == MOVING || inputState == ATTACKING)
		{
			activeState.getLevel().highlight.visible = true;
			activeState.getLevel().highlight.x = sprite.x;
			activeState.getLevel().highlight.y = sprite.y;
		}
	}
	
	
	public function setupClickControls(controls:Array<Control>)
	{
		var i:Int;
		for (i in 0...controls.length)
		{
			if (controls[i].callbackFunction != null)
			{
				var func:Dynamic = controls[i].callbackFunction;
				MouseEventManager.add(controls[i], null, controls[i].useCallback, controls[i].hover, controls[i].out, false, true, false);
			}
			else if (controls[i].type == ActorControlTypes.MOVE)
			{
				MouseEventManager.add(controls[i], null, move, controls[i].hover, controls[i].out, false, true, false);
			}
			else if (controls[i].type == ActorControlTypes.ATTACK)
			{
				MouseEventManager.add(controls[i], null, attack, controls[i].hover, controls[i].out, false, true, false);
			}
			else if (controls[i].type == ActorControlTypes.STOP)
			{
				MouseEventManager.add(controls[i], null, stop, controls[i].hover, controls[i].out, false, true, false);
			}
			
		}
	}
	
	private function move(sprite:FlxSprite = null)
	{
		inputState = MOVING;
	}
	
	private function attack(sprite:FlxSprite = null)
	{
		inputState = ATTACKING;
	}
	
	public function update()
	{
		//cameraUpdate();
		if (FlxG.keys.pressed.M)
		{
			move();
		}
		else if (FlxG.keys.pressed.S)
		{
			stop();
		}
		else if (FlxG.keys.pressed.A)
		{
			attack();
		}
		
		if (FlxG.mouse.pressed && wasLeftMouseDown)
		{
			setupSelectorSize();
			wasLeftMouseDown = true;
		}
		else if (FlxG.mouse.pressed && wasLeftMouseDown == false)
		{
			selector = new FlxSprite(-1,-1);
			selector.makeGraphic(1, 1, FlxColor.WHITE);
			activeState.add(selector);
			if (inputState == SELECTING)
			{
				selector.alpha = .5;
			}
			else
			{
				selector.alpha = 0;
			}
			selectorStartX = FlxG.mouse.x;
			selectorStartY = FlxG.mouse.y;
			selector.x = selectorStartX;
			selector.y = selectorStartY;
			selector.setGraphicSize(1, 1);
			selector.updateHitbox();
			wasLeftMouseDown = true;
		} 
		else if (wasLeftMouseDown && FlxG.mouse.pressed == false)
		{
			click();
			wasLeftMouseDown = false;
		}
		
		if (FlxG.mouse.justPressedRight)
		{
			rightClick();
		}
	}
	
	private function setupSelectorSize()
	{
		var width:Int;
		var height:Int;
		
		if (inputState == SELECTING)
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
		}
		else 
		{
			selector.alpha = 0;
			width = 1;
			height = 1;
			selector.x = FlxG.mouse.x;
			selector.y = FlxG.mouse.y;
		}
		selector.setGraphicSize(width, height);
		selector.updateHitbox();
	}
	
	private function click():Void
	{
		newLeftClick = true;
		if (FlxG.overlap(selector, activeState.dashboard) == false)
		{
			if (inputState == SELECTING)
			{
				if (FlxG.overlap(selector, flxActiveTeamUnits, selectOverlapUnits) == false)
				{
					if (FlxG.overlap(selector, flxActiveTeamBuildings, selectOverlapBuildings) == false)
					{
						activeState.dashboard.clearDashBoard();//Select Enemies later
					}
				} 
			}
			else if (inputState == MOVING)
			{			
				if (selector.width < activeState.getLevel().tiledLevel.tilewidth && selector.height < activeState.getLevel().tiledLevel.tileheight)
				{
					FlxG.overlap(selector, flxNodes, moveToNode);
				}
			}
			else if (inputState == ATTACKING)
			{			
				if (selector.width < activeState.getLevel().tiledLevel.tilewidth && selector.height < activeState.getLevel().tiledLevel.tileheight)
				{
					FlxG.overlap(selector, flxNodes, attackClick);
				}
			}
			resetInputState();
			
		}
		activeState.remove(selector);
		selector = null;
	}
	
	private function rightClick()
	{
		if (selector == null)
		{
			selector = new FlxSprite(FlxG.mouse.x, FlxG.mouse.y);
			selector.makeGraphic(1, 1, FlxColor.WHITE);
			activeState.add(selector);
		}
		selector.alpha = 0;
		if (FlxG.overlap(selector, activeState.dashboard) == false)
		{
			if (selector.width < activeState.getLevel().tiledLevel.tilewidth && selector.height < activeState.getLevel().tiledLevel.tileheight)
			{
				FlxG.overlap(selector, flxNodes, attackClick);
			}
		}
		activeState.remove(selector);
		selector = null;
	}
	
	private function stop(sprite:FlxSprite = null)
	{
		var i:Int;
		for (i in 0...selectedUnits.length)
		{
			selectedUnits[i].dispatchEvent(AI.STOP);
		}
		resetInputState();
	}
	
	public function resetInputState()
	{
		inputState = SELECTING;
	}
	
	private function moveToNode(selector:FlxObject,node:Node):Void
	{
		var i:Int;
		if (selectedUnits.length > 0 && node.isPassible() && (node.occupant == null || node.occupant.team.id != activeState.activeTeam.id))
		{
			for (i in 0...selectedUnits.length)
			{
				selectedUnits[i].dispatchEvent(AI.MOVE, new MoveEvent(node));
			}
		}
	}
	
	private function attackClick(selector:FlxObject,node:Node):Void
	{
		var i:Int;
		if (selectedUnits.length > 0 && node.isPassible() && node.occupant == null)
		{
			for (i in 0...selectedUnits.length)
			{
				selectedUnits[i].dispatchEvent(AI.ATTACK_NODE, new MoveEvent(node));
			}
		}
		else if (node.occupant != null && node.occupant.team.id != activeState.activeTeam.id)
		{
			for (i in 0...selectedUnits.length)
			{
				selectedUnits[i].dispatchEvent(AI.ATTACK_ACTOR, new AttackEvent(node.occupant));
			}
		}
	}
	
	private function attackOverlap(selector:FlxObject, unit:BaseActor):Void
	{
		var i:Int;
		for (i in 0...selectedUnits.length)
		{
			selectedUnits[i].dispatchEvent(AI.ATTACK_ACTOR, new AttackEvent(unit));
		}
	}
	
	private function clearSelected()
	{
		var i:Int;
		for (i in 0...selectedUnits.length)
		{
			selectedUnits[i].resetSelect();
		}
		for (i in 0...selectedBuildings.length)
		{
			//selectedBuildings[i].resetSelect();
		}
		selectedUnits = [];
		selectedBuildings = [];
		activeState.dashboard.clearDashBoard();
	}
	
	private function selectOverlapUnits(selector:FlxObject, unit:Unit):Void
	{
		if (newLeftClick)
		{
			clearSelected();
			activeState.dashboard.setSelected(unit);
		}
		activeState.dashboard.addSelectedActor(unit);
		selectedUnits.push(unit);
		unit.select();
		newLeftClick = false;
	}
	
	private function selectOverlapBuildings(selector:FlxObject, building:Building):Void
	{
		if (newLeftClick)
		{
			clearSelected();
			activeState.dashboard.setSelected(building);
		}
		activeState.dashboard.addSelectedActor(building);
		selectedBuildings.push(building);
		building.select();
		newLeftClick = false;
	}
	
	
	private function cameraUpdate()
	{
		var scrollX = FlxG.camera.scroll.x;
		var scrollY = FlxG.camera.scroll.y;
		if (FlxG.mouse.x - FlxG.camera.scroll.x > FlxG.camera.width - FlxG.camera.width/10)
		{
			FlxG.camera.scroll.x += 2;
		}
		else if (FlxG.mouse.x - FlxG.camera.scroll.x < FlxG.camera.width/10)
		{
			FlxG.camera.scroll.x -= 2;
		}
		
		if (FlxG.mouse.y - FlxG.camera.scroll.y > FlxG.camera.height - FlxG.camera.height/10)
		{
			FlxG.camera.scroll.y += 2;
		}
		else if (FlxG.mouse.y - FlxG.camera.scroll.y < FlxG.camera.width/10)
		{
			FlxG.camera.scroll.y -= 2;
		}
		
		if ((scrollX != FlxG.camera.scroll.x || scrollY != FlxG.camera.scroll.y) && FlxG.camera.scroll.y >= 0)
		{
			activeState.dashboard.adjustPos(FlxG.camera.scroll.x, FlxG.camera.scroll.y);
		}
	}
	
}