package world;
import actors.BaseActor;
import events.RevealEvent;
import events.HideEvent;
import adapters.TwoDSprite;

/**
 * ...
 * @author John Doughty
 */
class Node extends TwoDSprite
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
	public var overlay:TwoDSprite;
	
	private var passable:Bool = true;
	
	public function new(asset:String, frame:Int, width:Int, height, X:Int = 0, Y:Int = 0, pass:Bool = true ) 
	{
		super(X * width, Y * height, asset, width, height);
		overlay = new TwoDSprite(X * width, Y * height, asset, width, height);
		nodeX = X;
		nodeY = Y;
		overlay.setCurrentFrame(6);
		overlay.setAlpha(.5);
		if (frame == 7)
		{
			true;
		}
		addAnimation("main",[frame],0,false);
		addAnimation("clicked",[9],0,false);
		playAnimation("main", true);
		setCurrentFrame(frame);
		passable = pass;
	}
	
	public function isPassible():Bool
	{
		return (passable);
	}
	
	public function resetState():Void
	{
		playAnimation("main");
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
		overlay.setAlpha(0);
		if (occupant != null)
		{
			occupant.dispatchEvent(RevealEvent.REVEAL, new RevealEvent());
		}
	}
	
	public function addOverlay()
	{
		overlay.setAlpha(.5);
		if (occupant != null)
		{
			occupant.dispatchEvent(HideEvent.HIDE, new HideEvent());
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