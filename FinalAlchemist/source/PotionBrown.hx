package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;

class PotionBrown extends Potion
{

    public function new(){super(); color=Potion.BROWN; type=3;colorString = "brown";}

    override public function drink(player:Player){
    	super.drink(player);
    	Level.instance.killPlayer("Acid dissolved your intestines");
    }

    override public function mix(o:Potion):Potion{
    	return this;
    }

}