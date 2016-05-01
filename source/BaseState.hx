package ;

import actors.BaseActor;
import dashboard.Dashboard;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import flixel.FlxState;
import interfaces.IGameState;
import systems.AStar;
import systems.InputSystem;
import systems.Team;
import world.Node;
import world.SelfLoadingLevel;
import world.TiledTypes;
import openfl.Assets;
import flixel.input.mouse.FlxMouseEventManager;
import actors.DBActor;
import openfl.geom.Point;
import events.ClearFogEvent;

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
	
	private var inputHandler:InputSystem;
	private var activeLevel:SelfLoadingLevel = null;
	private var levelAssetPath:String = "";
	private var positions:Array<Array<Int>> = [];
	private var fogRedrawFrame:Int = 2;
	private var frame:Int = 0;
	//private var dashCam:FlxCamera;
	
	override public function create():Void
	{
		super.create();
		add(getLevel());
		add(activeLevel.highlight);
		createTeams();
		inputHandler = new InputSystem(this);
		setupDashboard();
		setupCameras();
	}
	
	private function setupCameras()
	{
		var level = getLevel();
		//FlxG.camera.setBounds(0, 0, level.width * level.tiledLevel.tilewidth, level.height * level.tiledLevel.tileheight);
		/*
		#if flash
		dashCam = new FlxCamera(0, 684, 320, 56);
		#else
		dashCam = new FlxCamera(0, 370, 320, 56);
		#end
		dashCam.scroll.x = dashboard.background.x;
		FlxG.cameras.add(dashCam);*/
	}
	
	private function setupDashboard()
	{
		dashboard = new Dashboard( inputHandler);
		add(dashboard);
	}
	
	private function createTeams():Void
	{
		activeTeam = new Team();
		Teams.push(activeTeam);
	}
	
	public function getLevel():SelfLoadingLevel
	{
		if (activeLevel == null)
		{
			activeLevel = new SelfLoadingLevel(Assets.getText(levelAssetPath));
		}
		
		return activeLevel;
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
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		var newPositions:Array<Array<Int>> = [];
		inputHandler.update();
		
		for (actor in activeTeam.units)
		{
			newPositions.push([actor.currentNodes[0].nodeX, actor.currentNodes[0].nodeY]);
		}
		
		if (positions.toString() != newPositions.toString())// fast units mess this up && frame % fogRedrawFrame == 0)//this is currently a heavy load, so we are making it happen once in a few frames
		{
			for (node in Node.activeNodes)
			{
				node.addOverlay();
			}
			for (actor in activeTeam.units)
			{
				//if (actor.alive)
				//{
					actor.dispatchEvent(ClearFogEvent.CLEAR, new ClearFogEvent());
				//}
			}
			for (actor in activeTeam.buildings)
			{
				//if (actor.alive)
				//{
					actor.dispatchEvent(ClearFogEvent.CLEAR, new ClearFogEvent());
				//}
			}
			getLevel().rebuildFog();
		}
		for (team in Teams)
		{
			team.update();
		}
		positions = newPositions;
		frame++;
	}
}