package interfaces;
import components.Component;
import systems.Team;
import world.Node;
import flixel.animation.FlxAnimationController;
/**
 * @author John Doughty
 */
interface Entity 
{
	private var components:Map<String, Component>;
	public var x(default, set):Float;
	public var y(default, set):Float;
	public var currentNodes:Array<Node>;
	public var animation:FlxAnimationController;
	public var speed:Int;
	public var team:Team = null;
	public var idleFrame:Int = 0;
	
	public function addC(component:Component, name:String = null):Void;
	public function removeC(componentName:String):Void;
	public function hasC(componentName:String):Bool;
	public function getC(componentNAme:String):Component;
	public function getCList():Array<Component>;
	public function getCIDList():Array<String>;	
}