package adapters;

/**
 * ...
 * @author John Doughty
 */
class TwoD implements ITwoD
{

	public var x(default, set):Float;
	public var y(default, set):Float;
	@:isVar	public var width(get, set):Float;
	@:isVar	public var height(get, set):Float;
	
	public function new() 
	{
		
	}
	
	public function set_x(x:Float)
	{
		return this.x = x;
	}
	public function set_y(y:Float)
	{
		return this.y = y;
	}
	
	public function set_width(width:Float)
	{
		return this.width = width;
	}
	public function set_height(height:Float)
	{
		return this.height = height;
	}
	
	public function get_width()
	{
		return width;
	}
	public function get_height()
	{
		return height;
	}
}