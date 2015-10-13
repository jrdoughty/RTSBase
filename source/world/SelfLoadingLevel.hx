package world;

import flixel.group.FlxGroup;
import haxe.Json;
import haxe.Resource;
import world.TiledTypes.TiledLevel;
import openfl.Assets;


/**
 * ...
 * @author John Doughty
 */
class SelfLoadingLevel extends FlxGroup
{
	private var tiledLevel:TiledLevel;
	private var nodes:Array<Node> = [];
	private var selectedNode:Node;
	public function new(json:String) 
	{
		super();
		tiledLevel = Json.parse(json);
		var i:Int = 0;
		
		for (i in 0...tiledLevel.layers[0].data.length)
		{
			nodes.push(new Node(tiledLevel.layers[0].data[i]-1,i % tiledLevel.width * 16, Math.floor(i / tiledLevel.width) * 16));
			add(nodes[i]);
		}
	}
	
	public function setSelectedNode(node:Node):Void
	{
		var i:Int = 0;
		for (i in 0...nodes.length)
		{
			nodes[i].resetState();
		}
		selectedNode = node;
		
	}
	
}