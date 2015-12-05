package;
import actors.Building;
import haxe.Resource;
import openfl.Assets;
import systems.Team;
import actors.Soldier;
import actors.Devil;
import world.Node;
import systems.Data;
import actors.CastleDBUnit;


/**
 * ...
 * @author ...
 */
class DemoState extends BaseState
{

	public function new() 
	{
		super();
		levelAssetPath = "assets/data/realisticlvl1.json";
	}
	
	override private function createTeams():Void 
	{
		super.createTeams();
		Teams.push(new Team());
		Teams[0].addUnit(new CastleDBUnit("SoldierSword",Node.getNodeByGridXY(0,0),this));
		Teams[0].addUnit(new CastleDBUnit("SoldierSpear",Node.getNodeByGridXY(1,0),this));		
		Teams[0].addUnit(new CastleDBUnit("OrcAxe",Node.getNodeByGridXY(1,1),this));			
		Teams[0].addUnit(new CastleDBUnit("Wizard",Node.getNodeByGridXY(2,2),this));	
		Teams[0].addUnit(new CastleDBUnit("OrcClub",Node.getNodeByGridXY(0,1),this));
		Teams[1].addUnit(new CastleDBUnit("DevilSpear",Node.activeNodes[616],this));
		Teams[1].addUnit(new CastleDBUnit("DevilWhip",Node.activeNodes[499],this));	
		Teams[1].addUnit(new CastleDBUnit("LizardClaw",Node.getNodeByGridXY(23,13),this));	
		Teams[1].addUnit(new CastleDBUnit("LizardSpear",Node.getNodeByGridXY(19,15),this));	
		Teams[0].addBuilding(new Building(Node.activeNodes[2], this));
		Teams[0].addBuilding(new Building(Node.getNodeByGridXY(0, 14), this));
		
	}
}