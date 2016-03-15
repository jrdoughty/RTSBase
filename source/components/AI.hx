package components;
import events.ActionEvent;
/**
 * ...
 * @author John Doughty
 */
class AI extends Component
{
	/**
	 * future class to hold common properties
	 */
	public function new(name:String) 
	{
		super(name);
	}
	
	public function takeAction() 
	{
		entity.dispatchEvent(ActionEvent.TAKE_ACTION, new ActionEvent());
	}
}