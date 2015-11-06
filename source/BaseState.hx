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
import interfaces.GameState;
import systems.AStar;
import systems.InputHandler;
import systems.Team;
import world.Node;
import world.SelfLoadingLevel;
import world.TiledTypes;
import openfl.Assets;
import flixel.plugin.MouseEventManager;
import actors.Unit;

/**
 * A FlxState which can be used for the actual gameplay.
 */


 
class BaseState extends FlxState implements GameState
{
	/**
	 * Function that is called up when to state is created to set it up.
	 */
	private var activeLevel:SelfLoadingLevel = null;
	private var levelAssetPath:String = "";
	
	public var Teams(default,null):Array<Team> = [];
	public var activeTeam(default,null):Team;
	
	private var inputHandler:InputHandler;
	
	override public function create():Void
	{
		super.create();
		add(getLevel());
		add(activeLevel.highlight);
		createTeams();
		setupUnitsInPlay();
		inputHandler = new InputHandler(this);
	}
	
	private function createTeams():Void
	{
		activeTeam = new Team();
		Teams.push(activeTeam);
	}
	
	private function setupUnitsInPlay():Void
	{
		var i:Int;
		var unitsInPlay:Array<Unit>;
		unitsInPlay = getUnitsInPlay();
		for (i in 0...unitsInPlay.length)
		{
			add(unitsInPlay[i]);
		}
	}
	
	public function getLevel():SelfLoadingLevel
	{
		if (activeLevel == null)
		{
			activeLevel = new SelfLoadingLevel(Assets.getText(levelAssetPath));
			AStar.setActiveLevel(activeLevel);
		}
		
		return activeLevel;
	}
	
	
	private function getUnitsInPlay():Array<Unit>
	{
		var i:Int;
		var result:Array<Unit> = [];
		
		for (i in 0...Teams.length)
		{
			result = result.concat(Teams[i].units);
		}
		
		return result;
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
	
		inputHandler.update();
	}
}