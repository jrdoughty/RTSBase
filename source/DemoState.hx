package;
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
		levelAssetPath = "assets/data/moreopen.json";
	}
	
	override private function createTeams():Void 
	{
		super.createTeams();
		Teams.push(new Team());
		Teams[0].addUnit(new SwordSoldier(Node.activeNodes[0],this));
		Teams[0].addUnit(new SwordSoldier(Node.activeNodes[50],this));
		Teams[1].addUnit(new SpearSoldier(Node.activeNodes[616],this));
		Teams[1].addUnit(new SpearSoldier(Node.activeNodes[499],this));	
	}
}