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
        super(X-20,Y+30,W,H);
        loadSentry();
        animation.add("fire", [0, 1, 2, 3, 4, 5, 6],10,false);
    }

    override function inRange(){
		animation.play("fire");
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
		loadGraphic("assets/images/sentry.png",true,150);
	}
	
    override public function update(elapsed:Float):Void
    {

        super.update(elapsed);
    }
}