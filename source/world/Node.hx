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
	public static var activeNodes = [];
	public var parentNode:Node;
	public var occupant:BaseActor = null;
	public var g:Int = -1;
	public var heiristic:Int = -1;
	public var nodeX:Int;
	public var nodeY:Int;
	private var passable:Bool = true;
	
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
}