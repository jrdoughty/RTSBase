package actors;
import haxe.Constraints.Function;
import world.Node;
import interfaces.IGameState;
import systems.AStar;
import flixel.tweens.FlxTween;
import dashboard.Control;
import actors.BaseActor.ActorControlTypes;
/**
 * ...
 * @author ...
 */

 
class Unit extends BaseActor
{
		
	private	var path:Array<Node> = [];
	public var targetNode:Node;
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
	
	private function move():Void
	{
		var nextMove:Node;
		
		state = MOVING;
		
		if ((targetNode != null && path.length == 0|| targetNode != lastTargetNode) && targetNode.isPassible())
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
					/*we wait for now
					path = [];
					targetNode = null;
					*/
				}
			}
		}
		else
		{
			targetNode = null;
			state = IDLE;
		}
		lastTargetNode = targetNode;
	}
	
	
	private function chase()
	{
		var nextMove:Node;
		var inRange:Bool = false;
		var i:Int;
		
		state = CHASING;
		
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
			state = IDLE;
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
				if (targetEnemy.alive == false)
				{
					targetEnemy = null;
				}
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
			state = IDLE;
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
		else if (targetEnemy != null)
		{
			attack();
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
		targetNode = null;
	}
}