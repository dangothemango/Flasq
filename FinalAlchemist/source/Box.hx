package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;
import flixel.tweens.FlxTween;

class Box extends FlxSprite
{

	//This is a heavy box, it can only be pushed while the player is green
	//set some physics constants and thats all it really needs

	var player:Player;

    public function new(?X:Float=0, ?Y:Float=0, ?W:Int=10,?H:Int=10)
    {
        super(X,Y);
		x=X;
        y=Y;
		loadBox();
		setGraphicSize(W);
		updateHitbox();
        drag.x=1000;
		solid = true;
		acceleration.y = 1000;
		immovable = false;
    }

	public function attachPlayer(p:Player){
        player=p;
    }
	
	function loadBox(){
		loadGraphic(AssetPaths.crate__png, false, 245, 245);
	}
    
    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
    }
}