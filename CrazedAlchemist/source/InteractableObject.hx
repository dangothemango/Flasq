package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;

class InteractableObject extends FlxSprite
{
    public function new(?X:Float=0, ?Y:Float=0, ?W:Int=10,?H:Int=10)
    {
        super();
        x=X;
        y=Y;
        makeGraphic (W,H,FlxColor.WHITE);
    }

    public function interact():Void{trace("?");}

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
    }
}