package components;
import interfaces.Entity;
import haxe.Timer;
/**
 * ...
 * @author John Doughty
 */
class Component
{
	public var defaultName:String;
	public var entity:Entity;
	
	private var actionTimer:Timer;
	private var delayTimer:Timer;
	
	public function new() 
	{
		
	}
	
	public function takeAction()
	{
		
	}
	
	private function delayedStart()
	{
		delayTimer.stop();
		actionTimer = new Timer(entity.speed);
		actionTimer.run = takeAction;
	}
	
	public function attach(e:Entity)
	{
		entity = e;
		init();
	}
	
	public function detach()
	{
		entity = null;
	}
	
	public function init()
	{
		delayTimer = new Timer(Math.floor(1000*Math.random()));//Keeps mass created units from updating at the exact same time. Idea from: http://answers.unity3d.com/questions/419786/a-pathfinding-multiple-enemies-MOVING-target-effic.html
		delayTimer.run = delayedStart;
	}
}