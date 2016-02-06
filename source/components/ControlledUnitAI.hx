package components;
import world.Node;
import actors.Unit;
import systems.AStar;
import actors.ActorState;
import flixel.tweens.FlxTween;
import actors.BaseActor;

/**
 * ...
 * @author John Doughty
 */
class ControlledUnitAI extends AI
{
	public var targetNode(default, null):Node = null;
	public var targetEnemy:BaseActor = null;
	private var state:ActorState = IDLE;
	private	var path:Array<Node> = [];
	private var failedToMove:Bool = false;
	private var aggressive:Bool = false;
	private var lastTargetNode:Node;
	private var needsReset:Bool = false;
	
	public function new()
	{
		super();
		defaultName = "AI";
	}
	
	override public function init() 
	{
		super.init();
		entity.addEvent(AI.MOVE, MoveToNode);
		entity.addEvent(AI.ATTACK_NODE, AttackToNode);
		entity.addEvent(AI.ATTACK_ACTOR, AttackActor);
		entity.addEvent(AI.STOP, resetStates);
	}
	
	public function AttackActor(aEvent:AttackEvent)
	{
		resetStates();
		targetEnemy = aEvent.target;
	}
	
	public function MoveToNode(moveEvent:MoveEvent)//node:Node)
	{
		resetStates();
		targetNode = moveEvent.node;
	}
	
	public function AttackToNode(moveEvent:MoveEvent)
	{
		MoveToNode(moveEvent);
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
			path = AStar.newPath(entity.currentNodes[0], targetNode);//remember path[0] is the last 
		}
		
		if (path.length > 1 && path[1].occupant == null)
		{
			moveAlongPath();
			
			if (entity.currentNodes[0] == targetNode)
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
			entity.animation.pause();
		}
		else
		{
			entity.animation.play("active");
		}
	}
	
	@:extern inline private function newPath()
	{
		var nextMove = path[1];
		path = AStar.newPath(entity.currentNodes[0], targetNode);
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
					path = AStar.newPath(entity.currentNodes[0], targetNode);
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
			entity.animation.pause();
		}
		else
		{
			entity.animation.play("active");
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
		entity.animation.play("attack");
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
		entity.animation.frameIndex = entity.idleFrame;
		entity.animation.pause();
	}
	
	override function takeAction() 
	{
		super.takeAction();
		if (needsReset)
		{
			resetStates();
		}
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
	
	private function hit()
	{
		targetEnemy.hurt(entity.damage / targetEnemy.healthMax);
		if (targetEnemy.alive == false)
		{
			targetEnemy = null;
		}
	}
	
	public function resetStates(eO:EventObject = null):Void 
	{
		state = IDLE;
		targetEnemy = null;
		aggressive = false;
		targetNode = null;
	}
	
	@:extern inline function moveAlongPath()
	{
		path.splice(0,1)[0].occupant = null;
		entity.currentNodes[0] = path[0];
		entity.currentNodes[0].occupant = entity;
		FlxTween.tween(entity, { x:entity.currentNodes[0].x, y:entity.currentNodes[0].y }, entity.speed / 1000);
		//FlxTween.tween(healthBar, { x:entity.currentNodes[0].x, y:entity.currentNodes[0].y - 1}, entity.speed / 1000);
		//FlxTween.tween(healthBarFill, { x:entity.currentNodes[0].x, y:entity.currentNodes[0].y - 1 }, entity.speed / 1000);
	}
	
	private function isEnemyInRange():Bool
	{
		var i:Int;
		var inRange:Bool = false;
		
		for (i in 0...entity.currentNodes[0].neighbors.length)
		{
			if (entity.currentNodes[0].neighbors[i].occupant == targetEnemy && entity.currentNodes[0].neighbors[i].occupant != null || //if your target is close
			targetEnemy == null && entity.currentNodes[0].neighbors[i].occupant != null && entity.currentNodes[0].neighbors[i].occupant.team.id != entity.team.id) // if you are near an enemy with no target of your own
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
		for (i in 0...entity.currentNodes[0].neighbors.length)
		{
			if (entity.currentNodes[0].neighbors[i].occupant != null && entity.currentNodes[0].neighbors[i].occupant.team.id != entity.team.id)
			{
				result = entity.currentNodes[0].neighbors[i].occupant;
				break;
			}
		}
		return result;
	}
	
}