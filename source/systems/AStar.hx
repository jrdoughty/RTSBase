package systems ;
import world.Node;
import flixel.util.FlxColor;
import world.SelfLoadingLevel;

/**
 * ...
 * @author John Doughty
 */
class AStar
{
	private static var path:Array<Node> = [];
	private static var openList:Array<Node> = [];
	private static var closedList:Array<Node> = [];
	private static var pathHeiristic:Int;
	private static var costToMove:Int;
	private static var levelWidth:Int;
	private static var levelHeight:Int;
	private static var end:Node;
	private static var diagonal:Bool = false;
	private static var activeLevel:SelfLoadingLevel;
	
	public static function setActiveLevel(level:SelfLoadingLevel)
	{
		activeLevel = level;
		levelWidth = activeLevel.width;
	}
	
	public static function newPath(start:Node, endNode:Node):Array<Node>
	{
		cleanParentNodes();//ensure everying this ready
		cleanUp();
		
		path = [];
		levelHeight = Math.floor(Node.activeNodes.length / levelWidth);
		end = endNode;
		start.heiristic = calculateHeiristic(start.nodeX, start.nodeY, end.nodeX, end.nodeY);
		start.g = 0;
		openList.push(start);
		createNeighbors();
		if (calculate() && start != endNode)
		{
			cleanUp();
			path.push(end);
			createPath(end);
		}
		else
		{
			path = [];
		}
		cleanParentNodes();
		return path;
	}
	
	private static function cleanParentNodes()
	{
		var i:Int;
		for (i in 0...Node.activeNodes.length)
		{
			Node.activeNodes[i].parentNode = null;
		}
	}
	
	private static function cleanUp()
	{
		var i:Int;
		for (i in 0...Node.activeNodes.length)
		{
			Node.activeNodes[i].animation.play("main");
			Node.activeNodes[i].g = -1;
			Node.activeNodes[i].heiristic = -1;
		}
		closedList = [];
		openList = [];
	}
	private static function createPath(node:Node)
	{
		if (node.parentNode != null)
		{
			path.push(node.parentNode);
			createPath(node.parentNode);
		}
	}
	
	public static function getNext():Node
	{
		if(path.length > 1)
			return path[path.length - 2];
		else
			return path[0];
	}

	public static function getHeiristic():Int
	{
		return pathHeiristic;
	}
	
	private static function calculate()
	{
		var i:Int = 0;
        var closestIndex:Int = -1;

        for (i in 0...openList.length) 
		{
            if (closestIndex == -1) 
			{
                closestIndex = i;
            } 
			else if (openList[i].getFinal() < openList[closestIndex].getFinal()) 
			{
                closestIndex = i;
            }
        }

		for (i in 0...openList[closestIndex].neighbors.length) 
		{
			if (SetupChildNode(openList[closestIndex].neighbors[i], openList[closestIndex]))
			{
				return true;
			}
        }
        closedList.push(openList[closestIndex]);
        openList.splice(closestIndex, 1);

        if (openList.length > 0) 
		{
            return calculate();
        }
		else
		{
			return false;
		}
	}
	
	private static function createNeighbors()
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
	@:extern private static inline function calculateHeiristic (startX:Int, startY:Int, endX:Int, endY:Int) 
	{
        var h = Std.int(10 * Math.abs(startX - endX) + 10 * Math.abs(startY - endY));
        return h;
    }
	
	

    private static function SetupChildNode(childNode:Node, parentNode:Node):Bool 
	{
        var prospectiveG:Int;
        var i:Int;

        childNode.heiristic = calculateHeiristic(childNode.nodeX, childNode.nodeY, end.nodeX, end.nodeY);

        if (childNode.heiristic == 0) 
		{
            childNode.parentNode = parentNode;
            return true;// done if its the end
        }
		else if (childNode.isPassible() == false)
		{
			return false;
		}
		
        if (parentNode.nodeX == childNode.nodeX || parentNode.nodeY == childNode.nodeY) 
		{
            prospectiveG = parentNode.g + 10;
			if (childNode.occupant != null)
			{
				prospectiveG += 100;
			}
        } 
		else 
		{
            prospectiveG = parentNode.g + 14;//should be 14 but I'm sabotaging the heiristic for diagonals unless last resort
        }
        if (prospectiveG + childNode.heiristic < childNode.getFinal() || childNode.g == -1) 
		{
            childNode.parentNode = parentNode;
            childNode.g = prospectiveG;
			var inOpenList:Bool = false;
            for (i in 0...openList.length) 
			{
                if (childNode == openList[i]) 
				{
                    inOpenList = true;
                }
            }
			if (inOpenList == false)
			{
				for (i in 0...closedList.length) 
				{
					if (childNode == closedList[i]) 
					{
						closedList.splice(i, 1);
						break;
					}
				}
				openList.push(childNode);
			}
        }
        return false;
    }
}