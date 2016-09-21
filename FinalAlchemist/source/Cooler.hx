package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;

class Cooler extends InteractableObject
{

	//inherits from interactable, fills the players bottle when interacted with

    var potion:Potion;
    var onCooldown:Bool=false;

    var t:Float;
    var cd:Float=.5;

    public function new(?X:Float=0, ?Y:Float=0, ?W:Int=10,?H:Int=10)
    {
        super(X,Y,W,H);
    }

    public function fillWith(p:Potion){
        potion=p;
    }

    override public function interact(player:Player):Void{ 
        if (onCooldown) return;
		FlxG.sound.play(AssetPaths.potionFill__wav);
        player.fillBottle(potion); 
        onCooldown=true;
        t=0;
    }

    override public function update(elapsed:Float):Void
    {
    	//cooldown is so people cant accidentally press twice and fill twice when they dont want to
    	//without this was causing a bug where mixing 2 colors would make brown
        if (onCooldown){
            t+=elapsed;
            if (t>=cd){
                onCooldown=false;
            }
        }
        super.update(elapsed);
    }
}