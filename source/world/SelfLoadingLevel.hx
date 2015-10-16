package world;

import flixel.group.FlxGroup;
import haxe.Json;
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
		var i:Int = 0;
		var tileSetId:Int = 0;
		var j:Int = 0;
		
		var asset:String = "";
		var frame:Int = 0;
		var x:Int = 0;
		var y:Int = 0;
		
		tiledLevel = Json.parse(json);
		
		for (i in 0...tiledLevel.layers[0].data.length)
		{
			tileSetId = 0;
			for (j in 0...(tiledLevel.tilesets.length-1))
			{
				if (tiledLevel.layers[0].data[i] > tiledLevel.tilesets[j + 1].firstgid)
				{
					tileSetId += 1;
				}
			}
			asset = "assets/" + tiledLevel.tilesets[tileSetId].image.substring(3);
			frame = tiledLevel.layers[0].data[i] - tiledLevel.tilesets[tileSetId].firstgid;
			x = i % tiledLevel.width * tiledLevel.tilewidth;
			y = Math.floor(i / tiledLevel.width) * tiledLevel.tileheight;
			nodes.push(new Node(asset, frame,tiledLevel.tilewidth,tiledLevel.tileheight, x, y));
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