package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;

class RangedObject extends FlxSprite
{

    var range:Float;
    var player:Player;
    var withinRange:Bool=false;
    var pt:FlxPoint;

    public function new(?X:Float=0, ?Y:Float=0, ?W:Int=10,?H:Int=10)
    {
        super();
        x=X;
        y=Y;
        width=W;
        height=H;
        pt=new FlxPoint(x,y);
    }

    public function attachPlayer(p:Player){
        player=p;
    }

    function inRange(){
        
    }

    function outOfRange(){

    }

    override public function update(elapsed:Float):Void
    {
        if(pt.distanceTo(new FlxPoint(player.x,player.y))<range){
            inRange();
        } else {
            outOfRange();
        }
        super.update(elapsed);
    }
}