package world;

import flixel.FlxSprite;
import flixel.group.FlxGroup;
import haxe.Json;
import world.TiledTypes.Layer;
import world.TiledTypes.TiledLevel;
import openfl.Assets;


/**
 * ...
 * @author John Doughty
 */
class SelfLoadingLevel extends FlxGroup
{
	//public var nodes:Array<Node> = [];
	public var width:Int;
	public var height:Int;
	public var highlight:FlxSprite;
	
	public var tiledLevel(default,null):TiledLevel;
	
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
		var pass:Bool = false;
		
		var graphicLayer:Layer = null;
		var collisionLayer:Layer = null;
		
		tiledLevel = Json.parse(json);
		
		width = tiledLevel.width;
		height = tiledLevel.height;
		
		for (i in 0...tiledLevel.layers.length)
		{
			if (tiledLevel.layers[i].name == "graphic")
			{
				graphicLayer = tiledLevel.layers[i];
			}
			else if (tiledLevel.layers[i].name == "collision")
			{
				collisionLayer = tiledLevel.layers[i];
			}
			if (graphicLayer != null && collisionLayer != null)
			{
				for (i in 0...graphicLayer.data.length)
				{
					tileSetId = 0;
					for (j in 0...(tiledLevel.tilesets.length-1))
					{
						if (graphicLayer.data[i] > tiledLevel.tilesets[j + 1].firstgid)
						{
							tileSetId += 1;
						}
					}
					asset = "assets/" + tiledLevel.tilesets[tileSetId].image.substring(3);
					frame = graphicLayer.data[i] - tiledLevel.tilesets[tileSetId].firstgid;
					x = i % width;
					y = Math.floor(i / width);
					pass = collisionLayer.data[i] == 0;
					Node.activeNodes.push(new Node(asset, frame,tiledLevel.tilewidth,tiledLevel.tileheight, x, y, pass));
					add(Node.activeNodes[i]);
				}
				break;
			}
			for (i in 0...tiledLevel.tilesets.length)
			{
				if (tiledLevel.tilesets[i].name == "highlight")
				{
					highlight = new FlxSprite(0, 0).loadGraphic("assets/"+tiledLevel.tilesets[i].image.substring(3), true, tiledLevel.tilewidth, tiledLevel.tileheight);
					highlight.animation.add("main", [0, 1, 2, 3, 4, 5, 6], 24);//has to be better way
					highlight.animation.play("main");
				}
			}
		}
		
		
	}	
}