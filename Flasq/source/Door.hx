package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;
import flixel.tweens.FlxTween;

class Door extends RangedObject
{

	//Door extends ranged object, to detect when the player is close enough for it to open on its own
	//basically just an automatic door. not really important for gameplay.

	//oheight is the original hight of the door object so we can reclose it after its opened
    var oHeight:Float;

    public function new(?X:Float=0, ?Y:Float=0, ?W:Int=10,?H:Int=10)
    {
        super(X,Y,W,H);
        range=150;
        makeGraphic(W,H,0xFF4d4d4d);
        oHeight=H;
        
    }

    private function tweenFunction(s:FlxSprite, v:Float) { 
        s.setGraphicSize(Std.int(s.width),Std.int(v)); 
        updateHitbox();
    }

    function tweenDriver(s:Float,e:Float){
        FlxTween.num(s, e, .25, {}, tweenFunction.bind(this));
    }

    override function inRange(elapsed:Float){
        if (withinRange){
            return;
        }
        withinRange=true;
        tweenDriver(this.height,1);
    }

    override function outOfRange(){
        if (!withinRange){
            return;
        }
        withinRange=false;
        tweenDriver(this.height,oHeight);
    }

    override public function update(elapsed:Float):Void
    {

        super.update(elapsed);
    }
}