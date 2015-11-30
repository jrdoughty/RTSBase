package ;

import actors.BaseActor;
import actors.Devil;
import actors.Soldier;
import dashboard.Dashboard;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import interfaces.IGameState;
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


 
class BaseState extends FlxState implements IGameState
{
	/**
	 * Function that is called up when to state is created to set it up.
	 */
	public var dashboard:Dashboard;
	public var Teams(default,null):Array<Team> = [];
	public var activeTeam(default,null):Team;
	
	private var inputHandler:InputHandler;
	private var activeLevel:SelfLoadingLevel = null;
	private var levelAssetPath:String = "";
	
	override public function create():Void
	{
		super.create();
		add(getLevel());
		add(activeLevel.highlight);
		createTeams();
		setupUnitsInPlay();
		inputHandler = new InputHandler(this);
		dashboard = new Dashboard(0, 184, inputHandler);
		add(dashboard);
	}
	
	private function createTeams():Void
	{
		activeTeam = new Team();
		Teams.push(activeTeam);
	}
	
	private function setupUnitsInPlay():Void
	{
		var i:Int;
		var actorsInPlay:Array<BaseActor>;
		actorsInPlay = getUnitsInPlay();
		for (i in 0...actorsInPlay.length)
		{
			add(actorsInPlay[i]);
		}
	}
	
	public function getLevel():SelfLoadingLevel
	{
		if (activeLevel == null)
		{
			activeLevel = new SelfLoadingLevel(Assets.getText(levelAssetPath));
		}
		
		return activeLevel;
	}
	
	
	private function getUnitsInPlay():Array<BaseActor>
	{
		var i:Int;
		var j:Int;
		var result:Array<BaseActor> = [];
		
		for (i in 0...Teams.length)
		{
			for (j in 0...Teams[i].units.length)
			{
				result.push(Teams[i].units[j]);
			}
			for (j in 0...Teams[i].buildings.length)
			{
				result.push(Teams[i].buildings[j]);
			}
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