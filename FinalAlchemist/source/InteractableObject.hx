package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;

class InteractableObject extends FlxSprite
{

	//Basic class template for objects that react to the c button being pressed. overrride interact with your desired effects

    public function new(?X:Float=0, ?Y:Float=0, ?W:Int=10,?H:Int=10)
    {
        super();
        x=X;
        y=Y;
        width=W;
        height=H;
    }

    public function interact(player:Player):Void{trace("Interact function was not overridden properly");}

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
    }
}