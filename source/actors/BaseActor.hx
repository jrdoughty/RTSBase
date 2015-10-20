package actors;

import flixel.FlxSprite;
import flixel.FlxG;
import haxe.Timer;
import pathfinding.AStar;
import world.Node;
import flixel.tweens.FlxTween;

/**
 * ...
 * @author John Doughty
 */
class BaseActor extends FlxSprite
{

	private var selected:Bool = false;
	private var iterator:Int = 0;
	private var actionTimer:Timer;
	private var delayTimer:Timer;
	public var targetNode:Node;
	public var currentNode:Node;
	private var speed:Int = 250;
	private var moving:Bool = false;
	
	public function new(node:Node) 
	{
		super(node.x, node.y);
		node.occupant = this;
		currentNode = node;
		
		delayTimer = new Timer(Math.floor(1000*Math.random()));//Keeps mass created units from updating at the exact same time. Idea from: http://answers.unity3d.com/questions/419786/a-pathfinding-multiple-enemies-moving-target-effic.html
		delayTimer.run = delayedStart;
	}
	
	private function delayedStart()
	{
		delayTimer.stop();
		actionTimer = new Timer(speed);
		actionTimer.run = takeAction;
	}
	
	private function takeAction()
	{
		var path:Array<Node> = [];
		if (targetNode != null && targetNode.isPassible())
		{
			path = AStar.newPath(currentNode, targetNode);
		}
		if (path.length > 1 && path[path.length - 2].occupant == null)
		{
			currentNode.occupant = null;
			currentNode = path[path.length - 2];
			currentNode.occupant = this;
			FlxTween.tween(this, { x:currentNode.x, y:currentNode.y }, speed / 1000);
			moving = true;
		}
		else if (path.length > 1 && path[path.length - 2].occupant != null)
		{
			moving = false;
		}
		else
		{
			targetNode = null;
			moving = false;
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
	
}