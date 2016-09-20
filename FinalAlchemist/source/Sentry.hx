package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;
import flixel.tweens.FlxTween;

class Sentry extends RangedObject
{

    public function new(?X:Float=0, ?Y:Float=0, ?W:Int=10,?H:Int=10)
    {
        super(X-50,Y+50,W,H);
        loadSentry();
        range=150;
        animation.add("fire", [0, 1, 2, 3, 4, 5, 6],10,false);
    }

    override function inRange(){
		var playerStatus = player.getStatus();
		if (playerStatus != "blue"){
			animation.play("fire");
			if (playerStatus != "purple"){
				killPlayer("Shot To Death");
			}
		}
        if (withinRange){
            return;
        }
        withinRange=true;
    }

    override function outOfRange(){
        if (!withinRange){
            return;
        }
        withinRange=false;
    }

	function loadSentry(){
		loadGraphic("assets/images/sentry.png",true,150,39);
		this.angle = 270;
	}
	
    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
		if (isOnScreen()){
			if (angularVelocity == 0){
				angularVelocity = 10;
			}
			else if (angle >= 360){
				angularVelocity = -10;
			}
			else if (angle<=180){
				angularVelocity = 10;
			}
		}
		else {
			angularVelocity = 0;
		}
    }
}