package world;
import actors.BaseActor;
import flixel.FlxSprite;

/**
 * ...
 * @author John Doughty
 */
class Node extends FlxSprite
{
	public static var activeNodes = [];
	private static var levelWidth;
	private static var levelHeight;
	private static inline var diagonal:Bool = false;

	public var neighbors:Array<Node> = [];
	public var leftNode:Node;
	public var rightNode:Node;
	public var topNode:Node;
	public var bottomNode:Node;
	public var topLeftNode:Node;
	public var topRightNode:Node;
	public var bottomLeftNode:Node;
	public var bottomRightNode:Node;
	public var parentNode:Node;
	public var occupant:BaseActor = null;
	public var g:Int = -1;
	public var heiristic:Int = -1;
	public var nodeX:Int;
	public var nodeY:Int;
	public var overlay:FlxSprite;
	public var overlayToggled:Bool = false;
	
	private var passable:Bool = true;
	private var wasRemoved:Bool = false;
	private var firstTime:Bool = true;
	
	public function new(asset:String, frame:Int, width:Int, height, X:Int = 0, Y:Int = 0, pass:Bool = true ) 
	{
		super(X * width, Y * height);
		overlay = new FlxSprite(X * width, Y * height);
		nodeX = X;
		nodeY = Y;
		loadGraphic(asset, false, width, height);
		overlay.loadGraphic(asset, false, width, height);
		overlay.animation.frameIndex = 6;
		overlay.alpha = .5;
		
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
		
		if (rightNode != null)
		{
			result.push(rightNode);
			widthToGo--;
			if(widthToGo > 0)
			{
				result = result.concat(rightNode.getAllFromRight(widthToGo));
			}
		}
        return result;
    }
	
	public function removeOverlay()
	{
		overlayToggled = true;
		overlay.alpha = 0;
		if (occupant != null)
		{
			occupant.makeVisible();
		}
		wasRemoved = true;
	}
	
	public function addOverlay()
	{
		if (overlay.alpha == 0)
		{
			wasRemoved = true;
			overlayToggled = true;
		}
		else
		{
			wasRemoved = false;
			overlayToggled = false;
		}
		overlay.alpha = .5;
		if (occupant != null)
		{
			occupant.killVisibility();
		}
	}
	
    public function getAllNodes(widthToGo:Int, heightToGo:Int):Array<Node>
    {
        var result:Array<Node> = [this];
		
		if (rightNode != null && widthToGo > 0)
		{
			result = result.concat(getAllFromRight(widthToGo));
		}
		if (bottomNode != null && heightToGo > 0)
		{
			heightToGo--;
			result = result.concat(bottomNode.getAllNodes(widthToGo, heightToGo));
			
		}
        return result;
    }
	
	public static function getNodeByGridXY(x:Int,y:Int):Node
	{
		var result:Node = null;
		var index:Int = x + y * levelWidth;
		if (activeNodes.length > index)
		{
			result = activeNodes[index];
		}
		return result;
	}
	
	public static function createNeighbors(levelW, levelH)
	{
		var i:Int;
		var j:Int;
		levelWidth = levelW;
		levelHeight = levelH;
		for (i in 0...levelW) 
		{
            for (j in 0...levelH) 
			{
				Node.activeNodes[i + j * levelW].neighbors = [];
				if (diagonal)
				{
					if (i - 1 >= 0 && j - 1 >= 0) 
					{
						Node.activeNodes[i + j * levelW].neighbors.push(Node.activeNodes[i - 1 + (j - 1) * levelW]);
					}
					if (i + 1 < levelW && j - 1 >= 0) 
					{
						Node.activeNodes[i + j * levelW].neighbors.push(Node.activeNodes[i + 1 + (j - 1) * levelW]);
					}
					if (i - 1 >= 0 && j + 1 < levelH) 
					{
						Node.activeNodes[i + j * levelW].neighbors.push(Node.activeNodes[i - 1 + (j + 1) * levelW]);
					}
					if (i + 1 < levelW && j + 1 < levelH) 
					{
						Node.activeNodes[i + j * levelW].neighbors.push(Node.activeNodes[i + 1 + (j + 1) * levelW]);
					}
				}
                if (j - 1 >= 0) 
				{
                    Node.activeNodes[i + j * levelW].neighbors.push(Node.activeNodes[i + (j - 1) * levelW]);
					Node.activeNodes[i + j * levelW].topNode = Node.activeNodes[i + (j - 1) * levelW];
                }
                if (i - 1 >= 0) 
				{
                    Node.activeNodes[i + j * levelW].neighbors.push(Node.activeNodes[i - 1 + j * levelW]);
					Node.activeNodes[i + j * levelW].leftNode = Node.activeNodes[i - 1 + j * levelW];
                }
                if (i + 1 < levelW) 
				{
                    Node.activeNodes[i + j * levelW].neighbors.push(Node.activeNodes[i + 1 + j * levelW]);
					Node.activeNodes[i + j * levelW].rightNode = Node.activeNodes[i + 1 + j * levelW];
                }
                if (j + 1 < levelH) 
				{
                    Node.activeNodes[i + j * levelW].neighbors.push(Node.activeNodes[i + (j + 1) * levelW]);
					Node.activeNodes[i + j * levelW].bottomNode = Node.activeNodes[i + (j + 1) * levelW];
                }
            }
        }
	}
}