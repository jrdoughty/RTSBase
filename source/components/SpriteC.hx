package components;
import events.GetSpriteEvent;
import events.MoveToEvent;
import events.AnimateAttackEvent;
import events.MoveAnimEvent;
import events.IdleAnimationEvent;
import events.StopEvent;
import events.KillEvent;
import events.HideEvent;
import events.HurtEvent;
import events.RevealEvent;
import events.AddedSpriteEvent;
import adapters.TwoDSprite;
import flixel.FlxG;
import flixel.tweens.FlxTween;

/**
 * ...
 * @author John Doughty
 */
typedef FrameObject = {	var frame:Int;}
 
class SpriteC extends Component
{
	var sprite:TwoDSprite;
	var idleFrame:Int;
	public function new(name:String) 
	{
		super(name);
	}
	private inline function extractFrames(frameObjects:Array<FrameObject>):Array<Int>
	{
		var result:Array<Int> = [];
		for (i in frameObjects)
		{
			result.push(i.frame);
		}
		return result;
	}
	override public function init() 
	{
		super.init();
		var assetPath:String;
		var idleFrames:Array<Int>;
		var attackFrames:Array<Int>;
		var activeFrames:Array<Int>;
		
		if (entity.eData.exists("spriteFile") && entity.currentNodes.length > 0)
		{
			assetPath = "assets" + entity.eData["spriteFile"].substr(2);
			if (entity.eData.exists("speed") && entity.eData.exists("active") && entity.eData.exists("attack") && entity.eData.exists("idle") && entity.eData.exists("width") && entity.eData.exists("height"))
			{
				idleFrames = extractFrames(entity.eData["idle"]);
				attackFrames = extractFrames(entity.eData["attack"]);
				activeFrames = extractFrames(entity.eData["active"]);
				sprite = new TwoDSprite(entity.currentNodes[0].x, entity.currentNodes[0].y, assetPath, entity.eData["width"], entity.eData["height"], entity);
				sprite.addAnimation("active", activeFrames, 5, true);
				sprite.addAnimation("attack", attackFrames, 5, true);
				sprite.addAnimation("idle", idleFrames, 5, true);
				entity.addEvent(IdleAnimationEvent.IDLE, idleAnim);
				entity.addEvent(AnimateAttackEvent.ATTACK, attackAnim);
				entity.addEvent(MoveToEvent.MOVE, moveTo);
				entity.addEvent(MoveAnimEvent.MOVE, activeAnim);
			}
			else 
			{
				sprite = new TwoDSprite(entity.currentNodes[0].x, entity.currentNodes[0].y, assetPath, entity);
			}
			entity.addEvent(RevealEvent.REVEAL, makeVisible);
			entity.addEvent(HideEvent.HIDE, killVisibility);
			entity.addEvent(KillEvent.KILL, kill);
			entity.addEvent(GetSpriteEvent.GET, getSprite);
			
			entity.dispatchEvent(AddedSpriteEvent.ADDED, new AddedSpriteEvent());
			
			FlxG.state.add(sprite);
		}
		else
		{
			entity.removeC(name);
		}
	}	
	/**
	 * sets itself and the health bars to no longer be visible
	 */
	public function killVisibility(e:HideEvent)
	{
		sprite.setVisibility(false);
	}

	
	/**
	 * Sets itself and the health bars to be visible
	 */
	public function makeVisible(e:RevealEvent)
	{
		sprite.setVisibility(true);
	}
	
	public function kill(e:KillEvent)
	{
		sprite.kill();
	}
	
	public function attackAnim(e:AnimateAttackEvent)
	{
		sprite.playAnimation("attack");
	}
	
	public function activeAnim(e:MoveAnimEvent)
	{
		sprite.playAnimation("active");
	}
	
	public function idleAnim(e:IdleAnimationEvent)
	{
		sprite.playAnimation("idle");
	}
	
	public function moveTo(e:MoveToEvent)
	{
		FlxTween.tween(sprite, { x:e.x, y:e.y }, entity.eData["speed"] / 1000);
		FlxTween.tween(entity, { x:e.x, y:e.y }, entity.eData["speed"] / 1000);
	}
	
	public function getSprite(e:GetSpriteEvent)
	{
		if (sprite != null)
		{
			e.callBackFunction(sprite);
		}
	}
}