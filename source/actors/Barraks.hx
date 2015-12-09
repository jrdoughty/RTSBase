package actors;

/**
 * ...
 * @author John Doughty
 */
class Barraks extends BaseActor
{
	
	private override function setupGraphics() 
	{
		super.setupGraphics();
		loadGraphic("assets/images/building.png");
	}
	
}