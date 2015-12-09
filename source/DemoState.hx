package;
import actors.Barraks;
import haxe.Resource;
import openfl.Assets;
import systems.Team;
import world.Node;
import systems.Data;
import actors.Unit;
import actors.Building;


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
		Teams[0].addUnit(new Unit("SoldierSword",Node.getNodeByGridXY(0,0),this));
		Teams[0].addUnit(new Unit("SoldierSpear",Node.getNodeByGridXY(1,0),this));		
		Teams[0].addUnit(new Unit("OrcAxe",Node.getNodeByGridXY(1,1),this));			
		Teams[0].addUnit(new Unit("Wizard",Node.getNodeByGridXY(2,2),this));	
		Teams[0].addUnit(new Unit("OrcClub",Node.getNodeByGridXY(0,1),this));
		Teams[1].addUnit(new Unit("DevilSpear",Node.activeNodes[616],this));
		Teams[1].addUnit(new Unit("DevilWhip",Node.activeNodes[499],this));	
		Teams[1].addUnit(new Unit("LizardClaw",Node.getNodeByGridXY(23,13),this));	
		Teams[1].addUnit(new Unit("LizardSpear",Node.getNodeByGridXY(19,15),this));	
		Teams[0].addBuilding(new Building("Barracks",Node.getNodeByGridXY(2,0), this));
		Teams[0].addBuilding(new Building("Barracks",Node.getNodeByGridXY(0, 14), this));
		
	}
}