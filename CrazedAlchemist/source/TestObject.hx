package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.math.FlxRandom;

class TestObject extends InteractableObject
{

    var rand:FlxRandom;

    public function new(?X:Float=0, ?Y:Float=0, ?W:Int=10,?H:Int=10)
    {
        super(X,Y,W,H);
        rand=new FlxRandom();
    }

    override public function interact():Void
    {
        trace("Complete Interaction");
        color=rand.color();
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
    }
}