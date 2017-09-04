package;
import haxe.Resource;
import openfl.Assets;
import systems.Team;
import world.Node;
import systems.Data;
import actors.DBActor;
import actors.Building;
import flixel.text.FlxText;
import flixel.FlxG;


/**
 * ...
 * @author ...
 */
class DemoState extends BaseState
{
	private var resourceDisplay:FlxText;
	
	public function new() 
	{
		super();
		levelAssetPath = AssetPaths.realisticlvl1__json;
	}
	
	override private function createTeams():Void 
	{
		super.createTeams();
		Teams.push(new Team());
		Teams.push(new Team());
		Teams[0].addAlly(Teams[2]);
		Teams[0].addUnit(new DBActor("SoldierSword",Node.getNodeByGridXY(0,0)));
		Teams[0].addUnit(new DBActor("SoldierSpear",Node.getNodeByGridXY(1,0)));
		Teams[0].addUnit(new DBActor("OrcAxe",Node.getNodeByGridXY(1,1)));		
		Teams[2].addUnit(new DBActor("Wizard",Node.getNodeByGridXY(2,5)));	
		Teams[0].addUnit(new DBActor("OrcClub",Node.getNodeByGridXY(0,1)));
		Teams[1].addUnit(new DBActor("DevilSpear",Node.activeNodes[616]));
		Teams[1].addUnit(new DBActor("DevilWhip",Node.activeNodes[499]));	
		Teams[1].addUnit(new DBActor("LizardClaw",Node.getNodeByGridXY(23,13)));	
		Teams[1].addUnit(new DBActor("LizardSpear",Node.getNodeByGridXY(19,15)));	
		Teams[0].addBuilding(new Building("Barracks",Node.getNodeByGridXY(2,0)));
		Teams[0].addBuilding(new Building("Barracks", Node.getNodeByGridXY(0, 14)));
		
		//Teams[0].addUnit(new Unit("SoldierSword",Node.getNodeByGridXY(0,0)));
		resourceDisplay = new FlxText(300, 0, 30, "");
		add(resourceDisplay);
		FlxG.sound.playMusic(AssetPaths.Battle_Theme_II_v1__2__mp3);
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		members.remove(resourceDisplay);
		members.push(resourceDisplay);//keep it on top
		resourceDisplay.text = Std.string(activeTeam.resources);
	}
}