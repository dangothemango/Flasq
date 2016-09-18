package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;

class Cooler extends InteractableObject
{

    var potion:Potion;

    public function new(?X:Float=0, ?Y:Float=0, ?W:Int=10,?H:Int=10)
    {
        super(X,Y,W,H);
    }

    public function fillWith(p:Potion){
        potion=p;
    }

    override public function interact(player:Player):Void{ trace("fill"); player.fillBottle(potion); }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
    }
}