package systems;
import haxe.ds.ObjectMap;

/**
 * ...
 * @author John Doughty
 */
class DataCache
{

	static var instance:DataCache;
	
	private var data:Map<Int, Map<String, Map<String, Dynamic>>> = new Map();
	private var dataObjects:Array<Dynamic> = [];
	private function new() 
	{
		
	}
	
	public static function getInstance()
	{
		if (instance == null)
		{
			instance = new DataCache();
		}
		return instance;
	}
	
	public function getData(dObject:Dynamic, name:String)
	{
		var result:Map<String, Dynamic> = new Map();
		var index:Int = dataObjects.indexOf(dObject);
		if(index == -1)
		{
			dataObjects.push(dObject);
			index = dataObjects.indexOf(dObject);
			
			for (n in Reflect.fields(dObject.get(name)))
			{
				result.set(n, Reflect.field(dObject.get(name), n));
			}
			data.set(index, [name => result]);
		}
		else if (data[index].exists(name))
		{
			result = data[dObject][name];
		}
		else
		{
			for (n in Reflect.fields(dObject.get(name)))
			{
				result.set(n, Reflect.field(dObject.get(name), n));
			}
			data[index].set(name, result);
		}
		return result;
	}
}