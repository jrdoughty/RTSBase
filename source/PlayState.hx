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
import interfaces.RTSGameState;
import systems.AStar;
import systems.InputHandler;
import systems.Team;
import world.Node;
import world.SelfLoadingLevel;
import world.TiledTypes;
import openfl.Assets;
import flixel.plugin.MouseEventManager;

/**
 * A FlxState which can be used for the actual gameplay.
 */


 
class PlayState extends FlxState implements RTSGameState
{
	/**
	 * Function that is called up when to state is created to set it up.
	 */
	private var activeLevel:SelfLoadingLevel = null;
	
	public static var Teams(default,null):Array<Team> = [];
	public static var activeTeam(default,null):Team;
	
	private var inputHandler:InputHandler;
	
	override public function create():Void
	{
		var i:Int;
		var unitsInPlay:Array<BaseActor>;
		super.create();
		add(getLevel());
		add(activeLevel.highlight);
		activeTeam = new Team();
		Teams.push(activeTeam);
		Teams.push(new Team());
		Teams[0].addUnit(new SwordSoldier(Node.activeNodes[0],this));
		Teams[0].addUnit(new SwordSoldier(Node.activeNodes[50],this));
		Teams[1].addUnit(new SpearSoldier(Node.activeNodes[616],this));
		Teams[1].addUnit(new SpearSoldier(Node.activeNodes[499],this));	
		unitsInPlay = getUnitsInPlay();
		for (i in 0...unitsInPlay.length)
		{
			add(unitsInPlay[i]);
		}
		inputHandler = new InputHandler(this);
	}
	
	public function getLevel():SelfLoadingLevel
	{
		if (activeLevel == null)
		{
			activeLevel = new SelfLoadingLevel(Assets.getText("assets/data/moreopen.json"));
		}
		
		return activeLevel;
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