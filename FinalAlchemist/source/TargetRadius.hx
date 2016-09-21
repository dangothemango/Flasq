package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;
import flixel.tweens.FlxTween;

class TargetRadius extends RangedObject
{

    var oHeight:Float;

    public function new(?X:Float=0, ?Y:Float=0, ?W:Int=10,?H:Int=10)
    {
        super(X-50,Y+50,W,H);
        loadRadius();
        range = 150;
        
    }

    function loadRadius(){
		loadGraphic(AssetPaths.targetingRadius__png, true, 287,287);
	}

    override public function update(elapsed:Float):Void
    {

        super.update(elapsed);
    }
}