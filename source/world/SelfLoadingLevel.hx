package world;

import flixel.FlxSprite;
import haxe.Json;
import world.TiledTypes.Layer;
import world.TiledTypes.TiledLevel;
import flixel.FlxG;
import openfl.Assets;
import openfl.geom.Rectangle;
import openfl.geom.Point;
import openfl.display.BitmapData;
import adapters.TwoDSprite;
import flixel.util.FlxSpriteUtil;
import flash.geom.ColorTransform;
import flash.display.BitmapDataChannel;

/**
 * ...
 * @author John Doughty
 */
class SelfLoadingLevel 
{
	//public var nodes:Array<Node> = [];
	public var width:Int;
	public var height:Int;
	public var highlight:TwoDSprite;
	
	public var tiledLevel(default,null):TiledLevel;
	
	private var background:TwoDSprite;
	private var fog:TwoDSprite;
	private var selectedNode:Node;
	
	public function new(json:String) 
	{
		var i:Int = 0;
		var j:Int = 0;
		var tileSetId:Int = 0;
		
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
		background = new TwoDSprite();
		background.pixels = new BitmapData(Std.int(width * tiledLevel.tilewidth), height * tiledLevel.tileheight, true, 0xFFFFFF);
		FlxG.state.add(background);
		fog = new TwoDSprite();
		fog.pixels = new BitmapData(Std.int(width * tiledLevel.tilewidth), height * tiledLevel.tileheight, true, 0xFFFFFF);
		FlxG.state.add(fog);
		fog.setAlpha(.5);
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
					
					var sourceRect:Rectangle = new Rectangle(0, 0, Node.activeNodes[i].width, Node.activeNodes[i].height);
					var destPoint:Point = new Point(Std.int(Node.activeNodes[i].x), Node.activeNodes[i].y);
					if (frame == 7)
					{
						true;
					}
					background.pixels.copyPixels(Node.activeNodes[i].updateFramePixels(), sourceRect, destPoint, null, null, true);
					background.dirty = true;
				}
				Node.createNeighbors(width, height);
				break;
			}
			for (i in 0...tiledLevel.tilesets.length)
			{
				if (tiledLevel.tilesets[i].name == "highlight")
				{
					highlight = new TwoDSprite(0, 0, "assets/"+tiledLevel.tilesets[i].image.substring(3), tiledLevel.tilewidth, tiledLevel.tileheight);
					highlight.addAnimation("main", [0, 1, 2, 3, 4, 5, 6], 24);//has to be better way
					highlight.playAnimation("main");
				}
			}
		}
	}
	var mainMask = new FlxSprite();
	public function rebuildFog()
	{
		var i;
		var mask:FlxSprite = new FlxSprite();
		//mask.loadGraphic("assets/images/textures.png", true, 8, 8);
		//mask.animation.frameIndex = 4;
		//FlxG.state.add(mask);
		//mask.addAnimation("main", [4], 24);//has to be better way
		//mask.playAnimation("main");
		
		fog.pixels = new BitmapData(Std.int(width * tiledLevel.tilewidth), height * tiledLevel.tileheight, false, 0x000000);
		
		for (i in 0...Node.activeNodes.length)
		{
			if (Node.activeNodes[i].occupant != null)
			{
				mask.loadGraphicFromSprite(mainMask);
				FlxSpriteUtil.drawCircle(mask, Node.activeNodes[i].getMidpoint().x, Node.activeNodes[i].getMidpoint().y, 8, 0xFFFFFF);
				invertedAlphaMaskFlxSprite(fog, mask, mainMask);
			}
		}
		fog.dirty = true;
		
	}
	
	function invertedAlphaMaskFlxSprite(sprite:FlxSprite, mask:FlxSprite, output:FlxSprite):FlxSprite
	{
		// Solution based on the discussion here:
		// https://groups.google.com/forum/#!topic/haxeflixel/fq7_Y6X2ngY
 
		// NOTE: The code below is the same as FlxSpriteUtil.alphaMaskFlxSprite(),
		// except it has an EXTRA section below.
 
		sprite.drawFrame();
		var data:BitmapData = sprite.pixels.clone();
		data.copyChannel(mask.pixels, new Rectangle(0, 0, sprite.width, sprite.height), new Point(), BitmapDataChannel.ALPHA, BitmapDataChannel.ALPHA);
 
		// EXTRA:
		// this code applies a -1 multiplier to the alpha channel,
		// turning the opaque circle into a transparent circle.
		data.colorTransform(new Rectangle(0, 0, sprite.width, sprite.height), new ColorTransform(0,0,0,-1,0,0,0,255));
		// end EXTRA
 
		output.pixels = data;
		return output;
	}
}