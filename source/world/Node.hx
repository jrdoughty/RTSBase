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

	private var occupant:BaseActor = null;
	private var passable:Bool = true;
	
	public function new(asset:String, frame:Int, width:Int, height, X:Float = 0, Y:Float = 0, pass:Bool = true ) 
	{
		super(X, Y);
		trace(asset);
		loadGraphic(asset, false, width, height);
		animation.add("main",[frame],0,false);
		animation.add("clicked",[9],0,false);
		animation.play("main");
		
		passable = pass;
		
		MouseEventManager.add(this, onClick, null, null, null);
		
	}
	
	public function isPassible():Bool
	{
		return (occupant != null);
	}
	
	private function onClick(sprite:FlxSprite):Void
	{
		trace(passable);
		PlayState.selectUnit(occupant);
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
}