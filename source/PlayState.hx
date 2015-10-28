package ;

import actors.BaseActor;
import actors.SpearSoldier;
import actors.SwordSoldier;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import systems.AStar;
import systems.Team;
import world.Node;
import world.SelfLoadingLevel;
import world.TiledTypes;
import openfl.Assets;
import flixel.plugin.MouseEventManager;

/**
 * A FlxState which can be used for the actual gameplay.
 */


 
class PlayState extends FlxState
{
	/**
	 * Function that is called up when to state is created to set it up.
	 */
	private static var activeLevel:SelfLoadingLevel = null;
	private static var selectedUnit:BaseActor = null;
	private static var selectedUnits:Array<BaseActor> = [];
	
	private var selector:FlxSprite;
	private var Teams:Array<Team> = [];
	private var activeTeam:Team;
	private var wasLeftMouseDown:Bool = false;
	private var flxTeamUnits:FlxGroup = new FlxGroup();
	private var flxNodes:FlxGroup = new FlxGroup();
	
	
	override public function create():Void
	{
		var i:Int;
		var unitsInPlay:Array<BaseActor>;
		super.create();
		add(getLevel());
		add(activeLevel.highlight);
		selector = new FlxSprite(-1,-1);
		selector.makeGraphic(1, 1, FlxColor.WHITE);
		for (i in 0...Node.activeNodes.length)
		{
			flxNodes.add(Node.activeNodes[i]);
			MouseEventManager.add(Node.activeNodes[i], onClick, removeSelector, onOver);
		}
		activeTeam = new Team();
		Teams.push(activeTeam);
		Teams.push(new Team());
		Teams[0].addUnit(new SwordSoldier(Node.activeNodes[0]));
		Teams[0].addUnit(new SwordSoldier(Node.activeNodes[30]));
		Teams[1].addUnit(new SpearSoldier(Node.activeNodes[380]));
		Teams[1].addUnit(new SpearSoldier(Node.activeNodes[399]));	
		unitsInPlay = getUnitsInPlay();
		for (i in 0...unitsInPlay.length)
		{
			add(unitsInPlay[i]);
		}
		trace(unitsInPlay.length);
		for (i in 0...Teams.length)
		{
			flxTeamUnits.add(Teams[i].flxUnits);
		}
	}
	
	public static function setOnPath(node:Node)
	{
		if (selectedUnit != null)
		{
			selectedUnit.targetNode = node;
		}
	}
	
	public static function getLevel():SelfLoadingLevel
	{
		if (activeLevel == null)
		{
			activeLevel = new SelfLoadingLevel(Assets.getText("assets/data/moreopen.json"));
		}
		
		return activeLevel;
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
	
	
	private function onOver(sprite:Node):Void
	{
		getLevel().highlight.x = sprite.x;
		getLevel().highlight.y = sprite.y;
	}
	
	private function onClick(sprite:Node):Void
	{
		add(selector);
		selector.alpha = .5;
		selector.x = FlxG.mouse.x;
		selector.y = FlxG.mouse.y;
		selector.setGraphicSize(1, 1);
		selector.updateHitbox();
		if (selectedUnit != null && sprite.isPassible() && sprite.occupant == null)
		{
			setOnPath(sprite);
		}
		else if (sprite.occupant != null)
		{
			selectUnit(sprite.occupant);
		}
	}
	
	private function getUnitsInPlay():Array<BaseActor>
	{
		var i:Int;
		var result:Array<BaseActor> = [];
		
		for (i in 0...Teams.length)
		{
			result = result.concat(Teams[i].units);
		}
		
		return result;
	}
	
	private function removeSelector(sprite:FlxSprite)
	{
		remove(selector);
	}
	
	private function selectOverlap(selector:FlxObject, unit:BaseActor):Void
	{
		if (unit.team == activeTeam.id)
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
	
	/**
	 * Function that is called when this state is destroyed - you might want to
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		var i:Int;
		if (FlxG.mouse.pressed)
		{
			if (wasLeftMouseDown)
			{
				selector.setGraphicSize(Math.floor(FlxG.mouse.x - selector.x), Math.floor(FlxG.mouse.y - selector.y));
				selector.updateHitbox();
			}
			wasLeftMouseDown = true;
		}
		else
		{
			if (wasLeftMouseDown)
			{
				deselectUnits();
				selectedUnits = [];
				FlxG.overlap(selector, flxTeamUnits, selectOverlap);
			}
			wasLeftMouseDown = false;
		}
		super.update();
	}
}