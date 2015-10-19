package ;

import actors.BaseActor;
import actors.SwordSoldier;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import pathfinding.AStar;
import world.Node;
import world.SelfLoadingLevel;
import world.TiledTypes;
import openfl.Assets;

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
	
	override public function create():Void
	{
		super.create();
		add(getLevel());
		add(new SwordSoldier(getLevel().nodes[0]));	
		add(new SwordSoldier(getLevel().nodes[30]));		
	}
	
	public static function newPath(node:Node)
	{
		new AStar(selectedUnit.currentNode, node, getLevel().nodes, getLevel().width);
	}
	
	public static function getLevel():SelfLoadingLevel
	{
		if (activeLevel == null)
		{
			activeLevel = new SelfLoadingLevel(Assets.getText("assets/data/testlvl.json"));
		}
		
		return activeLevel;
	}
	
	public static function selectUnit(baseA:BaseActor):Void
	{
		if(selectedUnit != null)
		{
			trace("it was null");
			selectedUnit.resetSelect();
		}
		trace("running " + baseA);
		selectedUnit = baseA;

		if(selectedUnit != null)
		{
			trace("selecting");
			selectedUnit.select();
		}
	}

	public static function getSelectedUnit():BaseActor
	{
		return selectedUnit;
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
		super.update();
	}
}