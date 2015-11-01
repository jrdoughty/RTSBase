package actors;

import flixel.FlxSprite;
import flixel.FlxG;
import haxe.Timer;
import interfaces.RTSGameState;
import systems.AStar;
import world.Node;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

/**
 * ...
 * @author John Doughty
 */

enum ActorState {
	MOVING;
	ATTACKING;
	IDLE;
	BUSY;
	CHASING;
}
 
 
class BaseActor extends FlxSprite
{

	public var currentNode:Node;
	public var targetNode:Node;
	public var targetEnemy:BaseActor;
	public var team:Int = 0;
	public var damage:Int = 1;
	
	private var selected:Bool = false;
	private var iterator:Int = 0;
	private var actionTimer:Timer;
	private var delayTimer:Timer;
	private var speed:Int = 250;
	private var state:ActorState = IDLE;
	private var healthMax:Int = 8;
	private var healthBar:FlxSprite;
	private var healthBarFill:FlxSprite;
	private	var path:Array<Node> = [];
	private var activeState:RTSGameState;
	
	public function new(node:Node, state:RTSGameState) 
	{
		activeState = state;
		super(node.x, node.y);
		node.occupant = this;
		currentNode = node;
		
		delayTimer = new Timer(Math.floor(1000*Math.random()));//Keeps mass created units from updating at the exact same time. Idea from: http://answers.unity3d.com/questions/419786/a-pathfinding-multiple-enemies-MOVING-target-effic.html
		delayTimer.run = delayedStart;
		health = 1;
		healthBar = new FlxSprite(x, y - 1);
		healthBar.makeGraphic(8, 1, FlxColor.BLACK);
		activeState.add(healthBar);
		healthBarFill = new FlxSprite(x, y - 1);
		healthBarFill.makeGraphic(8, 1, FlxColor.RED);
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
		healthBarFill.scale.set(health, 1);
		healthBarFill.updateHitbox();
	}
	
	private function takeAction()
	{
		if (state == IDLE)
		{
			idle();
		}
		else if (state == MOVING)
		{
			move();
		}
		else if (state == ATTACKING)
		{
			attack();
		}
		else if (state == CHASING)
		{
			chase();
		}
	}
	
	private function chase()
	{
		var nextMove:Node;
		var inRange:Bool = false;
		var i:Int;
		
		state = CHASING;
				
		state = ATTACKING;
		if (targetEnemy != null && targetEnemy.alive)
		{
			for (i in 0...currentNode.neighbors.length)
			{
				if (currentNode.neighbors[i].occupant == targetEnemy)
				{
					inRange = true;
					break;
				}
			}
			if (inRange)
			{
				attack();
			}
			else
			{
				if (targetEnemy.currentNode.isPassible())
				{
					path = AStar.newPath(currentNode, targetEnemy.currentNode);
				}
				
				if (path.length > 1 && path[path.length - 2].occupant == null)
				{
					path.splice(path.length - 1,1)[0].occupant = null;
					currentNode = path[path.length - 1];
					currentNode.occupant = this;
					FlxTween.tween(this, { x:currentNode.x, y:currentNode.y }, speed / 1000);
					FlxTween.tween(healthBar, { x:currentNode.x, y:currentNode.y - 1}, speed / 1000);
					FlxTween.tween(healthBarFill, { x:currentNode.x, y:currentNode.y - 1 }, speed / 1000);
					for (i in 0...currentNode.neighbors.length)
					{
						if (currentNode.neighbors[i].occupant == targetEnemy)
						{
							inRange = true;
							break;
						}
					}
					if (inRange)
					{
						path = [];
						state = ATTACKING;
					}
				}
			}
		}
		else
		{
			idle();
		}
	}
	
	private function attack()
	{
		var i:Int;
		var inRange:Bool = false;
		state = ATTACKING;
		if (targetEnemy != null && targetEnemy.alive)
		{
			for (i in 0...currentNode.neighbors.length)
			{
				if (currentNode.neighbors[i].occupant == targetEnemy)
				{
					inRange = true;
					break;
				}
			}
			if (inRange)
			{
				targetEnemy.hurt(damage / targetEnemy.healthMax);
			}
			else
			{
				chase();
			}
		}
		else if (targetNode != null)
		{
			
			move();
		}
		else
		{
			idle();
		}
	}
	
	private function idle()
	{
		state = IDLE;
		var i:Int;
		
		
		if (targetNode != null)
		{
			move();
		}
		else
		{
			for (i in 0...currentNode.neighbors.length)
			{
				if (currentNode.neighbors[i].occupant != null && currentNode.neighbors[i].occupant.team != team)
				{
					targetEnemy = currentNode.neighbors[i].occupant;
					attack();
					break;
				}
			}
		}
	}
	
	private function move():Void
	{
		var nextMove:Node;
		
		state = MOVING;
		
		if (targetNode != null && targetNode.isPassible() && path.length == 0)
		{
			path = AStar.newPath(currentNode, targetNode);
		}
		if (path.length > 1 && path[path.length - 2].occupant == null)
		{
			path.splice(path.length - 1,1)[0].occupant = null;
			currentNode = path[path.length - 1];
			currentNode.occupant = this;
			FlxTween.tween(this, { x:currentNode.x, y:currentNode.y }, speed / 1000);
			FlxTween.tween(healthBar, { x:currentNode.x, y:currentNode.y - 1}, speed / 1000);
			FlxTween.tween(healthBarFill, { x:currentNode.x, y:currentNode.y - 1 }, speed / 1000);
			if (currentNode == targetNode)
			{
				path = [];
				state = IDLE;//Unlike other cases, this is after the action has been carried out.
			}
		}
		else if (path.length > 1 && path[path.length - 2].occupant != null)
		{
			if (path[path.length - 2].occupant.team != team)
			{
				targetEnemy = path[path.length - 2].occupant;
				attack();
			}
			else
			{
				nextMove = path[path.length - 2];
				path = AStar.newPath(currentNode, targetNode);
				if (path.length > 1 && nextMove != path[path.length -2] )
				{
					move();//try new path					
				}
				else
				{
					path = [];
					targetNode = null;
				}
			}
		}
		else
		{
			targetNode = null;
			idle();
		}
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
		targetNode = null;
	}
	
	override public function kill()
	{
		super.kill();
		currentNode.occupant = null;
		actionTimer.stop();
		activeState.remove(healthBar);
		activeState.remove(healthBarFill);
		activeState.remove(this);
		destroy();
	}
}