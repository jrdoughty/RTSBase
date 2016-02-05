package interfaces;
import components.Component;
import components.EventObject;
import haxe.Constraints.Function;
import systems.Team;
import world.Node;
import flixel.animation.FlxAnimationController;
/**
 * @author John Doughty
 */
interface IEntity 
{
	private var components:Map<String, Component>;
	public var x(default, set):Float;
	public var y(default, set):Float;
	public var currentNodes:Array<Node>;
	public var animation:FlxAnimationController;
	public var speed:Int;
	public var team:Team;
	public var idleFrame:Int;
	public var attr:Dynamic;
	private var listeners:Map<String, Array<Function>>;
	
	public function addC(component:Component, name:String):Void;
	public function addEvent(name:String, callback:Function):Void;
	public function removeEvent(name:String, callback:Function):Void;
	public function dispatchEvent(name:String, eventObject:EventObject):Void;
	public function removeC(componentName:String):Void;
	public function hasC(componentName:String):Bool;
	public function getC(componentNAme:String):Component;
	public function getCList():Array<Component>;
	public function getCIDList():Array<String>;	
}