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
	public var nodes:Array<Node> = [];
	private var selectedNode:Node;
	
	public var width:Int;
	public var height:Int;
	
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
		var pass:Bool = false;
		
		tiledLevel = Json.parse(json);
		
		width = tiledLevel.width;
		height = tiledLevel.height;
		
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
			x = i % width;
			y = Math.floor(i / width);
			pass = tiledLevel.layers[1].data[i] == 0;
			nodes.push(new Node(asset, frame,tiledLevel.tilewidth,tiledLevel.tileheight, x, y,pass));
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