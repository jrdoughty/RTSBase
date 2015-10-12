package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import world.Node;
import world.TiledTypes;

/**
 * A FlxState which can be used for the actual gameplay.
 */


 
class PlayState extends FlxState
{
	/**
	 * Function that is called up when to state is created to set it up.
	 */
	var testLevel
	 var testLevelData:Array<Int> = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
	 var width = 4;
	 var nodes:Array<Node> = [];
	override public function create():Void
	{
		super.create();
		
		var i:Int = 0;
		
		for (i in 0...testLevelData.length)
		{
			nodes.push(new Node(i % width * 16, Math.floor(i / width) * 16));
			add(nodes[i]);
		}
	}

	/**
	 * Function that is called when this state is destroyed - you might want to
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();
	}
}