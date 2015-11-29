package actors;
import haxe.Constraints.Function;
import world.Node;
import interfaces.IGameState;
import systems.AStar;
import flixel.tweens.FlxTween;
import dashboard.Control;
import actors.BaseActor.ActorControlTypes;
import actors.BaseActor.ActorState;
/**
 * ...
 * @author ...
 */

 
class Unit extends BaseActor
{
		
	public var targetNode(default,null):Node;
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
	
	
	public function new(node:Node, state:IGameState) 
	{
		var i:Int;
		super(node, state);
		for (i in 0...3)
		{
			controls.push(new Control(i, unitControlTypes[i]));
		}
		
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
		
		if (path.length > 1 && path[path.length - 2].occupant == null)
		{
			moveAlongPath();
			
			if (currentNodes[0] == targetNode)
			{
				path = [];
				state = IDLE;//Unlike other cases, this is after the action has been carried out.
			}
		}
		else if (path.length > 1 && path[path.length - 2].occupant != null)
		{
			newPath();
		}
		else
		{
			targetNode = null;
			state = IDLE;
		}
		lastTargetNode = targetNode;
	}
	
	@:extern inline private function newPath()
	{
		var nextMove = path[path.length - 2];
		path = AStar.newPath(currentNodes[0], targetNode);
		if (path.length > 1 && nextMove != path[path.length -2])//In Plain english, if the new path is indeed a new path
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
				
				if (path.length == 0 || path[0] != targetNode)
				{
					path = AStar.newPath(currentNodes[0], targetNode);
				}
				
				
				if (path.length > 1 && path[path.length - 2].occupant == null)
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
	}
	
	private function isEnemyInRange():Bool
	{
		var i:Int;
		var inRange:Bool = false;
		
		for (i in 0...currentNodes[0].neighbors.length)
		{
			if (currentNodes[0].neighbors[i].occupant == targetEnemy)
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
		path.splice(path.length - 1,1)[0].occupant = null;
		currentNodes[0] = path[path.length - 1];
		currentNodes[0].occupant = this;
		FlxTween.tween(this, { x:currentNodes[0].x, y:currentNodes[0].y }, speed / 1000);
		FlxTween.tween(healthBar, { x:currentNodes[0].x, y:currentNodes[0].y - 1}, speed / 1000);
		FlxTween.tween(healthBarFill, { x:currentNodes[0].x, y:currentNodes[0].y - 1 }, speed / 1000);
	}
}