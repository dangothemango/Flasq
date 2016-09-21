package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;
import flixel.tweens.FlxTween;
import flixel.FlxObject;

class Lift extends FlxSprite
{

    public function new(?X:Float=0, ?Y:Float=0, ?W:Int=10,?H:Int=10)
    {
        super(X,Y);
		x=X;
        y=Y;
		loadLift();
		setGraphicSize(W);
		updateHitbox();
		velocity.y = 500;
    }
	
	function loadLift(){
		loadGraphic(AssetPaths.Lift__png, false, 250, 200);
	}
    
	function callback(A:FlxObject,B:FlxObject){
		velocity.y *= -1;
	}
	
    override public function update(elapsed:Float):Void
    {
		if (isOnScreen()){
			super.update(elapsed);
		}
		FlxG.overlap(Level.instance.level.foregroundTiles, this, callback);
    }
}