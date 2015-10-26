package ;

import actors.BaseActor;
import actors.SpearSoldier;
import actors.SwordSoldier;
import flixel.FlxG;
import flixel.FlxObject;
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
	
	
	
	override public function create():Void
	{
		var i:Int;
		
		super.create();
		add(getLevel());
		add(activeLevel.highlight);
		for (i in 0...Node.activeNodes.length)
		{
			MouseEventManager.add(Node.activeNodes[i], onClick, null, onOver, null);
		}
		add(new SwordSoldier(Node.activeNodes[0]));	
		add(new SwordSoldier(Node.activeNodes[30]));
		add(new SpearSoldier(Node.activeNodes[380]));
		add(new SpearSoldier(Node.activeNodes[399]));		
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
		
		if (selectedUnit != null && sprite.isPassible() && sprite.occupant == null)
		{
			setOnPath(sprite);
		}
		else if (sprite.occupant != null)
		{
			selectUnit(sprite.occupant);
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
		super.update();
	}
}