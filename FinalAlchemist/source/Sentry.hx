package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;
import flixel.tweens.FlxTween;

class Sentry extends RangedObject
{
	public function new(X:Float = 0, Y:Float = 0) 
	{
		super(X, Y);
		loadSprite();
	}

    override public function update(elapsed:Float):Void
    {

        super.update(elapsed);
    }
	
	private function loadSprite(){
		loadGraphic("assets/images/sentry.png",true);
	}
}