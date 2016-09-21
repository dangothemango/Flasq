package;

import flixel.FlxSprite;
import flixel.math.FlxPoint;

class TargetRadius extends FlxSprite
{
	//target radius sprite centered on sentry
    public function new(?X:Float=0, ?Y:Float=0, W:Float, H:Float,r:Int)
    {
        super(X,Y);
        loadRadius();
        setGraphicSize(r*2);
        x=(x+W/2-r);
        y=(y+H/2-r);
        updateHitbox();
        
    }

    function loadRadius(){
		loadGraphic(AssetPaths.targetingRadius__png, true, 287,287);
	}

}