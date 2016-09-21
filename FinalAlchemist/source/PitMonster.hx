package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxObject;

class PitMonster extends FlxSprite
{

    public function new(?X:Float=0, ?Y:Float=0, ?W:Int=10,?H:Int=10)
    {
        super(X,Y);
        loadGraphic("assets/images/mr_t.png",true,450,700);
        animation.add("idle",[for (i in 0...31) i],30,true);
        offset.y+=700;
        y+=700;
    }

    function callback(A:FlxObject,B:FlxObject){
        Level.instance.killPlayer("You fell into the mouth of the pit monster\nIn its belly, you will find a new definition of pain and suffering\nas you are slowly ground over a thousand years.");
    }

    override public function update(elapsed:Float):Void
    {
        if (animation.name!="idle"){
            animation.play("idle");
        }
        FlxG.overlap(Level.instance.player,this,callback);
    }
}