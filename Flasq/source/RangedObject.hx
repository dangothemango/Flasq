package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;

class RangedObject extends FlxSprite
{
	//basic ranged item class used for several others
	
    var range:Float;
    var withinRange:Bool=false;
    var pt:FlxPoint;
    var player:Player;

    public function new(?X:Float=0, ?Y:Float=0, ?W:Int=10,?H:Int=10)
    {
        super();
        x=X;
        y=Y;
        width=W;
        height=H;
        pt=new FlxPoint(x+width/2,y+width/2);
    }

    function inRange(elapsed:Float){
        
    }

    function outOfRange(){

    }

    override public function update(elapsed:Float):Void
    {
        if (player!=null){ 
            if(pt.distanceTo(new FlxPoint(player.x,player.y))<range){
               inRange(elapsed);
            } else {
               outOfRange();
            }
        } else {
            player=Level.instance.player;
        }
        super.update(elapsed);
    }
}