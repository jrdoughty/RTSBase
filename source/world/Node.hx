package world;
import actors.BaseActor;
import flixel.FlxSprite;
import openfl.events.MouseEvent;
import flixel.plugin.MouseEventManager;

/**
 * ...
 * @author John Doughty
 */
class Node extends FlxSprite
{

	public var neighbors:Array<Node>;
	public var parentNode:Node;
	private var occupant:BaseActor = null;
	private var passable:Bool = true;
	public var g:Int = -1;
	public var heiristic:Int = -1;
	public var nodeX:Int;
	public var nodeY:Int;
	private var highlight:FlxSprite;
	
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
		
		MouseEventManager.add(this, onClick, null, onOver, onOut);
		
		highlight = new FlxSprite(x, y).loadGraphic("assets/images/highlight.png", true, 8, 8);
		highlight.animation.add("main", [0, 1, 2, 3, 4, 5, 6], 10);
		highlight.animation.play("main");
	}
	
	public function isPassible():Bool
	{
		return (occupant == null && passable);
	}
	
	private function onOver(sprite:FlxSprite):Void
	{
		PlayState.getLevel().add(highlight);
	}
	
	private function onOut(sprite:FlxSprite):Void
	{
		PlayState.getLevel().remove(highlight);
	}
	
	private function onClick(sprite:FlxSprite):Void
	{
		if (PlayState.getSelectedUnit != null && isPassible())
		{
			PlayState.newPath(this);
		}
		else if (occupant != null)
		{
			PlayState.selectUnit(occupant);
		}
	}
	
	public function resetState():Void
	{
		animation.play("main");
	}
	
	public function setOccupant(o:BaseActor):Void
	{
		occupant = o;
	}
	
	public function getOccupant():BaseActor
	{
		return occupant;
	}
	
	public function getFinal():Int
	{
		return heiristic + g;
	}
}