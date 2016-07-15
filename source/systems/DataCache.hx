package systems;
import haxe.ds.ObjectMap;

/**
 * ...
 * @author John Doughty
 */
class DataCache
{

	static var instance:DataCache;
	
	private var data:ObjectMap<Map> = new ObjectMap();
	
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
		var map:Map<String, Map<String, Dynamic>> = new Map();
		if (!data.exists(dObject))
		{
			data.set(dObject, map);
		}
		if (data[dObject].exists(name))
		{
			result = data[dObject][name];
		}
		else
		{
			for (n in Reflect.fields(dObject.get(name)))
			{
				result.set(n, Reflect.field(dObject.get(name), n));
			}
			map.set(name, result);
		}
		return result;
	}
	
	
}