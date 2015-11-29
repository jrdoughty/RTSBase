package;
import actors.Building;
import systems.Team;
import actors.SwordSoldier;
import actors.SpearSoldier;
import world.Node;


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
		Teams[0].addUnit(new SwordSoldier(Node.getNodeByGridXY(0,0),this));
		Teams[0].addUnit(new SwordSoldier(Node.getNodeByGridXY(1,0),this));		
		Teams[0].addUnit(new SwordSoldier(Node.getNodeByGridXY(1,1),this));	
		Teams[0].addUnit(new SwordSoldier(Node.getNodeByGridXY(0,1),this));
		Teams[1].addUnit(new SpearSoldier(Node.activeNodes[616],this));
		Teams[1].addUnit(new SpearSoldier(Node.activeNodes[499],this));	
		Teams[0].addBuilding(new Building(Node.activeNodes[2], this));
		Teams[0].addBuilding(new Building(Node.getNodeByGridXY(0,14), this));
	}
}