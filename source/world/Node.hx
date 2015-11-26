package world;
import actors.BaseActor;
import flixel.FlxSprite;

/**
 * ...
 * @author John Doughty
 */
class Node extends FlxSprite
{

	public var neighbors:Array<Node> = [];
	public var leftNode:Node;
	public var rightNode:Node;
	public var topNode:Node;
	public var bottomNode:Node;
	public var topLeftNode:Node;
	public var topRightNode:Node;
	public var bottomLeftNode:Node;
	public var bottomRightNode:Node;
	public static var activeNodes = [];
	public var parentNode:Node;
	public var occupant:BaseActor = null;
	public var g:Int = -1;
	public var heiristic:Int = -1;
	public var nodeX:Int;
	public var nodeY:Int;
	private var passable:Bool = true;
	private static inline var diagonal:Bool = false;
	
	public function new(asset:String, frame:Int, width:Int, height, X:Int = 0, Y:Int = 0, pass:Bool = true ) 
	{
		super(X * width, Y * height);
		nodeX = X;
		nodeY = Y;
		loadGraphic(asset, false, width, height);
		animation.add("main",[frame],0,false);
		animation.add("clicked",[9],0,false);
		animation.play("main");
		
		passable = pass;
	}
	
	public function isPassible():Bool
	{
		return (passable);
	}
	
	public function resetState():Void
	{
		animation.play("main");
	}
	
	public function getFinal():Int
	{
		return heiristic + g;
	}
	

    public function getAllFromRight(widthToGo:Int):Array<Node>
    {
        var result:Array<Node> = [];
		
		trace("widthToGo:" + widthToGo);
		
		if (rightNode != null)
		{
			result.push(rightNode);
			if(widthToGo > 0)
			{
				trace("width");
				widthToGo--;
				result = result.concat(rightNode.getAllFromRight(widthToGo));
			}
		}
		else
		{
			trace("Null");
		}
        return result;
    }
	
    public function getAllNodes(widthToGo:Int, heightToGo:Int):Array<Node>
    {
        var result:Array<Node> = [this];
		
		trace("heightToGo:" + heightToGo);
		trace("widthToGo:" + widthToGo);
		
		if (rightNode != null && widthToGo > 0)
		{
			result.concat(getAllFromRight(widthToGo));
		}
		if (bottomNode != null && heightToGo > 0)
		{
			heightToGo--;
			result = result.concat(bottomNode.getAllNodes(widthToGo, heightToGo));
			
		}
        return result;
    }
	
	public static function createNeighbors(levelWidth, levelHeight)
	{
		var i:Int;
		var j:Int;
		for (i in 0...levelWidth) 
		{
            for (j in 0...levelHeight) 
			{
				Node.activeNodes[i + j * levelWidth].neighbors = [];
				if (diagonal)
				{
					if (i - 1 >= 0 && j - 1 >= 0) 
					{
						Node.activeNodes[i + j * levelWidth].neighbors.push(Node.activeNodes[i - 1 + (j - 1) * levelWidth]);
					}
					if (i + 1 < levelWidth && j - 1 >= 0) 
					{
						Node.activeNodes[i + j * levelWidth].neighbors.push(Node.activeNodes[i + 1 + (j - 1) * levelWidth]);
					}
					if (i - 1 >= 0 && j + 1 < levelHeight) 
					{
						Node.activeNodes[i + j * levelWidth].neighbors.push(Node.activeNodes[i - 1 + (j + 1) * levelWidth]);
					}
					if (i + 1 < levelWidth && j + 1 < levelHeight) 
					{
						Node.activeNodes[i + j * levelWidth].neighbors.push(Node.activeNodes[i + 1 + (j + 1) * levelWidth]);
					}
				}
                if (j - 1 >= 0) 
				{
                    Node.activeNodes[i + j * levelWidth].neighbors.push(Node.activeNodes[i + (j - 1) * levelWidth]);
					Node.activeNodes[i + j * levelWidth].topNode = Node.activeNodes[i + (j - 1) * levelWidth];
                }
                if (i - 1 >= 0) 
				{
                    Node.activeNodes[i + j * levelWidth].neighbors.push(Node.activeNodes[i - 1 + j * levelWidth]);
					Node.activeNodes[i + j * levelWidth].leftNode = Node.activeNodes[i - 1 + j * levelWidth];
                }
                if (i + 1 < levelWidth) 
				{
                    Node.activeNodes[i + j * levelWidth].neighbors.push(Node.activeNodes[i + 1 + j * levelWidth]);
					Node.activeNodes[i + j * levelWidth].rightNode = Node.activeNodes[i + 1 + j * levelWidth];
                }
                if (j + 1 < levelHeight) 
				{
                    Node.activeNodes[i + j * levelWidth].neighbors.push(Node.activeNodes[i + (j + 1) * levelWidth]);
					Node.activeNodes[i + j * levelWidth].bottomNode = Node.activeNodes[i + (j + 1) * levelWidth];
                }
            }
        }
	}
}