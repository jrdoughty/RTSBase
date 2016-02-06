package components;
import interfaces.IEntity;
import haxe.Constraints.Function;
/**
 * ...
 * @author John Doughty
 */
class Entity //implements IEntity
{
	private var components:Map<String, Component> = new Map();
	private var listeners:Map<String, Array<Function>> = new Map();
	public var currentNodes:Array<Node>;
	public var speed:Int;
	public var team:Team;

	public function new() 
	{
		
	}
	
	public function addEvent(name:String, callback:Function)
	{
		if (!listeners.exists(name))
		{
			listeners.set(name, [callback]);
		}
		else if (listeners[name].indexOf(callback) == -1)
		{
			listeners[name].push(callback);
		}
	}
	public function removeEvent(name:String, callback:Function)
	{
		var i:Int;
		if (listeners.exists(name) && listeners[name].indexOf(callback) != -1)
		{
			for (i in 0...listeners[name].length)
			{
				if (listeners[name][i] == callback)
				{
					listeners[name].splice(i, 1);
					break;
				}
			}
		}
	}
	
	public function dispatchEvent(name:String, eventObject:EventObject)
	{
		if (listeners.exists(name))
		{
			for (func in listeners[name])
			{
				func(eventObject);
			}
		}
	}
	
	
	public function addC(component:Component, n:String)
	{
		var name:String;
		if (n == null)
		{
			name = component.defaultName;
		}
		else
		{
			name = n;
		}
		components.set(name, component);
		component.attach(this);
	}
	
	public function removeC(componentName:String)
	{
		components[componentName].detach();
		components.remove(componentName);
	}
	
	public function hasC(componentName:String):Bool
	{
		return components.exists(componentName);
	}
	
	public function getC(componentName:String):Component
	{
		return components[componentName];
	}
	
	public function getCList():Array<Component>
	{
		var result = [];
		for (k in components.keys())
		{
			result.push(components[k]);
		}
		return result;
	}
	
	public function getCIDList():Array<String>
	{
		var result = [];
		for (k in components.keys())
		{
			result.push(k);
		}
		return result;
	}
	
	public function checkView(node:Node = null)
	{
		var n;
		var distance:Float;
		if (node == null)
		{
			node = currentNodes[0];
		}
		for (n in node.neighbors)
		{
			if (threatNodes.indexOf(n) == -1)
			{
				distance = Math.sqrt(Math.pow(Math.abs(currentNodes[0].nodeX - n.nodeX), 2) + Math.pow(Math.abs(currentNodes[0].nodeY - n.nodeY), 2));
				if (distance <= threatRange)
				{
					threatNodes.push(n);
					if (distance < viewRange && n.isPassible())
					{
						checkView(n);
					}
				}
			}
		}
	}
	
}