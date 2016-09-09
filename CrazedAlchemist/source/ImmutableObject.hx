package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;

class ImmutableObject extends FlxSprite
{
    public function new(?X:Float=0, ?Y:Float=0)
    {
        super();
        x=X;
        y=Y;
        solid=true;
        immovable=true;
        makeGraphic (1000,100,FlxColor.WHITE);
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
    }
}