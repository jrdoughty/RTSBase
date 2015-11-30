package actors;

import flixel.FlxSprite;
import flixel.FlxG;
import haxe.Timer;
import interfaces.IGameState;
import systems.AStar;
import world.Node;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import dashboard.Control;

/**
 * ...
 * @author John Doughty
 */

enum ActorState 
{
	MOVING;
	ATTACKING;
	IDLE;
	BUSY;
	CHASING;
}

enum ActorControlTypes 
{
	ATTACK;
	STOP;
	MOVE;
	PATROL;
	CAST;
	BUILD;
	HOLD;
}
 
 
class BaseActor extends FlxSprite
{

	public var currentNodes:Array<Node> = [];
	public var targetEnemy:BaseActor;
	public var team:Int = 0;
	public var damage:Int = 1;
	public var controls:Array<Control> = [];
	public var idleFrame:Int = 0;
	
	private var lastTargetNode:Node;
	private var selected:Bool = false;
	private var actionTimer:Timer;
	private var delayTimer:Timer;
	private var speed:Int = 250;
	private var state:ActorState = IDLE;
	private var healthMax:Int = 8;
	private var healthBar:FlxSprite;
	private var healthBarFill:FlxSprite;
	private var activeState:IGameState;
	
	public function new(node:Node, state:IGameState) 
	{
		activeState = state;
		super(node.x, node.y);
		
		delayTimer = new Timer(Math.floor(1000*Math.random()));//Keeps mass created units from updating at the exact same time. Idea from: http://answers.unity3d.com/questions/419786/a-pathfinding-multiple-enemies-MOVING-target-effic.html
		delayTimer.run = delayedStart;
		setupGraphics();
		setupNodes(node);
		createHealthBar();
	}
	
	private function setupNodes(node:Node)
	{
		node.occupant = this;
		currentNodes[0] = node;
	}
	
	private function setupGraphics()
	{
		
	}
	
	private function createHealthBar()
	{
		health = 1;
		healthBar = new FlxSprite(x, y - 1);
		healthBar.makeGraphic(Std.int(width), 1, FlxColor.BLACK);
		activeState.add(healthBar);
		healthBarFill = new FlxSprite(x, y - 1);
		healthBarFill.makeGraphic(Std.int(width), 1, FlxColor.RED);
		activeState.add(healthBarFill);		
	}
	private function delayedStart()
	{
		delayTimer.stop();
		actionTimer = new Timer(speed);
		actionTimer.run = takeAction;
	}
	
	override public function update()
	{
		super.update();
		if (healthBarFill != null)
		{
			healthBarFill.scale.set(health, 1);
			healthBarFill.updateHitbox();
		}
	}
	
	private function takeAction()
	{


	}
	
	public function select():Void
	{
		color = 0x99ff66;
		selected = true;
	}
	
	public function resetSelect():Void
	{
		selected = false;
		color = 0xffffff;
	}
	
	public function resetStates():Void
	{
		state = IDLE;
		targetEnemy = null;
	}
	
	override public function kill()
	{
		super.kill();
		resetStates();
		currentNodes[0].occupant = null;
		actionTimer.stop();
		activeState.remove(healthBar);
		activeState.remove(healthBarFill);
		activeState.remove(this);
		destroy();
	}
	
	private function hit()
	{
		targetEnemy.hurt(damage / targetEnemy.healthMax);
		if (targetEnemy.alive == false)
		{
			targetEnemy = null;
		}
	}
}