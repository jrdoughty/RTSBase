package actors;
import haxe.Constraints.Function;
import world.Node;
import interfaces.IGameState;
import systems.AStar;
import flixel.tweens.FlxTween;
import dashboard.Control;
import actors.BaseActor.ActorControlTypes;
import actors.BaseActor.ActorState;
import systems.Data;
import openfl.Assets;
/**
 * ...
 * @author ...
 */

 
class Unit extends BaseActor
{
		
	public var targetNode(default, null):Node;
	
	private var data:Dynamic;
	private var unitData:Dynamic;
	private	var path:Array<Node> = [];
	private var failedToMove:Bool = false;
	private var aggressive:Bool = false;
	private var unitControlTypes: Array<ActorControlTypes> = [ActorControlTypes.ATTACK,
		ActorControlTypes.STOP,
		ActorControlTypes.MOVE, 
		ActorControlTypes.PATROL, 
		ActorControlTypes.CAST, 
		ActorControlTypes.BUILD, 
		ActorControlTypes.HOLD];
	
	
	public function new(unitID:String, node:Node) 
	{
		var i:Int;
		data = systems.Data;//hack
		unitData = data.Actors.get(unitID);//supposedly Actors doesn't have get
		
		super(node);
		
		for (i in 0...3)
		{
			controls.push(new Control(i, unitControlTypes[i]));
		}
		
		healthMax = unitData.health;
		speed = unitData.speed;
		damage = unitData.damage;
	}
	
	override function setupGraphics() 
	{
		var assetPath:String = "assets" + unitData.spriteFile.substr(2);
		super.setupGraphics();
		
		loadGraphic(assetPath, true, 8, 8);
		animation.add("active", [0, 1], 5, true);
		animation.add("attack", [0, 2], 5, true);
		idleFrame = 0;
	}
	
	public function MoveToNode(node:Node)
	{
		resetStates();
		targetNode = node;
	}
	
	public function AttackToNode(node:Node)
	{
		MoveToNode(node);
		aggressive = true;
	}
	
	private function move():Void
	{
		var nextMove:Node;
		failedToMove = false;
		state = MOVING;
		
		if (aggressive && isEnemyInRange())
		{
			targetEnemy = getEnemyInRange();
			attack();
			return;
		}
		
		if ((targetNode != null && path.length == 0|| targetNode != lastTargetNode) && targetNode.isPassible())
		{
			path = AStar.newPath(currentNodes[0], targetNode);//remember path[0] is the last 
		}
		
		if (path.length > 1 && path[1].occupant == null)
		{
			moveAlongPath();
			
			if (currentNodes[0] == targetNode)
			{
				path = [];
				state = IDLE;//Unlike other cases, this is after the action has been carried out.
			}
		}
		else if (path.length > 1 && path[1].occupant != null)
		{
			newPath();
		}
		else
		{
			targetNode = null;
			state = IDLE;
		}
		lastTargetNode = targetNode;
		if (failedToMove)
		{
			animation.pause();
		}
		else
		{
			animation.play("active");
		}
	}
	
	@:extern inline private function newPath()
	{
		var nextMove = path[1];
		path = AStar.newPath(currentNodes[0], targetNode);
		if (path.length > 1 && nextMove != path[1])//In Plain english, if the new path is indeed a new path
		{
			if (state == ActorState.MOVING)
			{
				move();//try new path	
			} 
			else if (state == ActorState.CHASING)
			{
				chase();
			}
		}
		else
		{
			failedToMove = true;
		}
	}
	
	
	private function chase()
	{
		var nextMove:Node;
		var i:Int;
		failedToMove = false;
		
		state = CHASING;
		
		if (targetEnemy != null && targetEnemy.alive)
		{
			
			if (isEnemyInRange())
			{
				attack();
			}
			else
			{
				targetNode = targetEnemy.currentNodes[0];
				
				if (path.length == 0 || path[path.length - 1] != targetNode)
				{
					path = AStar.newPath(currentNodes[0], targetNode);
				}
				
				
				if (path.length > 1 && path[1].occupant == null)
				{
					moveAlongPath();
				}
				else
				{
					newPath();
				}
			}
		}
		else
		{
			state = IDLE;
		}
		if (failedToMove)
		{
			animation.pause();
		}
		else
		{
			animation.play("active");
		}
	}
	
	private function attack()
	{
		var i:Int;
		state = ATTACKING;
		if (targetEnemy != null && targetEnemy.alive)
		{
			if (isEnemyInRange())
			{
				hit();
			}
			else
			{
				chase();
			}
		}
		else
		{
			state = IDLE;
		}
		animation.play("attack");
	}
	
	private function idle()
	{
		state = IDLE;
		var i:Int;
		
		if (targetNode != null)
		{
			move();
		}
		else if (targetEnemy != null)
		{
			attack();
		}
		else if (isEnemyInRange())
		{
			targetEnemy = getEnemyInRange();
			attack();
		}
		animation.frameIndex = idleFrame;
		animation.pause();
	}
	
	override function takeAction() 
	{
		super.takeAction();
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
	
	override public function resetStates():Void 
	{
		super.resetStates();
		aggressive = false;
		targetNode = null;
	}
	
	@:extern inline function moveAlongPath()
	{
		path.splice(0,1)[0].occupant = null;
		currentNodes[0] = path[0];
		currentNodes[0].occupant = this;
		FlxTween.tween(this, { x:currentNodes[0].x, y:currentNodes[0].y }, speed / 1000);
		FlxTween.tween(healthBar, { x:currentNodes[0].x, y:currentNodes[0].y - 1}, speed / 1000);
		FlxTween.tween(healthBarFill, { x:currentNodes[0].x, y:currentNodes[0].y - 1 }, speed / 1000);
	}
	
	private function isEnemyInRange():Bool
	{
		var i:Int;
		var inRange:Bool = false;
		
		for (i in 0...currentNodes[0].neighbors.length)
		{
			if (currentNodes[0].neighbors[i].occupant == targetEnemy && currentNodes[0].neighbors[i].occupant != null || //if your target is close
			targetEnemy == null && currentNodes[0].neighbors[i].occupant != null && currentNodes[0].neighbors[i].occupant.team != team) // if you are near an enemy with no target of your own
			{
				inRange = true;
				break;
			}
		}
		
		return inRange;
	}
	
	private function getEnemyInRange():BaseActor
	{
		var result:BaseActor = null;
		var i:Int;
		for (i in 0...currentNodes[0].neighbors.length)
		{
			if (currentNodes[0].neighbors[i].occupant != null && currentNodes[0].neighbors[i].occupant.team != team)
			{
				result = currentNodes[0].neighbors[i].occupant;
				break;
			}
		}
		return result;
	}
}