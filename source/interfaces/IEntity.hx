package interfaces;
import components.Component;
import events.EventObject;
import haxe.Constraints.Function;
import systems.Team;
import world.Node;
/**
 * @author John Doughty
 */
interface IEntity 
{
	public var currentNodes:Array<Node>;
	public var team:Team;
	private var listeners:Map<String, Array<Function>>;
	private var components:Map<String, Component>;
	
	public function addC(component:Component, name:String):Void;
	public function addEvent(name:String, callback:Function):Void;
	public function removeEvent(name:String, callback:Function):Void;
	public function dispatchEvent(name:String, eventObject:EventObject = null):Void;
	public function removeC(componentName:String):Void;
	public function hasC(componentName:String):Bool;
	public function getC(componentNAme:String):Component;
	public function getCList():Array<Component>;
	public function getCIDList():Array<String>;	
}